# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- from tplroot ~ "/files/macros.jinja" import concat_args %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}

include:
  - {{ sls_archive_install if p.pkg.use_upstream_archive else sls_package_install }}

    {%- for name in p.wanted.component %}
        {%- if 'environ' in p.pkg.component[name] and 'args' in p.pkg.component[name]['environ'] %}
            {%- set args = p.pkg.component[name]['environ']['args'] %}
            {%- if 'storage.tsdb.path' in args.keys() %}

prometheus-service-args-{{ name }}-data-dir:
  file.directory:
    - name: {{ args['storage.tsdb.path'] }}
    - owner: {{ name }}
    - group: {{ name }}
    - makedirs: True
    - watch_in:
      - service: prometheus-service-running-{{ name }}
    - require:
      - user: prometheus-config-users-install-{{ name }}-user-present
      - group: prometheus-config-users-install-{{ name }}-group-present

            {%- endif %}
        {% endif %}
    {% endfor %}