#.-*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- if p.pkg.use_upstream_archive %}

include:
  - .install
  - .alternatives

    {%- endif %}
