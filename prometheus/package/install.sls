# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_repo_install = tplroot ~ '.package.repo.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_repo_install }}

    {%- for name in p.wanted.component %}

prometheus-package-install-{{ name }}-installed:
  pkg.installed:
    - name: {{ p.pkg.component[name].get('name', name) }}
    - require:
      - sls: {{ sls_repo_install }}
    - require_in:
      - sls: {{ sls_service_running }}
    - reload_modules: true

    {%- endfor %}
