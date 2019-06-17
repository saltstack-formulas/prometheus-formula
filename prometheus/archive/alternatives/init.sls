# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

  {%- if grains.kernel|lower == 'linux' and prometheus.pkg.use_upstream_archive  %}

include:
  - .install

  {%- endif %}
