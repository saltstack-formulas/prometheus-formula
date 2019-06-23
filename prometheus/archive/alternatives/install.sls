# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_archive_install = tplroot ~ '.archive' %}

    {%- if grains.kernel|lower in ('linux',) and p.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_install }}

       {%- for name in p.wanted %}
           {%- set bundle = name + '-%s.%s-%s'|format(p.pkg[name]['archive_version'], p.kernel, p.arch) %}
           {%- if grains.os_family == 'Suse' %}

prometheus-archive-alternatives-install-{{ name }}-home-cmd-run:
  cmd.run:
    - name: update-alternatives --install {{ p.dir.basedir }}/{{ name }} prometheus-{{ name }}-home {{ p.dir.basedir }}/{{ bundle }} {{p.linux.altpriority}}
    - watch:
      - archive: prometheus-archive-install-{{ name }}-archive-extracted

           {%- else %}

prometheus-archive-alternatives-install-{{ name }}-home-alternatives-install:
  alternatives.install:
    - name: prometheus-{{ name }}-home
    - link: {{ p.dir.basedir }}/{{ name }}
    - path: {{ p.dir.basedir }}/{{ bundle }}
    - priority: {{ p.linux.altpriority }}
    - order: 10
    - watch:
        - archive: prometheus-archive-install-{{ name }}-archive-extracted
    - onlyif: {{ grains.os_family not in ('Suse',) }}

prometheus-archive-alternatives-install-{{ name }}-home-alternatives-set:
  alternatives.set:
    - name: prometheus-{{ name }}-home
    - path: {{ p.dir.basedir }}/{{ bundle }}
    - require:
      - cmd: prometheus-archive-alternatives-install-{{ name }}-home-cmd-run
      - alternatives: prometheus-archive-alternatives-install-{{ name }}-home-alternatives-install

           {%- endif %}
           {% for b in p.pkg[name]['binaries'] %}
              {%- if grains.os_family == 'Suse' %}

prometheus-archive-alternatives-install-{{ name }}-cmd-run-{{ b }}-alternative:
  cmd.run:
    - onlyif: {{ grains.os_family in ('Suse',) }}
    - name: update-alternatives --install /usr/local/bin/{{ b }} prometheus-{{ name }}-{{ b }} {{ p.dir.basedir }}/{{ bundle }}/{{ b }} {{ p.linux.altpriority }}
    - require:
      - cmd: prometheus-archive-alternatives-install-{{ name }}-home-cmd-run

              {%- else %}

prometheus-archive-alternatives-install-{{ name }}-alternatives-install-{{ b }}:
  alternatives.install:
    - name: prometheus-{{ name }}-{{ b }}
    - link: /usr/local/bin/{{ b }}
    - path: {{ p.dir.basedir }}/{{ bundle }}/{{ b }}
    - priority: {{ p.linux.altpriority }}
    - order: 10
    - require:
      - alternatives: prometheus-archive-alternatives-install-{{ name }}-home-alternatives-install

prometheus-archive-alternatives-install-{{ name }}-alternatives-set-{{ b }}:
  alternatives.set:
    - name: prometheus-{{ name }}-{{ b }}
    - path: {{ p.dir.basedir }}/{{ bundle }}/{{ b }}
    - require:
      - alternatives: prometheus-archive-alternatives-install-{{ name }}-alternatives-install-{{ b }}

              {%- endif %}
          {% endfor %}
       {% endfor %}
    {%- endif %}
