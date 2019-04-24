# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

prometheus-service-clean-service-dead:
  service.dead:
    - name: {{ prometheus.service.name }}
    - enable: False

{%- if prometheus.service.use_sysrc %}
prometheus_flags:
  sysrc.absent:
    - require:
      - service: prometheus-service-clean-service-dead
{%- endif %}
