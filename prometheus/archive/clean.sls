# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_alternatives_clean = tplroot ~ '.archive.alternatives.clean' %}

    {%- if p.pkg.use_upstream_archive %}

include:
  - {{ sls_alternatives_clean }}

        {%- for k in p.archive.wanted %}
            {%- set dir = p.archive.dir.opt + '/' + k + '-%s.%s-%s'|format(p.archive.versions[k], p.kernel, p.arch) %}

prometheus-archive-clean-{{ k }}-file-absent:
  file.absent:
    - names:
      - {{ dir }}
      - {{ p.archive.systemd.dir }}/{{ k }}.service
    #- require:
      #- sls: {{ sls_alternatives_clean }}

prometheus-archive-clean-{{ k }}-user-absent:
  user.absent:
    - name: {{ k }}
  group.absent:
    - name: {{ k }}
    - require:
      - user: prometheus-archive-clean-{{ k }}-user-absent

        {%- endfor %}

prometheus-archive-clean-file-directory:
  file.absent:
    - names:
      - {{ p.archive.dir.opt }}
      - {{ p.archive.dir.etc }}
      - {{ p.archive.dir.var }}

    {%- endif %}
