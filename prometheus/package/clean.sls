# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_config_clean }}

    {%- for name in prometheus.wanted %}
        {%- if name in prometheus.pkg %}

prometheus-package-clean-{{ name }}-removed:
  pkg.removed:
    - name: {{ name }}
            {%- if name in prometheus.service %}
    - require:
      - service: prometheus-service-clean-{{ name }}-service-dead
            {%- endif %}

        {%- endif %}
    {%- endfor %}
