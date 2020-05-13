# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_archive_clean = tplroot ~ '.server.archive.clean' %}
{%- set sls_package_clean = tplroot ~ '.server.package.clean' %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_archive_clean if p.pkg.use_upstream_archive else sls_package_clean }}
  - {{ sls_service_clean }}

    {%- for name in p.wanted.component %}
        {%- if 'service' in p.pkg.component[name] and p.pkg.component[name]['service'] %}

prometheus-service-args-clean-{{ name }}:
  file.absent:
    - names:
      - /tmp/dummy-{{ name }}-dummy
                {%- if 'storage.tsdb.path' in p.pkg.component[name]['service']['args'] %}
      - {{ p.pkg.component[name]['service']['args']['storage.tsdb.path'] }}
                {%- endif %}
    - require:
      - sls: {{ sls_service_clean }}

                {%- if grains.os_family == 'FreeBSD' %}
  sysrc.absent:
    - names:
      - {{ name }}_args
      - {{ name }}_listen_address
      - {{ name }}_textfile_dir
      - {{ name }}_data_dir
      - {{ name }}_config
    - require:
      - sls: {{ sls_service_clean }}

                {%- endif %}
            {%- endif %}
        {%- endif %}
    {%- endfor %}
