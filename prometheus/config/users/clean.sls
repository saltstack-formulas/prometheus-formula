# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

    {%- for name in prometheus.wanted %}

prometheus-config-user-clean-{{ name }}-user-absent:
  user.absent:
    - name: {{ name }}
      {%- if grains.os_family == 'MacOS' %}
    - onlyif: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
      {%- endif %}
  group.absent:
    - name: {{ name }}
    - require:
      - user: prometheus-config-user-clean-{{ name }}-user-absent

    {%- endfor %}
