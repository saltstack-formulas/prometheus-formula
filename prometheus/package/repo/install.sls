# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

  {%- if prometheus.pkg.use_upstream_repo %}
      {%- from tplroot ~ "/jinja/macros.jinja" import format_kwargs with context %}

prometheus-package-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    {{- format_kwargs(prometheus.pkg.repo) }}

prometheus-package-repo-install-file-replace-workaround-for-salt-51494:
  file.replace:
    - name: /etc/yum.repos.d/prometheus.repo
    - pattern: ' gpgkey2='
    - repl: '\n       '
    - ignore_if_missing: True
    - onlyif: {{ grains.os_family == 'RedHat' }}

  {%- endif %}
