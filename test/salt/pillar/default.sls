# -*- coding: utf-8 -*-
# vim: ft=yaml
---
prometheus:
  wanted:
    clientlibs:
      - golang
      - haskell
      - rust
    component:
      # List components (ie, exporters) using underscores and
      # removing the 'prometheus' prefix
      - prometheus
      - alertmanager
      - node_exporter
      - blackbox_exporter
      - consul_exporter
      - php-fpm_exporter
      - postgres_exporter
      - mysqld_exporter
      # - memcached_exporter  # not in upstream repo, only archive

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
    use_upstream_repo: false
    use_upstream_archive: true

    clientlibs:
      # https://prometheus.io/docs/instrumenting/clientlibs
      # no bash & perl client tarballs are available
      golang:
        version: v1.6.0
    component:
      # If you use OS packages in Debian's family, components should have
      # a 'name' variable stating the name of the package (it's generally
      # something like `prometheus-component-with-dashes-replacing-underscores`
      # ie,
      # node_exporter:
      #   name: prometheus-node-exporter
      #
      # See prometheus/osfamilymap.yaml for more examples
      alertmanager:
        config:
          # yamllint disable-line rule:line-length
          # ref https://github.com/prometheus/alertmanager/blob/master/config/testdata/conf.good.yml
          global:
            smtp_smarthost: 'localhost:25'
            smtp_from: 'alertmanager@example.org'
            smtp_auth_username: 'alertmanager'
            smtp_auth_password: "multiline\nmysecret"
            smtp_hello: "host.example.org"
            slack_api_url: "http://mysecret.example.com/"
            http_config:
              proxy_url: 'http://127.0.0.1:1025'
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
        service:
          args:
            web.listen-address: ":9110"
            # collector.textfile.directory: /var/tmp/node_exporter

      blackbox_exporter:
        service:
          args:
            web.listen-address: ":9115"
        config_file: /opt/prometheus/blackbox_exporter-v0.18.0/blackbox.yml

      consul_exporter:
        service:
          # This is to test that any fancy name we use, will work in archive mode
          name: my-fancy-consul-exporter-service

      mysqld_exporter:
        service:
          args:
            web.listen-address: 0.0.0.0:9192
          env:
            - 'DATA_SOURCE_NAME=foo:bar@/'

      prometheus:
        service:
          args:
            web.listen-address: 0.0.0.0:9090
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

      # Unoffical php fpm exporter config
      php-fpm_exporter:
        version: v0.6.1
        archive:
          official: false
          tar: false
          # yamllint disable-line rule:line-length
          source: https://github.com/bakins/php-fpm-exporter/releases/download/v0.6.1/php-fpm-exporter.linux.amd64
          source_hash: 40e52d84f7decb5fdad9fadacf63cb2de26ebddce56e11b20651555e8d6c6130
        service:
          args:
            addr: ":9253"
            fastcgi: "unix:///run/php/php-fpm.sock"

      postgres_exporter:
        version: v0.8.0
        service:
          env:
            - 'DATA_SOURCE_NAME=foo:bar@/'
        archive:
          official: false
          # yamllint disable-line rule:line-length
          source: https://github.com/wrouesnel/postgres_exporter/releases/download/v0.8.0/postgres_exporter_v0.8.0_linux-amd64.tar.gz
          skip_verify: true

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
