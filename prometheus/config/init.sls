# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import golang with context %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

  {%- if grains.kernel|lower == 'linux' and golang.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_install }}

golang-package-archive-install-home-alternative-install:
  cmd.run:
    - name: update-alternatives --install {{ golang.go_root }} golang-home {{ golang.base_dir }}/go {{ golang.linux.altpriority }}
    - watch:
      - archive: golang-package-archive-install-archive-extracted
    - require:
      - sls: {{ sls_archive_install }}
    - onlyif: {{ grains.os_family in ('Suse',) }}
  alternatives.install:
    - name: golang-home
    - link: {{ golang.go_root }}
    - path: {{ golang.base_dir }}/go
    - priority: {{ golang.linux.altpriority }}
    - order: 10
    - watch:
        - archive: golang-package-archive-install-archive-extracted
    - unless: {{ grains.os_family in ('Suse',) }}
    - require:
      - sls: {{ sls_archive_install }}

golang-package-archive-install-home-alternative-set:
  alternatives.set:
    - name: golang-home
    - path: {{ golang.base_dir }}/go
    - require:
      - alternatives: golang-package-archive-install-home-alternative-install
    - unless: {{ grains.os_family in ('Suse',) }}

      {% for i in ['go', 'godoc', 'gofmt'] %}

golang-package-archive-install-{{ i }}-alternative-install:
  cmd.run:
    - name: update-alternatives --install /usr/bin/{{i}} link-{{i}} {{ golang.base_dir }}/go/bin/{{i}} {{golang.linux.altpriority}}
    - require:
      - cmd: golang-package-archive-install-home-alternative-install
    - onlyif: {{ grains.os_family in ('Suse',) }}
  alternatives.install:
    - name: link-{{ i }}
    - link: /usr/bin/{{ i }}
    - path: {{ golang.base_dir }}/go/bin/{{ i }}
    - priority: {{ golang.linux.altpriority }}
    - order: 10
    - require:
      - alternatives: golang-package-archive-install-home-alternative-install
    - unless: {{ grains.os_family in ('Suse',) }}

golang-package-archive-install-{{ i }}-alternative-set:
  alternatives.set:
    - name: link-{{ i }}
    - path: {{ golang.base_dir }}/go/bin/{{ i }}
    - require:
      - alternatives: golang-package-archive-install-{{ i }}-alternative-install
    - unless: {{ grains.os_family in ('Suse',) }}

     {% endfor %}
  {%- endif %}
