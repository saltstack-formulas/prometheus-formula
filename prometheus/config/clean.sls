# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- set sls_archive_clean = tplroot ~ '.archive.clean' %}

include:
  - {{ sls_archive_clean }}
    {%- if prometheus.pkg.use_upstream_archive and kernel|lower == 'linux'  %}
  - .systemd
    {%- endif %}

prometheus-config-clean-file-absent:
  file.absent:
    - names:
      - {{ prometheus.config_file }}
      - {{ prometheus.environ_file }}
    - require:
      - sls: {{ sls_archive_clean }}
