# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

prometheus-node_exporter-textfile_collectors-dir:
  file.directory:
    - name: {{ prometheus.dir.textfile_collectors }}
    - mode: 755
    - user: node_exporter
    - group: node_exporter
    - makedirs: True

prometheus-node_exporter-textfile-dir:
  file.directory:
    - name: {{ prometheus.service.node_exporter.args.get('collector.textfile.directory') }}
    - mode: 755
    - user: node_exporter
    - group: node_exporter
    - makedirs: True

{%- set states = [] %}
{%- for collector, config in prometheus.get('exporters', {}).get('node_exporter', {}).get('textfile_collectors', {}).items() %}
{%-     if config.get('enable', False) %}
{%-         if config.get('remove', False) %}
{%-             set state = ".{}.clean".format(collector) %}
{%-         else %}
{%-             set state = ".{}".format(collector) %}
{%-         endif %}
{%-         do states.append(state) %}
{%-     endif %}
{%- endfor %}


{%- if states|length > 0 %}
prometheus-node_exporter-textfile-dependencies:
  pkg.installed:
    - pkgs: {{ prometheus.exporters.node_exporter.textfile_collectors_dependencies }}
    - require_in:
{%-     for state in states %}
      - sls: prometheus.config.node_exporter.textfile_collectors{{ state }}
{%-     endfor %}

include:
{%-     for state in states %}
  - {{ state }}
{%      endfor %}
{%- endif %}
