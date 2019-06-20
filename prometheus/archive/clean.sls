# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_alternatives_clean = tplroot ~ '.archive.alternatives.clean' %}

    {%- if p.use_upstream_archive %}

include:
  - {{ sls_alternatives_clean }}

        {%- for name in p.wanted %}

prometheus-archive-clean-{{ name }}-file-absent:
  file.absent:
    - names:
      - {{ p.dir.basedir }}/{{ name + '-%s.%s-%s'|format(p.pkg[name]['archive_version'], p.kernel, p.arch) }}
    - require:
      - sls: {{ sls_alternatives_clean }}

prometheus-archive-clean-{{ name }}-user-absent:
  user.absent:
    - name: {{ name }}
  group.absent:
    - name: {{ name }}
    - require:
      - user: prometheus-archive-clean-{{ name }}-user-absent
      - sls: {{ sls_alternatives_clean }}

        {%- endfor %}

prometheus-archive-clean-file-directory:
  file.absent:
    - names:
      - {{ p.dir.basedir }}
      - {{ p.dir.etc }}
      - {{ p.dir.var }}
    - require:
      - sls: {{ sls_alternatives_clean }}

    {%- endif %}
