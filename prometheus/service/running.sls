# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_args = tplroot ~ '.config.args' %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_config_args }}
  - {{ sls_config_file }}

prometheus-service-running-service-running:
  service.running:
    - name: {{ prometheus.service.name }}
    - enable: True
    - watch:
      - file: prometheus-config-file-file-managed
    - require:
      - sls: {{ sls_config_args }}
      - sls: {{ sls_config_file }}
