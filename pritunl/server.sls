{%- from "pritunl/map.jinja" import server with context %}
{%- if server.enabled %}

pritunl_repository:
  pkgrepo.managed:
    - humanname: Pritunl
    - name: deb http://repo.pritunl.com/stable/apt xenial main
    - dist: xenial
    - file: /etc/apt/sources.list.d/pritunl.list
    - gpgcheck: 1
    - keyid: 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    - keyserver: keyserver.ubuntu.com

pritunl_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - require:
     - pritunl_repository

/etc/pritunl.conf:
  file.managed:
  - source: salt://pritunl/files/pritunl.conf
  - template: jinja
  - mode: 640
  - group: root
  - require:
    - pkg: pritunl_packages

pritunl_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  - watch:
    - file: /etc/pritunl.conf

{%- endif %}
