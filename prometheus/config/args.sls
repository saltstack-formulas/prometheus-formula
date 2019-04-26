# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/map.jinja" import concat_args %}

{%- if 'args' in prometheus.service %}
{%-   set args = prometheus.service.get('args', {}) -%}

{%-   if 'storage.tsdb.path' in args.keys() %}
prometheus-data-dir:
  file.directory:
    - name: {{ args['storage.tsdb.path'] }}
    - owner: {{ prometheus.service.user }}
    - group: {{ prometheus.service.group }}
    - makedirs: True
    - watch_in:
      - service: prometheus-service-running-service-running
{%-   endif %}

{# FreeBSD #}
{%-   if salt['grains.get']('os_family') == 'FreeBSD' %}
{%-     if 'storage.tsdb.path' in args.keys() %}
{%-       set value = args.pop('storage.tsdb.path') %}
prometheus-config-args-storage-tsdb-path:
  sysrc.managed:
    - name: prometheus_data_dir
    - value: {{ value }}
    - watch_in:
      - service: prometheus-service-running-service-running
{%-     endif %}

prometheus-config-args-all:
  sysrc.managed:
    - name: prometheus_args
    # service prometheus restart tended to hang on FreeBSD
    # https://github.com/saltstack/salt/issues/44848#issuecomment-487016414
    - value: "{{ concat_args(args) }} >/dev/null 2>&1"
    - watch_in:
      - service: prometheus-service-running-service-running

{# Debian #}
{%-   elif salt['grains.get']('os_family') == 'Debian'%}
prometheus-config-args-file-managed:
  file.managed:
    - name: {{ prometheus.args_file }}
    - contents: |
        ARGS="{{ concat_args(args) }}"
    - watch_in:
      - service: prometheus-service-running-service-running
{%-   endif %}
{%- endif %}
