# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ '.archive' if prometheus.use_upstream_archive else '.package' }}
  - .config
  - .service
