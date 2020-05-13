# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- set sls_repo_clean = '.repo.clean' %}

include:
  - {{ sls_config_clean }}
  - {{ sls_service_clean }}
  - {{ sls_repo_clean }}

    {%- for name in p.wanted.component %}

prometheus-package-clean-{{ name }}-removed:
  pkg.removed:
    - name: {{ name }}
    - require:
      - sls: {{ sls_config_clean }}
      - sls: {{ sls_service_clean }}
      - sls: {{ sls_repo_clean }}

    {%- endfor %}
