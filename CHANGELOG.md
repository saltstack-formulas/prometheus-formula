# Changelog

# [2.0.0](https://github.com/saltstack-formulas/prometheus-formula/compare/v1.2.0...v2.0.0) (2019-06-22)


### Features

* **repository:** add support for pkgrepo.managed ([907f9a6](https://github.com/saltstack-formulas/prometheus-formula/commit/907f9a6))


### BREAKING CHANGES

* **repository:** the variable 'pkg' was renamed 'pkg.name',
  update your pillars

# [1.2.0](https://github.com/saltstack-formulas/prometheus-formula/compare/v1.1.0...v1.2.0) (2019-06-05)


### Features

* **macos:** basic package and group handling ([e6a8b0c](https://github.com/saltstack-formulas/prometheus-formula/commit/e6a8b0c))

# [1.1.0](https://github.com/alxwr/prometheus-formula/compare/v1.0.0...v1.1.0) (2019-04-30)


### Bug Fixes

* **FreeBSD:** elegantly prevent service hang ([a7fad98](https://github.com/alxwr/prometheus-formula/commit/a7fad98)), closes [/github.com/saltstack/salt/issues/44848#issuecomment-487016414](https://github.com//github.com/saltstack/salt/issues/44848/issues/issuecomment-487016414)


### Features

* **args:** handle service arguments the same way ([94078fe](https://github.com/alxwr/prometheus-formula/commit/94078fe))
* **exporters:** added node_exporter ([34ada49](https://github.com/alxwr/prometheus-formula/commit/34ada49))

# 1.0.0 (2019-04-25)


### Continuous Integration

* **travis:** use structure of template-formula ([88d3f3e](https://github.com/alxwr/prometheus-formula/commit/88d3f3e))


### Features

* **prometheus:** basic setup based on template-formula ([b9b7cc0](https://github.com/alxwr/prometheus-formula/commit/b9b7cc0))
