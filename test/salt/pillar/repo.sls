# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# Uses the standard install method from package repo
prometheus:
  wanted:
    clientlibs:
      - golang
      - haskell
      - rust
    component:
      - prometheus
      - alertmanager
      - node_exporter
      - blackbox_exporter
      {%- if grains.os == 'SUSE' %}
      - hacluster_exporter
      - postgres_exporter
      - saptune_exporter
      - webhook_snmp
      {%- endif %}

  exporters:
    node_exporter:
      textfile_collectors_dependencies: []
      textfile_collectors:
        ipmitool:
          enable: false
          remove: false
          pkg: ipmitool
        smartmon:
          enable: false
          remove: false
          pkg: smartmontools
          bash_pkg: bash
          smartctl: /usr/sbin/smartctl

  pkg:
    # yamllint disable-line rule:braces rule:commas
    use_upstream_repo: {{ false if grains.os_family|lower in ('debian','suse',) else true }}
    use_upstream_archive: false

    clientlibs:
      # https://prometheus.io/docs/instrumenting/clientlibs
      # no bash & perl client tarballs are available
      golang:
        version: v1.6.0

    component:
      alertmanager:
        config:
          # yamllint disable-line rule:line-length
          # ref https://github.com/prometheus/alertmanager/blob/master/config/testdata/conf.good.yml
          global:
            smtp_smarthost: 'localhost:25'
            smtp_from: 'alertmanager@example.org'
            smtp_auth_username: 'alertmanager'
            smtp_auth_password: "multiline\nmysecret"
            slack_api_url: "http://mysecret.example.com/"
            {%- if grains.get('oscodename', '') not in ['stretch', 'bionic'] %}
            smtp_hello: "host.example.org"
            http_config:
              proxy_url: 'http://127.0.0.1:1025'
            {%- endif %}
          route:
            group_by: ['alertname', 'cluster', 'service']
            group_wait: 30s
            group_interval: 5m
            repeat_interval: 3h
            receiver: team-X-mails
            routes:
              - match_re:
                  service: ^(foo1|foo2|baz)$
                receiver: team-X-mails
                routes:
                  - match:
                      severity: critical
                    receiver: team-X-mails
          receivers:
            - name: 'team-X-mails'
              email_configs:
                - to: 'team-X+alerts@example.org'

      node_exporter:
        version: v0.18.1
        archive:
          source_hash: b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424
        environ:
          args:
            log.level: debug
            web.listen-address: ":9110"
        service:
          args:
            web.listen-address: ":9110"
            # collector.textfile.directory: /var/tmp/node_exporter

      blackbox_exporter:
        service:
          args:
            web.listen-address: ":9115"

      prometheus:
        service:
          args:
            web.listen-address: 0.0.0.0:9090
        environ:
          args:
            web.listen-address: 0.0.0.0:9090
            log.level: debug
        config:
          # yamllint disable-line rule:line-length
          # ref https://raw.githubusercontent.com/prometheus/prometheus/release-2.10/config/testdata/conf.good.yml
          # my global config
          global:
            # Set the scrape interval to every 15 seconds. Default is every 1 minute
            scrape_interval: 15s
            # Evaluate rules every 15 seconds. The default is every 1 minute
            evaluation_interval: 15s
            # scrape_timeout is set to the global default (10s)

          # Alertmanager configuration
          alerting:
            alertmanagers:
              - static_configs:
                  - targets:
                      - alertmanager1:9093
                      - alertmanager2:9093
                      - alertmanager3:9093

          # Load rules once and periodically evaluate them according to the global
          # 'evaluation_interval'
          rule_files:
            - "first_rules.yml"
            # - "second_rules.yml"

          # A scrape configuration containing exactly one endpoint to scrape:
          scrape_configs:
            # The job name is added as a label `job=<job_name>` to any timeseries
            # scraped from this config
            - job_name: 'prometheus'
              # metrics_path defaults to '/metrics'
              # scheme defaults to 'http'
              static_configs:
                - targets: ['localhost:9090']

            - job_name: pushgateway
              scrape_interval: 5s
              honor_labels: true
              static_configs:
                - targets: ['pushgateway:9091']

            - job_name: 'blackbox'
              # https://github.com/prometheus/blackbox_exporter#prometheus-configuration
              metrics_path: /probe
              params:
                module: [http_2xx]  # Look for a HTTP 200 response
              static_configs:
                - targets:
                    - http://prometheus.io     # Target to probe with http
                    - https://prometheus.io    # Target to probe with https
                    - http://example.com:8080  # Target to probe with http on port 8080
              relabel_configs:
                - source_labels: [__address__]
                  target_label: __param_target
                - source_labels: [__param_target]
                  target_label: instance
                - target_label: __address__
                  replacement: '127.0.0.1:9115'  # real hostname and port

      pushgateway:
        version: v0.8.0
        archive:
          source_hash: 6949866ba9ad0cb88d3faffd4281f17df79281398b4dbd0ec3aab300071681ca
        service:
          args:
            web.listen-address: ":9091"
            web.telemetry-path: "/metrics"

  linux:
    # 'Alternatives system' priority: zero disables (default)
    # yamllint disable-line rule:braces
    altpriority: {{ range(1, 100000) | random }}

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info
    # Note: Any value not evaluated by `config.get` will be used literally
    # This can be used to set custom paths, as many levels deep as required
    files_switch:
      - any/path/can/be/used/here
      - id
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below
    # This is unnecessary in most cases; there are sensible defaults
    # path_prefix: prometheus_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    source_files:
      prometheus-config-file-file-managed:
        - 'alt_config.yml.jinja'
      prometheus-archive-install-managed-service:
        - 'alt_systemd.ini.jinja'
