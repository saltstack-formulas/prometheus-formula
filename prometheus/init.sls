#.-*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

include:
  - {{ '.archive' if p.pkg.use_upstream_archive else '.package' }}
  - .config
  - .service
  - .exporters
  - .clientlibs
