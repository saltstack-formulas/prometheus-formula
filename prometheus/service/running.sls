# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_service_args = tplroot ~ '.args.install' %}
{%- set sls_config_file = tplroot ~ '.config.file' %}

include:
  - {{ sls_service_args }}
  - {{ sls_config_file }}

    {%- for name in p.wanted.component %}
        {%- if 'service' in p.pkg.component[name] and p.pkg.component[name]['service'] %}
            {%- set service_name = p.pkg.component[name]['service']['get'](name, {}).get('name', name) %}

prometheus-service-running-{{ name }}-unmasked:
  service.unmasked:
    - name: {{ service_name }}
    - onlyif:
       - {{ grains.kernel|lower == 'linux' }}
       - systemctl list-units | grep {{ service_name }} >/dev/null 2>&1
    - require_in:
      - service: prometheus-service-running-{{ name }}
    - require:
      - sls: {{ sls_service_args }}
      - sls: {{ sls_config_file }}

prometheus-service-running-{{ name }}:
  service.running:
    - name: {{ service_name }}
    - enable: True
            {%- if grains.kernel|lower == 'linux' %}
    - onlyif: systemctl list-units | grep {{ service_name }} >/dev/null 2>&1
            {%- endif %}
    - require:
      - sls: {{ sls_service_args }}
      - sls: {{ sls_config_file }}

        {%- endif %}
    {%- endfor %}
