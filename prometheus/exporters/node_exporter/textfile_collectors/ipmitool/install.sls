# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

{%- set name = 'node_exporter' %}
{%- set config = p.exporters[name]['textfile_collectors']['ipmitool'] %}
{%- set dir = {{ p.pkg.component[name]['service']['args']['collector.textfile.directory'] }}
{%- set script = p.dir.archive ~ '/textfile_collectors/ipmitool' %}
{%- set cmd_prefix = 'awk -f ' if grains.os_family in ['FreeBSD'] else '' %}

prometheus-exporters-install-{{ name }}-textfile_collectors-ipmitool:
  pkg.installed:
    - name: {{ config.pkg }}
  file.managed:
    - name: {{ script }}
    - source: salt://prometheus/exporters-install/{{ name }}/textfile_collectors/files/ipmitool
        {%- if grains.os != 'Windows' %}
    - mode: 755
        {%- endif %}
  cron.present:
    - identifier: prometheus-exporters-{{ name }}-textfile_collectors-ipmitool-cronjob
    - name: cd {{ dir }} && LANG=C ipmitool sensor | {{ cmd_prefix }}{{ script }} > .ipmitool.prom$$; mv .ipmitool.prom$$ ipmitool.prom
    - minute: "{{ config.get('minute', '*') }}"
    - comment: Prometheus' {{ name }}'s ipmitool textfile collector
    - require:
      - file: prometheus-exporters-install-{{ name }}-textfile_collectors-ipmitool
