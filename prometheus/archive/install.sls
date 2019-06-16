# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

prometheus-package-archive-install-file-directory:
  file.directory:
    - name: {{ prometheus.pkg.archive.name }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require_in:
      - archive: prometheus-package-archive-install-archive-extracted
    - recurse:
        - user
        - group
        - mode

prometheus-package-archive-install-archive-extracted:
  archive.extracted:
    {{- format_kwargs(prometheus.pkg.archive) }}
    - retry:
        attempts: 3
        until: True
        interval: 60
        splay: 10
    - user: root
    - group: root
    - recurse:
        - user
        - group
