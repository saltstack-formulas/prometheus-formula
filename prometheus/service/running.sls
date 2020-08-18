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
      - sls: {{ sls_config_file }}
      - file: prometheus-config-file-etc-file-directory

prometheus-service-running-{{ name }}:
            {%- if p.wanted.firewall and grains.kernel|lower == 'linux' %}
  pkg.installed:
    - name: firewalld
    - reload_modules: true
            {%- endif %}
  service.running:
    - onlyif: systemctl list-units | grep {{ service_name }} >/dev/null 2>&1
    - enable: True
    - require:
      - sls: {{ sls_config_file }}
    - names:
      - {{ service_name }}
            {%- if p.wanted.firewall and grains.kernel|lower == 'linux' %}
      - firewalld
  firewalld.present:
    - name: public
    - ports: {{ p.pkg.component[name]['firewall']['ports']|json }}
    - require:
      - service: prometheus-service-running-{{ name }}
            {%- endif %}

        {%- endif %}
    {%- endfor %}
