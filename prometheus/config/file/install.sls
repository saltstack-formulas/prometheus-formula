# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}

include:
  - {{ sls_archive_install if prometheus.use_upstream_archive else sls_package_install }}

    {%- for name in prometheus.wanted %}
        {%- if name in prometheus.config or name in prometheus.service %}

prometheus-config-file-{{ name }}-file-managed:
  file.managed:
    - name: {{ prometheus.dir.etc }}/{{ name }}.yml
    - source: {{ files_switch(['config.yml.jinja'],
                              lookup='prometheus-config-file-{{ name }}-file-managed'
                 )
              }}
    - mode: 644
    - user: {{ name }}
    - group: {{ name }}
    - makedirs: True
    - template: jinja
    - context:
        config: {{ '' if name not in prometheus.config else prometheus.config[name]|json }}
    - require:
      - sls: {{ sls_archive_install if prometheus.use_upstream_archive else sls_package_install }}

        {%- endif %}
    {%- endfor %}
