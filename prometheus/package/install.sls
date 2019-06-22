# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
 
    {%- if prometheus.pkg.use_upstream_repo %}

include:
  - .repo

    {%- endif %}
    {%- for name in prometheus.wanted %}
        {%- if name in prometheus.pkg %}

prometheus-package-install-{{ name }}-installed:
  pkg.installed:
    - name: {{ name }}

        {%- endif %}
    {%- endfor %}
