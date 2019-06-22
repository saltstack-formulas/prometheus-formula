# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

prometheus-exporters-node-service-dead:
  service.dead:
    - name: {{ prometheus.exporters.node.service }}
    - enable: False

prometheus-exporters-node-pkg-removed:
  pkg.removed:
    - name: {{ prometheus.exporters.node.pkg.name }}
    - require:
      - service: prometheus-exporters-node-service-dead

{# FreeBSD #}
{%- if salt['grains.get']('os_family') == 'FreeBSD' %}
{%-   for parameter in ['args', 'listen_address', 'textfile_dir'] %}
prometheus-exporters-node-args-{{ parameter }}:
  sysrc.absent:
    - name: node_exporter_{{ parameter }}
    - require:
      - service: prometheus-exporters-node-service-dead
{%-   endfor %}
{%- endif %}
