
Changelog
=========

`3.1.0 <https://github.com/saltstack-formulas/prometheus-formula/compare/v3.0.1...v3.1.0>`_ (2019-08-17)
------------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** modify matrix to include ``develop`` platform (\ `fc0f5b6 <https://github.com/saltstack-formulas/prometheus-formula/commit/fc0f5b6>`_\ )

Features
^^^^^^^^


* **yamllint:** include for this repo and apply rules throughout (\ `07dbfc8 <https://github.com/saltstack-formulas/prometheus-formula/commit/07dbfc8>`_\ )

`3.0.1 <https://github.com/saltstack-formulas/prometheus-formula/compare/v3.0.0...v3.0.1>`_ (2019-06-28)
------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **alternatives:** fix requisite (\ `8c410d7 <https://github.com/saltstack-formulas/prometheus-formula/commit/8c410d7>`_\ )

`3.0.0 <https://github.com/saltstack-formulas/prometheus-formula/compare/v2.0.0...v3.0.0>`_ (2019-06-23)
------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **example:** fix pillar.example formatting (\ `a13dd03 <https://github.com/saltstack-formulas/prometheus-formula/commit/a13dd03>`_\ )
* **repo:** use_upstream_repo corrections; separate users state (\ `eda47f7 <https://github.com/saltstack-formulas/prometheus-formula/commit/eda47f7>`_\ )
* **service:** ensure service file is removed on clean (\ `c735a6d <https://github.com/saltstack-formulas/prometheus-formula/commit/c735a6d>`_\ )
* **suse:** bypass salt alternatives.install errors (\ `1a890e5 <https://github.com/saltstack-formulas/prometheus-formula/commit/1a890e5>`_\ )
* **systemd:** ensure systemd detects new service (\ `149dd81 <https://github.com/saltstack-formulas/prometheus-formula/commit/149dd81>`_\ )

Features
^^^^^^^^


* **archives:** support for archives file format (\ `1f86f4a <https://github.com/saltstack-formulas/prometheus-formula/commit/1f86f4a>`_\ )
* **archives:** support for various prometheus archives (\ `3ec910e <https://github.com/saltstack-formulas/prometheus-formula/commit/3ec910e>`_\ )
* **archives:** user managementX (\ `d43033a <https://github.com/saltstack-formulas/prometheus-formula/commit/d43033a>`_\ )
* **linux:** alternatives support & updated unit tests (\ `36b3e62 <https://github.com/saltstack-formulas/prometheus-formula/commit/36b3e62>`_\ )

Tests
^^^^^


* **centos:** verified on CentosOS (\ `731198d <https://github.com/saltstack-formulas/prometheus-formula/commit/731198d>`_\ )
* **inspec:** expand unittests for archive format (\ `b074bd3 <https://github.com/saltstack-formulas/prometheus-formula/commit/b074bd3>`_\ )
* **inspec:** fix tests (\ `4092fb4 <https://github.com/saltstack-formulas/prometheus-formula/commit/4092fb4>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **repo:** The formula has been refactored to accomodate multiple packages,
  archives, users, and repos. Update your pillars and top states
* **archives:** the parameter ``pkg`` is now a dictionary. References
  to ``prometheus.pkg`` should be changed to ``prometheus.pkg.name``.

`2.0.0 <https://github.com/saltstack-formulas/prometheus-formula/compare/v1.2.0...v2.0.0>`_ (2019-06-22)
------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **repository:** add support for pkgrepo.managed (\ `907f9a6 <https://github.com/saltstack-formulas/prometheus-formula/commit/907f9a6>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **repository:** the variable 'pkg' was renamed 'pkg.name',
  update your pillars

`1.2.0 <https://github.com/saltstack-formulas/prometheus-formula/compare/v1.1.0...v1.2.0>`_ (2019-06-05)
------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **macos:** basic package and group handling (\ `e6a8b0c <https://github.com/saltstack-formulas/prometheus-formula/commit/e6a8b0c>`_\ )

`1.1.0 <https://github.com/alxwr/prometheus-formula/compare/v1.0.0...v1.1.0>`_ (2019-04-30)
-----------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **FreeBSD:** elegantly prevent service hang (\ `a7fad98 <https://github.com/alxwr/prometheus-formula/commit/a7fad98>`_\ ), closes `/github.com/saltstack/salt/issues/44848#issuecomment-487016414 <https://github.com//github.com/saltstack/salt/issues/44848/issues/issuecomment-487016414>`_

Features
^^^^^^^^


* **args:** handle service arguments the same way (\ `94078fe <https://github.com/alxwr/prometheus-formula/commit/94078fe>`_\ )
* **exporters:** added node_exporter (\ `34ada49 <https://github.com/alxwr/prometheus-formula/commit/34ada49>`_\ )

1.0.0 (2019-04-25)
------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **travis:** use structure of template-formula (\ `88d3f3e <https://github.com/alxwr/prometheus-formula/commit/88d3f3e>`_\ )

Features
^^^^^^^^


* **prometheus:** basic setup based on template-formula (\ `b9b7cc0 <https://github.com/alxwr/prometheus-formula/commit/b9b7cc0>`_\ )
