# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- if grains.kernel|lower == 'linux' and p.linux.altpriority|int > 0 %}

       {%- for name in p.wanted %}
           {%- set bundle = name + '-%s.%s-%s'|format(p.pkg[name]['archive_version'], p.kernel, p.arch) %}

prometheus-archive-remove-{{ name }}-home-alternatives-remove:
  alternatives.remove:
    - name: prometheus-{{ name }}-home
    - path: {{ p.dir.basedir }}/{{ bundle }}
    - onlyif: update-alternatives --get-selections |grep ^prometheus-{{ name }}-home

            {% for b in p.pkg[name]['binaries'] %}

prometheus-archive-remove-{{ name }}-alternatives-remove-{{ b }}:
  alternatives.remove:
    - name: prometheus-{{ name }}-{{ b }}
    - path: {{ p.dir.basedir }}/{{ bundle }}/{{ b }}
    - onlyif: update-alternatives --get-selections |grep ^prometheus-{{ name }}-{{ b }}

            {% endfor %}
        {% endfor %}
    {%- endif %}
