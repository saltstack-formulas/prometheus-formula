# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_service_clean }}

    {%- for name in p.wanted.component %}

prometheus-config-clean-{{ name }}:
    - names:
      - {{ p.dir.etc }}{{ d.div }}{{ name }}.yml
      - {{ p.pkg.component[name]['environ_file'] }}
             {%- if grains.os_family|lower in ('freebsd',) %}
  sysrc.absent:
    - name: {{ name }}_environ
             {%- endif %}
  user.absent:
    - name: {{ name }}
                {%- if grains.os_family == 'MacOS' %}
    - onlyif: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
                {%- endif %}
  group.absent:
    - name: {{ name }}
    - require:
       - {{ sls_config_clean }}

    {%- endfor %}
