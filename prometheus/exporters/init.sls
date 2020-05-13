# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- if 'node_exporter' in p.wanted.component and 'exporters' in p and 'node_exporter' in p.exporters %}

include:
  - .node_exporter

    {%- endif %}
