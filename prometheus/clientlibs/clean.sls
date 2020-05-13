# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- for name in p.wanted.clientlibs %}

prometheus-clientlibs-clean-{{ name }}:
  file.absent:
    - name: {{ p.pkg.clientlibs[name]['path'] }}

    {%- endfor %}
