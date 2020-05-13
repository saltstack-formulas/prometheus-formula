# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

{%- set sls_config_install = tplroot ~ '.config.install' %}
{%- set sls_service_install = tplroot ~ '.service.install' %}
{%- set sls_repo_install = '.repo.install' %}

include:
  - {{ sls_config_install }}
  - {{ sls_service_install }}
  - {{ sls_repo_install }}

    {%- for name in p.wanted.component %}

prometheus-package-install-{{ name }}-installed:
  pkg.installed:
    - name: {{ p.pkg.component[name].get(name, {}).get('name', name) }}
    - require:
      - sls: {{ sls_repo_install }}
    - require_in:
      - sls: {{ sls_config_install }}
      - sls: {{ sls_service_install }}

    {%- endfor %}
