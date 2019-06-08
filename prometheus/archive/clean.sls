# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

prometheus-cli-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ prometheus.base_dir }}
