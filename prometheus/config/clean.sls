# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- set sls_archive_clean = tplroot ~ '.archive.clean' %}
{%- set sls_alternatives_clean = tplroot ~ '.config.alternatives.clean' %}

  {%- if grains.kernel|lower == 'linux' and prometheus.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_clean }}
  - {{ sls_alternatives_clean }}

prometheus-config-clean-file-absent:
  file.absent:
    - names:
      - {{ prometheus.config_file }}
      - {{ prometheus.environ_file }}
    - require:
      - sls: {{ sls_archive_clean }}
      - sls: {{ sls_alternatives_clean }}

  {%- endif %}
