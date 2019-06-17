# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}
{%- set sls_alternatives_clean = tplroot ~ '.archive.alternatives.clean' %}

  {%- if prometheus.pkg.use_upstream_archive %}

include:
  - {{ sls_alternatives_clean }}


      {%- for k in prometheus.archive.wanted %}
prometheus-archive-clean-{{ k }}-file-absent:
  file.absent:
    - name: {{ prometheus.archive.dir + '/' + k + '-%s.%s-%s'|format(prometheus.archive.versions[k], prometheus.kernel, prometheus.arch) }}
    #- require:
      #- sls: {{ sls_alternatives_clean }}
        {%- endfor %}

  {%- endif %}
