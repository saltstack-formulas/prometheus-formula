# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- for name in p.wanted.clientlibs %}

prometheus-client-clean-{{ name }}:
  file.absent:
    - names: {{ p.pkg.clientlibs[name]['path'] }}

    {%- endfor %}
