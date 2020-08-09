# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- for name in p.wanted.component %}
        {%- if 'service' in p.pkg.component[name] and p.pkg.component[name]['service'] %}
            {%- set service_name = p.pkg.component[name]['service']['get'](name, {}).get('name', name) %}

prometheus-service-clean-{{ name }}:
  service.dead:
    - name: {{ service_name }}
    - enable: False
                    {%- if grains.kernel|lower == 'linux' %}
    - onlyif: systemctl list-units | grep {{ service_name }} >/dev/null 2>&1
                    {%- endif %}
  file.absent:
    - name: {{ p.dir.service }}/{{ name }}.service
    - require:
      - service: prometheus-service-clean-{{ name }}
  cmd.run:
    - onlyif: {{ grains.kernel|lower == 'linux' }}
    - name: systemctl daemon-reload
    - require:
      - file: prometheus-service-clean-{{ name }}

            {%- if grains.os_family == 'FreeBSD' %}
  sysrc.absent:
    - name: {{ name }}_environ
    - require:
      - service: prometheus-service-clean-{{ name }}

            {%- endif %}
        {%- endif %}
    {%- endfor %}
