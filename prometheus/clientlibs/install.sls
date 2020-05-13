# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}

include:
  - {{ sls_archive_install if p.pkg.use_upstream_archive else sls_package_install }}

    {%- for name in p.wanted.client %}

prometheus-client-install-{{ name }}:
  file.directory:
    - name: {{ p.pkg.clientlibs[name]['path'] }}
    - user: {{ p.identity.rootuser }}
    - group: {{ p.identity.rootgroup }}
    - mode: '0755'
    - makedirs: True
    - require:
      - sls: {{ sls_config_users }}
    - require_in:
      - archive: prometheus-client-install-{{ name }}
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(p.pkg.clientlibs[name]['archive']) }}
    - trim_output: true
    - enforce_toplevel: false
    - options: --strip-clients=1
    - retry: {{ p.retry_option|json }}
    - user: {{ p.identity.rootuser }}
    - group: {{ p.identity.rootgroup }}

    {%- endfor %}
