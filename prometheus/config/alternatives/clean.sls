# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- set sls_archive_clean = tplroot ~ '.archive.clean' %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

  {%- if grains.kernel|lower == 'linux' and prometheus.linux.altpriority|int > 0 %}

include:
  - {{ sls_archive_clean if prometheus.pkg.use_upstream_archive else sls_package_clean }}

prometheus-package-archive-remove-home-alternative-remove:
  alternatives.remove:
    - name: prometheus-home
    - path: {{ prometheus.base_dir }}
    - onlyif: update-alternatives --get-selections |grep ^prometheus-home
    - require:
      - sls: {{ sls_archive_clean if prometheus.pkg.use_upstream_archive else sls_package_clean }}

      {% for i in ['prometheus', 'promtool'] %}

prometheus-package-archive-remove-{{ i }}-alternative-remove:
  alternatives.remove:
    - name: link-{{ i }}
    - path: {{ prometheus.base_dir }}/{{ i }}
    - onlyif: update-alternatives --get-selections |grep ^link-{{ i }}
    - require:
      - sls: {{ sls_archive_clean if prometheus.pkg.use_upstream_archive else sls_package_clean }}

     {% endfor %}
  {%- endif %}
