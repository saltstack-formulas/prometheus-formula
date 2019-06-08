# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_service_clean }}

prometheus-config-clean-file-absent:
  file.absent:
    - names:
       - {{ prometheus.config_file }}
       - {{ prometheus.environ_file }}
    - require:
      - sls: {{ sls_service_clean }}

{%- if salt['grains.get']('os_family') == 'FreeBSD' %}
{%-   for parameter in ['args', 'data_dir'] %}
prometheus-service-args-{{ parameter }}:
  sysrc.absent:
    - name: prometheus_{{ parameter }}
    - require:
      - service: prometheus-service-clean-service-dead
{%-   endfor %}
{%- endif %}
