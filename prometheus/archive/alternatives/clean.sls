# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import prometheus as p with context %}

  {%- if grains.kernel|lower == 'linux' and p.linux.altpriority|int > 0 and grains.os_family != 'Arch' %}
      {%- if 'wanted' in p and p.wanted and 'component' in p.wanted and p.wanted.component %}

          {%- for name in p.wanted.component %}
              {%- if 'commands' in p.pkg.component[name] and p.pkg.component[name]['commands'] is iterable %}
                  {%- for cmd in p.pkg.component[name]['commands'] %}

prometheus-server-alternatives-clean-{{ name }}-{{ cmd }}:
  alternatives.remove:
    - unless: {{ p.pkg.use_upstream_repo }}
    - name: link-prometheus-{{ name }}-{{ cmd }}
    - path: {{ p.pkg.component[name]['path'] }}/{{ cmd }}
    - onlyif: update-alternatives --get-selections |grep ^prometheus-{{ name }}-{{ cmd }}

                  {%- endfor %}
              {%- endif %}
          {%- endfor %}

      {%- endif %}
  {%- endif %}
