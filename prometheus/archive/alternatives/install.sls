# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

  {%- if grains.kernel|lower == 'linux' and p.linux.altpriority|int > 0 and grains.os_family != 'Arch' %}
      {%- set sls_archive_install = tplroot ~ '.archive.install' %}

include:
  - {{ sls_archive_install }}

      {%- if 'wanted' in p and p.wanted and 'component' in p.wanted and p.wanted.component %}
          {%- for name in p.wanted.component %}
              {%- if 'commands' in p.pkg.component[name] and p.pkg.component[name]['commands'] is iterable %}
                  {%- set dir_symlink = p.dir.symlink ~ '/bin' %}
                  {%- if 'service' in p.pkg.component[name] %}
                      {%- set dir_symlink = p.dir.symlink ~ '/sbin' %}
                  {%- endif %}
                  {%- for cmd in p.pkg.component[name]['commands'] %}

prometheus-server-alternatives-install-{{ name }}-{{ cmd }}:
  cmd.run:
    - name: update-alternatives --install {{ dir_symlink }}/{{ cmd }} link-prometheus-{{ name }}-{{ cmd }} {{ p.pkg.component[name]['path'] }}/{{ cmd }} {{ p.linux.altpriority }}  # noqa 204
    - unless:
      -  {{ grains.os_family not in ('Suse',) }}
      - {{ p.pkg.use_upstream_repo }}
    - require:
      - sls: {{ sls_archive_install }}
  alternatives.install:
    - name: link-prometheus-{{ name }}-{{ cmd }}
    - link: {{ dir_symlink }}/{{ cmd }}
    - path: {{ p.pkg.component[name]['path'] }}/{{ cmd }}
    - priority: {{ p.linux.altpriority }}
    - order: 10
    - require:
      - sls: {{ sls_archive_install }}
    - unless:
      - {{ grains.os_family in ('Suse',) }}
      - {{ p.pkg.use_upstream_repo }}

prometheus-server-alternatives-set-{{ name }}-{{ cmd }}:
  alternatives.set:
    - name: link-prometheus-{{ name }}-{{ cmd }}
    - path: {{ p.pkg.component[name]['path'] }}/{{ cmd }}
    - require:
      - alternatives: prometheus-server-alternatives-install-{{ name }}-{{ cmd }}
      - sls: {{ sls_archive_install }}
    - unless:
      - {{ grains.os_family in ('Suse',) }}
      - {{ p.pkg.use_upstream_repo }}

                  {%- endfor %}
              {%- endif %}
          {%- endfor %}
      {%- endif %}

  {%- endif %}
