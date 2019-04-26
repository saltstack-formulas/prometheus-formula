# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_config_file }}

{%- if prometheus.service.sysrc %}
prometheus_args:
  sysrc.managed:
    # service prometheus restart tended to hang on FreeBSD
    # https://github.com/saltstack/salt/issues/44848#issuecomment-487016414
    - value: "{{ prometheus.service.flags }} >/dev/null 2>&1"
{%- endif %}

prometheus-service-running-service-running:
  service.running:
    - name: {{ prometheus.service.name }}
    - enable: True
    - watch:
      - file: prometheus-config-file-file-managed
{%- if prometheus.service.sysrc %}
      - sysrc: prometheus_args
{%- endif %}
    - require:
      - sls: {{ sls_config_file }}
