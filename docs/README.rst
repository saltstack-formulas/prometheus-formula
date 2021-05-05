prometheus-formula
==================

Formula to manage Prometheus on GNU/Linux and MacOS.

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/prometheus-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/prometheus-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release


.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.  If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_. If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``, which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.  See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Special notes
-------------

None.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Available metastates
--------------------

.. contents::
   :local:

``prometheus``
^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs from prometheus solution.


``prometheus.archive``
^^^^^^^^^^^^^^^^^^^^^^

This state will install prometheus components on MacOS and GNU/Linux from archive.

``prometheus.clientlibs``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will install prometheus client libraries on MacOS and GNU/Linux from archive.

``prometheus.package``
^^^^^^^^^^^^^^^^^^^^^^

This state will install prometheus component packages from GNU/Linux.

``prometheus.config``
^^^^^^^^^^^^^^^^^^^^^

This state will apply prometheus service configuration (files).

``prometheus.service``
^^^^^^^^^^^^^^^^^^^^^^

This state will start prometheus component services.

``prometheus.exporters``
^^^^^^^^^^^^^^^^^^^^^^^^

This state will apply prometheus exporters configuration.

``prometheus.exporters.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove prometheus exporters configuration.

``prometheus.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop prometheus component services.

``prometheus.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove prometheus service configuration (files).

``prometheus.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will uninstall prometheus component packages from GNU/Linux.

``prometheus.clientlibs.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will uninstall prometheus client libraries.

``prometheus.archive.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove prometheus component archive (directories).


Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``prometheus`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

