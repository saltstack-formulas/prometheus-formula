# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

        {%- if 'textfile_collectors' in p.exporters.node_exporter %}
include:
  - .textfile_collectors.clean
        {%- endif %}
