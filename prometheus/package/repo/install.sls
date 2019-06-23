# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

  {%- for name in prometheus.wanted %}
      {%- if name in prometheus.pkg and 'repo' in prometheus.pkg[name] and prometheus.pkg[name]['repo'] %}
          {%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

prometheus-package-repo-install-{{ name }}-pkgrepo-managed:
  pkgrepo.managed:
    {{- format_kwargs(prometheus.pkg[name]['repo']) }}

prometheus-package-repo-install-{{ name }}-file-replace:
  # redhat workaround for salt issue #51494
  file.replace:
    - name: /etc/yum.repos.d/{{ name }}.repo
    - pattern: ' gpgkey2='
    - repl: '\n       '
    - ignore_if_missing: True
    - onlyif: {{ grains.os_family == 'RedHat' }}

      {%- endif %}
  {%- endfor %}
