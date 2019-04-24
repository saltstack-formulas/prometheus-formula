# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import prometheus with context %}

include:
  - {{ sls_config_file }}

{%- if prometheus.service.sysrc %}
prometheus_args:
  sysrc.managed:
    - value: {{ prometheus.service.flags }}
{%- endif %}

{#- On FreeBSD restarting this service hangs. #}
{#- See https://github.com/saltstack/salt/issues/44848#issuecomment-486460601 #}
{%- if salt['grains.get']('os_family') == 'FreeBSD' %}
prometheus-service-running-service-enable:
  service.enabled:
    - name: {{ prometheus.service.name }}

prometheus-service-running-service-running:
  cmd.run:
    - name: "service {{ prometheus.service.name }} onerestart >/dev/null 2>&1"
    - hide_output: True
    - timeout: 60
    - onchanges:
{%- else %}{# business as usual #}
prometheus-service-running-service-running:
  service.running:
    - name: {{ prometheus.service.name }}
    - enable: True
    - watch:
{%- endif %}
      - file: prometheus-config-file-file-managed
{%- if prometheus.service.sysrc %}
      - sysrc: prometheus_args
{%- endif %}
    - require:
      - sls: {{ sls_config_file }}
