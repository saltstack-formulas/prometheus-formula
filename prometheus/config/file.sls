# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- set sls_config_users = tplroot ~ '.config.users' %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- set sls_package_install = tplroot ~ '.package.install' %}

include:
  - {{ sls_archive_install if p.pkg.use_upstream_archive else sls_package_install }}
  - {{ sls_config_users }}

prometheus-config-file-etc-file-directory:
  file.directory:
    - name: {{ p.dir.etc }}
    - user: {{ p.identity.rootuser }}
    - group: {{ p.identity.rootgroup }}
    - mode: '0755'
    - makedirs: True
    - require:
      - sls: {{ sls_archive_install if p.pkg.use_upstream_archive else sls_package_install }}

    {%- for name in p.wanted.component %}
        {%- if 'config' in p.pkg.component[name] and p.pkg.component[name]['config'] %}

prometheus-config-file-{{ name }}-file-managed:
  file.managed:
    - name: {{ p.dir.etc }}/{{ name }}.yml
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
        config: {{ p.pkg.component[name]['config']|json }}
    - require:
      - sls: {{ sls_config_users }}
      - file: prometheus-config-file-etc-file-directory

        {%- endif %}
    {%- endfor %}
