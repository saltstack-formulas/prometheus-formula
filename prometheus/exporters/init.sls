# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

{%- if prometheus.exporters.keys()|length > 0 %}
include:
{%-   for name in prometheus.exporters.keys()|list %}
  - .{{ name }}
{%-   endfor %}
{%- endif %}
