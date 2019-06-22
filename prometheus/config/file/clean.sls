# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_service_clean }}

    {%- for name in prometheus.wanted %}

prometheus-config-file-{{ name }}-file-absent:
  file.absent:
    - name: {{ prometheus.dir.etc }}/{{ name }}.yml
    - require: 
      - sls: {{ sls_service_clean }}

    {%- endfor %}

prometheus-config-file-etc-file-absent:
  file.absent:
    - name: {{ prometheus.dir.etc }}
