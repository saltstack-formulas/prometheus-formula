# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_service_clean }}

    {%- for name in p.wanted.component %}

prometheus-config-clean-{{ name }}:
  file.absent:
    - names:
      - {{ p.dir.etc }}/{{ name }}.yml
      - {{ p.pkg.component[name]['environ_file'] }}
  user.absent:
    - name: {{ name }}
                {%- if grains.os_family == 'MacOS' %}
    - onlyif: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
                {%- endif %}
    - require:
      - user: prometheus-config-clean-{{ name }}
      - sls: {{ sls_service_clean }}
  group.absent:
    - name: {{ name }}
    - require:
      - user: prometheus-config-clean-{{ name }}
     
        {%- if grains.os_family == 'FreeBSD' %}
  sysrc.absent:
    - name: {{ name }}_environ
        {%- endif %}

    {%- endfor %}
