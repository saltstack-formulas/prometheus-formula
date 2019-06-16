# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- set sls_archive_install = tplroot ~ '.archive.install' %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

  {%- if grains.kernel|lower == 'linux' and prometheus.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_install }}

prometheus-package-archive-install-home-alternative-install:
  cmd.run:
    - name: update-alternatives --install {{ prometheus.dir }} prometheus-home {{ prometheus.base_dir }} {{prometheus.linux.altpriority}}
    - watch:
      - archive: prometheus-package-archive-install-archive-extracted
    - require:
      - sls: {{ sls_archive_install }}
    - onlyif: {{ grains.os_family in ('Suse',) }}
  alternatives.install:
    - name: prometheus-home
    - link: {{ prometheus.dir }}
    - path: {{ prometheus.base_dir }}
    - priority: {{ prometheus.linux.altpriority }}
    - order: 10
    - watch:
        - archive: prometheus-package-archive-install-archive-extracted
    - unless: {{ grains.os_family in ('Suse',) }}
    - require:
      - sls: {{ sls_archive_install }}

prometheus-package-archive-install-home-alternative-set:
  alternatives.set:
    - name: prometheus-home
    - path: {{ prometheus.base_dir }}
    - require:
      - alternatives: prometheus-package-archive-install-home-alternative-install
    - unless: {{ grains.os_family in ('Suse',) }}

      {% for i in ['prometheus', 'promtool'] %}

prometheus-package-archive-install-{{ i }}-alternative-install:
  cmd.run:
    - name: update-alternatives --install /usr/bin/{{i}} link-{{i}} {{ prometheus.base_dir }}/{{i}} {{prometheus.linux.altpriority}}
    - require:
      - cmd: prometheus-package-archive-install-home-alternative-install
    - onlyif: {{ grains.os_family in ('Suse',) }}
  alternatives.install:
    - name: link-{{ i }}
    - link: /usr/bin/{{ i }}
    - path: {{ prometheus.base_dir }}/{{ i }}
    - priority: {{ prometheus.linux.altpriority }}
    - order: 10
    - require:
      - alternatives: prometheus-package-archive-install-home-alternative-install
    - unless: {{ grains.os_family in ('Suse',) }}

prometheus-package-archive-install-{{ i }}-alternative-set:
  alternatives.set:
    - name: link-{{ i }}
    - path: {{ prometheus.base_dir }}/{{ i }}
    - require:
      - alternatives: prometheus-package-archive-install-{{ i }}-alternative-install
    - unless: {{ grains.os_family in ('Suse',) }}

     {% endfor %}
  {%- endif %}
