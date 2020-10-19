# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

{%- set name = 'node_exporter' %}
{%- if name in p.wanted.comp and 'service' in p.pkg.comp[name] %}

    {%- if 'collector' in p.pkg.comp[name]['service']['args'] %}
prometheus-exporters-{{ name }}-collector-textfile-dir-absent:
  file.absent:
    - names:
      - {{ p.pkg.comp[name]['service']['args']['collector.textfile.directory'] }}
      - {{ p.dir.textfile_collectors }}
    {%- endif %}

include:
    {%- for k, v in p.get('exporters', {}).get(name, {}).get('textfile_collectors', {}).items() %}
  - .{{ k }}.clean
    {%- endfor %}
{%- endif %}

