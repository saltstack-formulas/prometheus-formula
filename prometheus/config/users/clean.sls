# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

    {%- for name in prometheus.wanted %}

prometheus-config-user-clean-{{ name }}-user-absent:
  user.absent:
    - name: {{ name }}
  group.absent:
    - name: {{ name }}
    - require:
      - user: prometheus-config-user-clean-{{ name }}-user-absent

    {%- endfor %}
