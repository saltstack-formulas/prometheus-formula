# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

  {%- for name in prometheus.wanted %}

prometheus-config-user-install-{{ name }}-user-present:
  group.present:
    - name: {{ name }}
    - require_in:
      - user: prometheus-config-user-install-{{ name }}-user-present
  user.present:
    - name: {{ name }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ name }}

  {%- endfor %}
