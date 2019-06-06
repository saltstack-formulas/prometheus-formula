# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

prometheus-package-repo-clean-pkgrepo-absent:
  pkgrepo.absent:
    - name: {{ prometheus.pkg.repo.name }}
