# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_archive_install if prometheus.pkg.use_upstream_archive else sls_package_install }}

prometheus-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ prometheus.environ_file }}
    - source: {{ files_switch(['prometheus.sh.jinja'],
                              lookup='prometheus-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ prometheus.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        prometheus: {{ prometheus|json }}
    - require:
      - sls: {{ sls_archive_install if prometheus.pkg.use_upstream_archive else sls_package_install }}
