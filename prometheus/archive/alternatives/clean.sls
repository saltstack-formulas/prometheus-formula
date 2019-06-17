# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_archive_clean = tplroot ~ '.archive.clean' %}

  {%- if grains.kernel|lower == 'linux' and p.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_clean }}


    {%- for k in p.archive.wanted %}
        {%- set dir = p.archive.dir + '/' + k + '-%s.%s-%s'|format(p.archive.version["k"], p.kernel, p.arch) %}

prometheus-archive-remove-{{ k }}-home-alternatives-remove:
  alternatives.remove:
    - name: prometheus-{{ k }}-home
    - path: {{ dir }}
    - onlyif: update-alternatives --get-selections |grep ^prometheus-{{ k }}-home
    - require:
      - sls: {{ sls_archive_clean }}


        {% for i in p.archive.binaries['k'] %}

prometheus-archive-remove-{{ k }}-alternatives-remove-{{ i }}:
  alternatives.remove:
    - name: prometheus-{{ k }}-{{ i }}
    - path: {{ dir }}/{{ i }}
    - onlyif: update-alternatives --get-selections |grep ^prometheus-{{ k }}-{{ i }}
    - require:
      - sls: {{ sls_archive_clean }}

        {% endfor %}
    {% endfor %}
  {%- endif %}
