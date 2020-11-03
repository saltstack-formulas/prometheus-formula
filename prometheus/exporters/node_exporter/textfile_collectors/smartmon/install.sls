# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

{%- set name = 'node_exporter' %}
{%- set config = p.exporters[name]['textfile_collectors']['smartmon'] %}
{%- set dir = {{ p.pkg.component[name]['service']['args']['collector.textfile.directory'] }}
{%- set script = p.dir.archive ~ '/textfile_collectors/smartmon.sh' %}

prometheus-exporters-install-{{ name }}-textfile_collectors-smartmon:
  pkg.installed:
    - names:
      - {{ config.pkg }}
      - {{ config.bash_pkg }}
  file.managed:
    - name: {{ script }}
    - source: salt://prometheus/exporters/{{ name }}/textfile_collectors/files/smartmon.sh.jinja
    - template: jinja
    - context:
        smartctl: {{ config.smartctl }}
            {%- if grains.os != 'Windows' %}
    - mode: 755
            {%- endif %}
  cron.present:
    - identifier: prometheus-exporters-{{ name }}-textfile_collectors-smartmon-cronjob
    - name: cd {{ dir }} && LANG=C {{ script }} > .smartmon.prom$$ && mv .smartmon.prom$$ smartmon.prom
    - minute: "{{ config.get('minute', '*') }}"
    - comment: Prometheus' {{ name }}'s smartmon textfile collector
    - require:
      - file: prometheus-exporters-install-{{ name }}-textfile_collectors-smartmon
