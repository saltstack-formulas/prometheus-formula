# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/map.jinja" import concat_args %}

prometheus-exporters-node-pkg-installed:
  pkg.installed:
    - name: {{ prometheus.exporters.node.pkg.name }}

{%- if 'args' in prometheus.exporters.node %}
{%-   set args = prometheus.exporters.node.get('args', {}) -%}

{# FreeBSD #}
{%-   if salt['grains.get']('os_family') == 'FreeBSD' %}
{%-     if 'web.listen-address' in args.keys() %}
{%-       set value = args.pop('web.listen-address') %}
prometheus-exporters-node-args-web-listen-address:
  sysrc.managed:
    - name: node_exporter_listen_address
    - value: {{ value }}
    - watch_in:
      - service: prometheus-exporters-node-service-running
{%-     endif %}

{%-     if 'collector.textfile.directory' in args.keys() %}
{%-       set value = args.pop('collector.textfile.directory') %}
prometheus-exporters-node-args-collector-textfile-directory:
  sysrc.managed:
    - name: node_exporter_textfile_dir
    - value: {{ value }}
    - watch_in:
      - service: prometheus-exporters-node-service-running
{%-     endif %}

prometheus-exporters-node-args:
  sysrc.managed:
    - name: node_exporter_args
    # service node_exporter restart tended to hang on FreeBSD
    # https://github.com/saltstack/salt/issues/44848#issuecomment-487016414
    - value: "{{ concat_args(args) }} >/dev/null 2>&1"
    - watch_in:
      - service: prometheus-exporters-node-service-running

{# Debian #}
{%-   elif salt['grains.get']('os_family') == 'Debian'%}
prometheus-exporters-node-args:
  file.managed:
    - name: {{ prometheus.exporters.node.config_file }}
    - contents: |
        ARGS="{{ concat_args(args) }}"
    - watch_in:
      - service: prometheus-exporters-node-service-running
{%-   endif %}
{%- endif %}

prometheus-exporters-node-service-running:
  service.running:
    - name: {{ prometheus.exporters.node.service }}
    - enable: True
    - watch:
      - pkg: prometheus-exporters-node-pkg-installed
