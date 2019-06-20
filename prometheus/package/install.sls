# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

    {%- for name in prometheus.wanted %}

prometheus-package-install-{{ name }}-installed:
  pkg.installed:
    - name: {{ name }}

    {%- endfor %}
