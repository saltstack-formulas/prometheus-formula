# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_users_install = tplroot ~ '.config.users' %}

include:
  - {{ sls_users_install }}

prometheus-config-file-basedir-file-directory:
  file.directory:
    - name: {{ p.dir.basedir }}
    - user: prometheus
    - group: prometheus
    - mode: 755
    - makedirs: True
    - require:
      - sls: '{{ sls_users_install }}.*'

  {%- for name in p.wanted %}
      {%- if name in p.pkg %}
          {%- set bundle = name + '-%s.%s-%s'|format(p.pkg[name]['archive_version'], p.kernel, p.arch) %}

prometheus-archive-install-{{ name }}-archive-extracted:
  archive.extracted:
    - name: {{ p.dir.basedir }}
    - source: {{ p.archive.uri }}/{{ name }}/releases/download/v{{ p.pkg[name]['archive_version']
                 + '/' + bundle + '.' + p.archive.suffix }}
    - source_hash: {{ p.pkg[name]['archive_hash'] }}
    - user: {{ name }}
    - group: {{ name }}
    {{- format_kwargs(p.archive.kwargs) }}
    - recurse:
        - user
        - group
    - require:
      - file: prometheus-config-file-basedir-file-directory

          {%- if name in p.service %}

prometheus-archive-install-{{ name }}-file-directory:
  file.directory:
    - name: {{ p.dir.var }}/{{ name }}
    - user: {{ name }}
    - group: {{ name }}
    - mode: 755
    - makedirs: True
    - require:
      - archive: prometheus-archive-install-{{ name }}-archive-extracted
      - file: prometheus-config-file-basedir-file-directory

              {%- if grains.os_family not in ('MacOS', 'FreeBSD', 'Windows') %}

prometheus-archive-install-{{ name }}-managed-service:
  file.managed:
    - name: {{ p.dir.service }}/{{ name }}.service
    - source: {{ files_switch(['systemd.ini.jinja'],
                              lookup='prometheus-archive-install-{{ name }}-managed-service'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ p.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        desc: prometheus - {{ name }} service
        name: {{ name }}
        user: {{ name }}
        group: {{ name }}
        workdir: {{ p.dir.var }}/{{ name }}
        start: {{ p.dir.basedir }}/{{ bundle }}/{{ name }} --config.file {{ p.dir.etc }}/{{ name }}.yml
        stop: '' #not needed
    - require:
      - file: prometheus-archive-install-{{ name }}-file-directory
      - file: prometheus-config-file-basedir-file-directory
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: prometheus-archive-install-{{ name }}-managed-service

              {%- endif %}
          {%- endif %}
      {%- endif %}
  {%- endfor %}
