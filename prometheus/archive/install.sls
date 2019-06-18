# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- for k in p.archive.wanted %}
        {%- set dir = p.archive.dir.opt + '/' + k + '-%s.%s-%s'|format(p.archive.versions[k], p.kernel, p.arch) %}

prometheus-archive-install-{{ k }}-user-present:
  group.present:
    - name: {{ k }}
    - require_in:
      - user: prometheus-archive-install-{{ k }}-user-present
  user.present:
    - name: {{ k }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ k }}
    - require_in:
      - archive: prometheus-archive-install-{{ k }}-archive-extracted

prometheus-archive-install-{{ k }}-archive-extracted:
  archive.extracted:
    - name: {{ p.archive.dir.opt }}
    - source: {{ p.archive.uri + '/' + k + '/releases/download/v' + p.archive.versions[k]
                 + '/' + k + '-%s.%s-%s'|format(p.archive.versions[k], p.kernel, p.arch)
                 + '.' + p.archive.suffix }}
    - source_hash: {{ p.archive.hashes[k] }} 
    - user: {{ k }}
    - group: {{ k }}
    {{- format_kwargs(p.archive.kwargs) }}
    - recurse:
        - user
        - group
    - require_in:
      - file: prometheus-archive-install-{{ k }}-managed-systemd_file
      - file: prometheus-archive-install-file-directory

prometheus-archive-install-{{ k }}-managed-systemd_file:
  file.managed:
    - name: {{ p.archive.systemd.dir }}/{{ k }}.service
    - source: {{ files_switch(['systemd.ini.jinja'],
                              lookup='prometheus-archive-install-{{ k }}-managed-systemd_file'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ p.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        desc: prometheus - {{ k }} serice
        name: {{ k }}
        user: {{ k }}
        group: {{ k }}
        start: {{ dir }}/{{ k }} --config.file {{ p.archive.dir.etc }}/{{ k }}/{{ k }}.yml
        stop: killall {{ dir }}/{{ k }}
        after: {{ p.archive.systemd.after }}
        wants: {{ p.archive.systemd.wants }}

    {%- endfor %}

prometheus-archive-install-file-directory:
  file.directory:
    - names:
      - {{ p.archive.dir.opt }}
      - {{ p.archive.dir.etc }}
      - {{ p.archive.dir.var }}
    - user: prometheus
    - group: prometheus
    - mode: 755
    - makedirs: True
    ##do not recurse!!!
