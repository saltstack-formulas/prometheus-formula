# -*- coding: utf-8 -*-
# vim: ft=sls

{%- if grains.os_family == 'RedHat' %}

  {%- set tplroot = tpldir.split('/')[0] %}
  {%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

  {%- if p.pkg.use_upstream_repo and 'repo' in p.pkg and p.pkg.repo %}
    {%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

prometheus-package-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    {{- format_kwargs(p.pkg.repo) }}
  file.replace:
    # redhat workaround for salt issue #51494
    - name: /etc/yum.repos.d/prometheus.repo
    - pattern: ' gpgkey2='
    - repl: '\n       '
    - ignore_if_missing: True
  {%- endif %}

{%- else %}

prometheus-package-repo-install-pkgrepo-managed:
  test.show_notification:
    - name: Skipping repository configuration
    - text: |
        At the moment, there's no repo for {{ grains['os'] }}
        See https://prometheus.io/download/

{%- endif %}
