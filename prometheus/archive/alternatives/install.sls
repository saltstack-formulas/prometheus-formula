# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}

  {%- if grains.kernel|lower in ('linux',) and p.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_install }}


      {%- for k in p.archive.wanted %}
          {%- set dir = p.archive.dir + '/' + k + '-%s.%s-%s'|format(p.archive.version["k"], p.kernel, p.arch) %}

prometheus-archive-alternatives-install-{{ k }}-home-alternatives-install:
  cmd.run:
    - onlyif: {{ grains.os_family in ('Suse',) }}
    - name: update-alternatives --install {{ dir }} prometheus-{{ k }}-home {{ dir }} {{p.linux.altpriority}}
    - watch:
      - archive: prometheus-archive-install-{{ k }}-archive-extracted
    - require:
      - sls: {{ sls_archive_install }}
  alternatives.install:
    - name: prometheus-{{ k }}-home
    - link: {{ p.dir }}
    - path: {{ dir }}
    - priority: {{ p.linux.altpriority }}
    - order: 10
    - watch:
        - archive: prometheus-archive-install-{{ k }}-archive-extracted
    - require:
      - sls: {{ sls_archive_install }}
    - onlyif: {{ grains.os_family not in ('Suse',) }}

prometheus-archive-alternatives-install-{{ k }}-home-alternatives-set:
  alternatives.set:
    - name: prometheus-{{ k }}-home
    - path: {{ dir }}
    - require:
      - alternatives: prometheus-archive-alternatives-install-{{ k }}-home-alternatives-install
    - onlyif: {{ grains.os_family not in ('Suse',) }}

          {% for i in p.archive.binaries['k'] %}

prometheus-archive-alternatives-install-{{ k }}-alternatives-install-{{ i }}:
  cmd.run:
    - onlyif: {{ grains.os_family in ('Suse',) }}
    - name: update-alternatives --install /usr/bin/{{i}} prometheus-{{ k }}-{{i}} {{ dir }}/{{i}} {{p.linux.altpriority}}
    - require:
      - cmd: prometheus-archive-alternatives-install-{{ k }}-home-alternatives-install
  alternatives.install:
    - name: prometheus-{{ k }}-{{ i }}
    - link: /usr/bin/{{ i }}
    - path: {{ dir }}/{{ i }}
    - priority: {{ p.linux.altpriority }}
    - order: 10
    - require:
      - alternatives: prometheus-archive-alternatives-install-{{ k }}-home-alternatives-install
    - onlyif: {{ grains.os_family not in ('Suse',) }}

prometheus-archive-alternatives-install-{{ k }}-alternatives-set-{{ i }}:
  alternatives.set:
    - name: prometheus-{{ k }}-{{ i }}
    - path: {{ dir }}/{{ i }}
    - require:
      - alternatives: prometheus-archive-alternatives-install-{{ k }}-alternatives-install-{{ i }}
    - onlyif: {{ grains.os_family not in ('Suse',) }}

          {% endfor %}
     {% endfor %}
  {%- endif %}
