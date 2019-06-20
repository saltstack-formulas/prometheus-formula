# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_args = tplroot ~ '.config.args.install' %}
{%- set sls_config_file = tplroot ~ '.config.file.install' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_config_args }}
  - {{ sls_config_file }}

    {%- for name in prometheus.wanted %}
        {%- if name in prometheus.service %}

prometheus-service-running-{{ name }}-service-unmasked:
  service.unmasked:
    - name: {{ name }}
    - require:
      - sls: {{ sls_config_args }}
      - sls: {{ sls_config_file }}
            {%- if grains.kernel|lower == 'linux' %}
    - onlyif:
       -  systemctl list-unit-files | grep {{ name }} >/dev/null 2>&1
            {%- endif %}

prometheus-service-running-{{ name }}-service-running:
  service.running:
    - name: {{ name }}
    - enable: True
          {%- if name in prometheus.config %}
    - watch:
      - file: prometheus-config-file-{{ name }}-file-managed
           {%- endif %}
    - require:
      - service: prometheus-service-running-{{ name }}-service-unmasked
      - sls: {{ sls_config_args }}
      - sls: {{ sls_config_file }}
            {%- if grains.kernel|lower == 'linux' %}
    - onlyif: systemctl list-unit-files | grep {{ name }} >/dev/null 2>&1
            {%- endif %}

        {%- endif %}
    {%- endfor %}

