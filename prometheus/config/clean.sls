# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import golang with context %}
{%- set sls_archive_clean = tplroot ~ '.archive.clean' %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

  {%- if grains.kernel|lower == 'linux' and golang.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_clean }}


golang-package-archive-remove-home-alternative-remove:
  alternatives.remove:
    - name: golang-home
    - path: {{ golang.base_dir }}/go
    - onlyif: update-alternatives --get-selections |grep ^golang-home
    - require:
      - sls: {{ sls_archive_clean }}

      {% for i in ['go', 'godoc', 'gofmt'] %}

golang-package-archive-remove-{{ i }}-alternative-remove:
  alternatives.remove:
    - name: link-{{ i }}
    - path: {{ golang.base_dir }}/go/bin/{{ i }}
    - onlyif: update-alternatives --get-selections |grep ^link-{{ i }}
    - require:
      - sls: {{ sls_archive_clean }}

     {% endfor %}
  {%- endif %}
