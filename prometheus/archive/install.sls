# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

prometheus-archive-install-file-directory:
  file.directory:
    - names:
      - {{ p.dir.basedir }}
      - {{ p.dir.etc }}
      - {{ p.dir.var }}
    - user: prometheus
    - group: prometheus
    - mode: 755
    - makedirs: True

  {%- for name in p.wanted %}
      {%- set bundle = name + '-%s.%s-%s'|format(p.pkg[name]['archive_version'], p.kernel, p.arch) %}

prometheus-archive-install-{{ name }}-user-present:
  group.present:
    - name: {{ name }}
    - require_in:
      - user: prometheus-archive-install-{{ name }}-user-present
  user.present:
    - name: {{ name }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ name }}
    - require_in:
      - archive: prometheus-archive-install-{{ name }}-archive-extracted

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

      {%- endif %}
  {%- endfor %}
