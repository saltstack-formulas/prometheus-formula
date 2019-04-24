# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

prometheus-config-file-file-managed:
  file.managed:
    - name: {{ prometheus.config_file }}
    - source: {{ files_switch(['prometheus.yml.jinja'],
                              lookup='prometheus-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ prometheus.rootgroup }}
    - template: jinja
    - context:
        config: {{ prometheus.config|json }}
    - require:
      - sls: {{ sls_package_install }}
