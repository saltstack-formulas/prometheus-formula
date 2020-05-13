# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- if 'exporters' in p and p.exporters and 'node_exporter' in p.exporters %}

include:
  - .node_exporter.clean

    {%- endif %}
