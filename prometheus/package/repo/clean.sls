# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

  {%- for name in prometheus.wanted %}
      {%- if name in prometheus.pkg and 'repo' in prometheus.pkg[name] and prometheus.pkg[name]['repo'] %}

prometheus-package-repo-clean-{{ name }}-pkgrepo-absent:
  pkgrepo.absent:
    - name: {{ prometheus.pkg[name]['repo']['name'] }}

      {%- endif %}
  {%- endfor %}
