# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

    {%- for k in p.archive.wanted %}

prometheus-archive-install-{{ k }}-file-directory:
  file.directory:
    - name: {{ p.archive.dir }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require_in:
      - archive: prometheus-archive-install-{{ k }}-archive-extracted
    - recurse:
        - user
        - group
        - mode

prometheus-archive-install-{{ k }}-archive-extracted:
  archive.extracted:
    - name: {{ p.archive.dir }}
    - source: {{ p.archive.uri + '/' + k + '/releases/download/v' + p.archive.versions[k]
               + '/' + k + '-%s.%s-%s'|format(p.archive.versions[k], p.kernel, p.arch)
               + '.' + p.archive.suffix }}
    - source_hash: {{ p.archive.hashes[k] }} 
    - user: root
    - group: root
    {{- format_kwargs(p.archive.kwargs) }}
    - recurse:
        - user
        - group

    {%- endfor %}
