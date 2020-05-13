# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

  {%- for name in p.wanted.component %}

prometheus-config-user-install-{{ name }}-user-present:
  group.present:
    - name: {{ name }}
    - require_in:
      - user: prometheus-config-user-install-{{ name }}-user-present
  user.present:
    - name: {{ name }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ name }}
              {%- if grains.os_family == 'MacOS' %}
    - unless: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
              {%- endif %}

  {%- endfor %}
