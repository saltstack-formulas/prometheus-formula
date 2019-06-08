# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in prometheus and prometheus.config %}
    {%- if prometheus.pkg.use_upstream_archive %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.package.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

prometheus-config-file-file-managed-config_file:
  file.managed:
    - name: {{ prometheus.config_file }}
    - source: {{ files_switch(['prometheus.yml.jinja'],
                              lookup='prometheus-config-file-file-managed-config_file'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ prometheus.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        config: {{ prometheus.config|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
