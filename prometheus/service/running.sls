# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_config_environ = tplroot ~ '.config.environ' %}

include:
  - {{ sls_config_file }}
  - {{ sls_config_environ }}

    {%- for name in p.wanted.component %}
        {%- if 'service' in p.pkg.component[name] and p.pkg.component[name]['service'] %}
            {%- set service_name = p.pkg.component[name]['service'].get('name', name) %}

            {%- if grains.kernel|lower == 'linux' %}
prometheus-service-running-{{ name }}-unmasked:
  service.unmasked:
    - name: {{ service_name }}
    - onlyif: systemctl list-unit-files | grep {{ service_name }} >/dev/null 2>&1
    - require_in:
      - service: prometheus-service-running-{{ name }}
    - require:
      - sls: {{ sls_config_file }}
      - file: prometheus-config-file-etc-file-directory
                {%- if p.wanted.firewall %}
  pkg.installed:
    - name: firewalld
    - reload_modules: true
                {%- endif %}
            {%- endif %}

prometheus-service-running-{{ name }}:
  service.running:
    - enable: True
    - require:
      - sls: {{ sls_config_file }}
            {%- if grains.kernel|lower == 'linux' %}
    - onlyif: systemctl list-unit-files | grep {{ service_name }} >/dev/null 2>&1
    - names:
      - {{ service_name }}
                {%- if p.wanted.firewall %}
      - firewalld
  firewalld.present:
    - name: public
    - ports: {{ p.pkg.component[name]['firewall']['ports']|json }}
    - require:
      - service: prometheus-service-running-{{ name }}
                {%- endif %}
            {%- endif %}
        {%- endif %}
    {%- endfor %}
