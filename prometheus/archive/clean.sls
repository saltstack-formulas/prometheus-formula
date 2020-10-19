# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- set sls_alternatives_clean = tplroot ~ '.archive.alternatives.clean' %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_service_clean }}
  - {{ sls_alternatives_clean }}

prometheus-archive-clean-prerequisites:
  file.absent:
    - name: {{ p.dir.var }}

    {%- for name in p.wanted.component %}

prometheus-archive-clean-{{ name }}:
  file.absent:
  - name: {{ p.pkg.component[name]['path'] }}

        {%- if (grains.kernel|lower == 'linux' and p.linux.altpriority|int <= 0) or grains.os_family|lower in ('macos', 'arch') %}
            {%- if 'commands' in p.pkg.component[name] and p.pkg.component[name]['commands'] is iterable %}
                {%- for cmd in p.pkg.component[name]['commands'] %}

prometheus-archive-clean-{{ name }}-file-symlink-{{ cmd }}:
  file.absent:
    - names:
      - {{ p.dir.symlink }}/bin/{{ cmd }}
      - {{ p.dir.symlink }}/sbin/{{ cmd }}
      - {{ p.dir.var }}/{{ name }}
      - {{ p.dir.service }}/{{ name }}.service
    - require:
      - sls: {{ sls_alternatives_clean }}
      - sls: {{ sls_service_clean }}
    - require_in:
      - user: prometheus-archive-clean-{{ name }}-user-group

                {%- endfor %}
            {%- endif %}
        {%- endif %}
    {%- endfor %}
