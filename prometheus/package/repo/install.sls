# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

    {%- if p.pkg.use_upstream_repo and 'repo' in p.pkg %}
        {%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

prometheus-package-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    {{- format_kwargs(p.pkg['repo']) }}
  file.replace:
    # redhat workaround for salt issue #51494
    - name: /etc/yum.repos.d/{{ name }}.repo
    - pattern: ' gpgkey2='
    - repl: '\n       '
    - ignore_if_missing: True
    - onlyif: {{ grains.os_family == 'RedHat' }}

    {%- endif %}
