# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_config_clean }}

    {%- if prometheus.pkg.use_upstream_repo %}
include:
  - .repo.clean
    {%- endif %}

prometheus-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ prometheus.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
