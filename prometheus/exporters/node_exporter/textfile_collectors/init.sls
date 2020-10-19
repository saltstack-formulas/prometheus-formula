# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_config_users = tplroot ~ '.config.users' %}

include:
  - {{ sls_config_users }}

{%- set states = [] %}

{%- set name = 'node_exporter' %}
{%- if name in p.wanted.comp and 'service' in p.pkg.comp[name] %}

    {%- if 'collector' in p.pkg.comp[name]['service']['args'] %}
prometheus-exporters-{{ name }}-collector-textfile-dir:
  file.directory:
    - name: {{ p.pkg.comp[name]['service']['args']['collector.textfile.directory'] }}
    - mode: 755
    - user: {{ name }}
    - group: {{ name }}
    - makedirs: True
    - requre:
      - user: prometheus-config-user-install-{{ name }}-user-present
      - group: prometheus-config-user-install-{{ name }}-user-present
    {%- endif %}

{%- for k, v in p.get('exporters', {}).get(name, {}).get('textfile_collectors', {}).items() %}
{%-     if v.get('enable', False) %}
{%-         if v.get('remove', False) %}
{%-             set state = ".{}.clean".format(k) %}
{%-         else %}
{%-             set state = ".{}".format(k) %}
{%-         endif %}
{%-         do states.append(state) %}
{%-     endif %}
{%- endfor %}

    {%- if states|length > 0 and p.exporters[name]['textfile_collectors_dependencies'] %}
prometheus-exporters-{{ name }}-textfile-dependencies:
  pkg.installed:
    - pkgs: {{ p.exporters[name]['textfile_collectors_dependencies'] }}
    - require_in:
{%-     for state in states %}
      - sls: p.pkg.comp[name]['config'][textfile_collectors{{ state }}
{%-     endfor %}

include:
{%-     for state in states %}
  - {{ state }}
{%      endfor %}
    {%- endif %}
{%- endif %}
