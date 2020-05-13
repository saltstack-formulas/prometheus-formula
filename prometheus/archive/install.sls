# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_config_users = tplroot ~ '.config.users' %}

include:
  - {{ sls_config_users }}

prometheus-archive-install-prerequisites:
  pkg.installed:
    - names: {{ p.pkg.deps|json }}
  file.directory:
    - name: {{ p.dir.var }}
    - user: prometheus
    - group: prometheus
    - mode: 755
    - makedirs: True

    {%- for name in p.wanted.component %}

prometheus-archive-install-{{ name }}:
  file.directory:
    - name: {{ p.pkg.component[name]['path'] }}
    - user: {{ p.identity.rootuser }}
    - group: {{ p.identity.rootgroup }}
    - mode: '0755'
    - makedirs: True
    - require:
      - sls: {{ sls_config_users }}
      - file: prometheus-archive-install-prerequisites
    - require_in:
      - archive: prometheus-archive-install-{{ name }}
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(p.pkg.component[name]['archive']) }}
    - trim_output: true
    - enforce_toplevel: false
    - options: --strip-components=1
    - retry: {{ p.retry_option|json }}
    - user: {{ p.identity.rootuser }}
    - group: {{ p.identity.rootgroup }}
    - require:
      - sls: {{ sls_config_users }}

        {%- if p.linux.altpriority|int <= 0 or grains.os_family|lower in ('macos', 'arch') %}
            {%- if 'commands' in p.pkg.component[name]  and p.pkg.component[name]['commands'] is iterable %}
                {%- for cmd in p.pkg.component[name]['commands'] %}

prometheus-archive-install-{{ name }}-file-symlink-{{ cmd }}:
  file.symlink:
                    {%- if 'service' in p.pkg.component[name] %}
    - name: {{ p.dir.symlink }}/sbin/{{ cmd }}
                    {%- else %}
    - name: {{ p.dir.symlink }}/bin/{{ cmd }}
                    {% endif %}
    - target: {{ p.pkg.component[name]['path'] }}/{{ cmd }}
    - force: True
    - require:
      - archive: prometheus-archive-install-{{ name }}

                {%- endfor %}
            {%- endif %}
        {%- endif %}
        {%- if 'service' in p.pkg.component[name] and p.pkg.component[name]['service'] is mapping %}

prometheus-archive-install-{{ name }}-file-directory:
  file.directory:
    - name: {{ p.dir.var }}/{{ name }}
    - user: {{ name }}
    - group: {{ name }}
    - mode: '0755'
    - makedirs: True
    - require:
      - archive: prometheus-archive-install-{{ name }}
      - file: prometheus-archive-install-{{ name }}

            {%- if grains.kernel|lower == 'linux' %}

prometheus-archive-install-{{ name }}-managed-service:
  file.managed:
    - name: {{ p.dir.service }}/{{ name }}.service
    - source: {{ files_switch(['systemd.ini.jinja'],
                              lookup='prometheus-archive-install-{{ name }}-managed-service'
                 )
              }}
    - mode: '0644'
    - user: {{ p.identity.rootuser }}
    - group: {{ p.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        desc: prometheus - {{ name }} service
        name: {{ name }}
        user: {{ name }}
        group: {{ name }}
        workdir: {{ p.dir.var }}/{{ name }}
        start: {{ p.pkg.component[name]['path'] }}/{{ name }} --config.file {{ p.dir.etc }}/{{ name }}.yml  # noqa 204
        stop: ''
    - require:
      - file: prometheus-archive-install-{{ name }}-managed-service
      - file: prometheus-archive-install-{{ name }}-file-directory
      - sls: {{ sls_config_users }}
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: prometheus-archive-install-{{ name }}-managed-service
      - sls: {{ sls_config_users }}

            {%- endif %}
        {%- endif %}
    {%- endfor %}
