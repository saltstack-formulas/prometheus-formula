# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if grains.os_family in ('FreeBSD',) %}
    {%- set sls_config_users = tplroot ~ '.config.users' %}
    {%- set sls_service_running = tplroot ~ '.service.running' %}
    {%- set sls_archive_install = tplroot ~ '.archive.install' %}
    {%- set sls_package_install = tplroot ~ '.package.install' %}


include:
  - {{ sls_archive_install if p.pkg.use_upstream_archive else sls_package_install }}
  - {{ sls_config_users }}
  - {{ sls_service_running }}

    {%- for name in p.wanted.component %}
        {%- if 'service' in p.pkg.component[name] and 'args' in p.pkg.component[name]['service'] %}
            {%- set args = p.pkg.component[name]['service']['args'] %}
            {%- if 'storage.tsdb.path' in args.keys() %}

prometheus-service-args-{{ name }}-data-dir:
  file.directory:
    - name: {{ args['storage.tsdb.path'] }}
    - owner: {{ name }}
    - group: {{ name }}
    - makedirs: True
    - watch_in:
      - service: prometheus-service-running-{{ name }}
    - require:
      - user: prometheus-config-user-install-{{ name }}-user-present
      - group: prometheus-config-user-install-{{ name }}-user-present

            {%- endif %}
            {%- if grains.os_family == 'FreeBSD' %}
                {%- if 'collector.textfile.directory' in args.keys() %}

prometheus-service-args-{{ name }}-collector-textfile-directory:
  sysrc.managed:
    - name: {{ name }}_textfile_dir
    - value: {{ args.pop('collector.textfile.directory') }}
    - watch_in:
      - service: prometheus-service-running-{{ name }}

                {%- endif %}
                {%- if 'storage.tsdb.path' in args.keys() %}

prometheus-service-args-{{ name }}-storage-tsdb-path:
  sysrc.managed:
    - name: {{ name }}_data_dir
    - value: {{ args.pop('storage.tsdb.path') }}
    - watch_in:
      - service: prometheus-service-running-{{ name }}

                {%- endif %}
                {%- if 'web.listen-address' in args.keys() %}

prometheus-service-args-{{ name }}-web-listen-address:
  sysrc.managed:
    - name: {{ name }}_listen_address
    - value: {{ args.pop('web.listen-address') }}
    - watch_in:
      - service: prometheus-service-running-{{ name }}

                {%- endif %}

prometheus-service-args-{{ name }}-install:
  sysrc.managed:
    - name: {{ name }}_config
    - value: {{ p.dir.etc }}/{{ name }}.yml
    - watch_in:
      - service: prometheus-service-running-{{ name }}

            {%- endif %}
        {%- endif %}
    {%- endfor %}
{%- endif %}
