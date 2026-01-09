.. MusicBrainz Picard Documentation Project

Appendix D: :index:`Plugins Migration <pair: plugins; migration>`
============================================================================

This document provides a comprehensive guide for migrating plugins from Picard v2 to v3.

Overview
---------

Picard v3 introduces significant changes to the plugin system:

* Git-based distribution (no more ZIP files)
* TOML manifest instead of Python metadata
* New PluginApi for accessing Picard functionality
* JSON-based translations (Plugin v2 had no translation support)
* PyQt6 instead of PyQt5

**Good news**: An automated migration tool handles most plugins automatically!

----

Automated Migration Tool
-------------------------

Quick Start
+++++++++++++

.. code-block:: bash

   # Migrate your plugin
   python scripts/migrate_plugin.py old_plugin.py output_directory

   # Example
   python scripts/migrate_plugin.py featartist.py featartist_v3


What It Does Automatically
+++++++++++++++++++++++++++

The migration tool (``scripts/migrate_plugin.py``) automatically handles:

* ✅ **Metadata Extraction** - Creates MANIFEST.toml from PLUGIN_* variables
* ✅ **Code Conversion** - Converts register calls to ``enable(api)``
* ✅ **PyQt5 → PyQt6** - Converts 80+ enum patterns, imports, methods
* ✅ **Config/Log Access** - Converts to ``api.logger.*`` and ``api.global_config.*``
* ✅ **Function Signatures** - Fixes processor signatures (removes extra parameters)
* ✅ **Decorator Patterns** - Converts ``@register_*`` decorators
* ✅ **UI File Regeneration** - Regenerates ``ui_*.py`` from ``.ui`` using pyuic6
* ✅ **API Injection** - Adds ``api`` parameter to OptionsPage/Action classes
* ✅ **File Copying** - Copies all plugin files (Python modules, docs, assets)
* ✅ **Conflict Handling** - Renames conflicting files with ``.orig`` extension
* ✅ **Code Formatting** - Formats output with ruff (handles errors gracefully)


Supported Registration Patterns
++++++++++++++++++++++++++++++++

* Metadata processors (track, album, file)
* Script functions
* Options pages
* UI actions (cluster, file, album, track, clusterlist)
* Cover art providers
* Qualified imports (``metadata.register_*``, ``providers.register_*``)
* Instantiated registrations (``register_action(MyAction())``)
* Instantiated object methods (``register_processor(MyClass().method)``)


Success Rate
++++++++++++++

Based on testing all 73 plugins from picard-plugins v2 repository:

* **34.2%** Perfect (zero manual work) - 25 plugins
* **60.3%** Good (minor import review) - 44 plugins
* **5.5%** Minimal (manual work needed) - 4 edge cases
* **0%** Failed

**Overall: 94.5% success rate** (69/73 automatic or near-automatic)

The 4 plugins requiring manual work use non-standard patterns (custom registration, function-scoped registrations, complex constructors).


Example Output
+++++++++++++++

.. code-block:: none

   Migrating plugin: Keep tags
   Author: Wieland Hoffmann
   Version: 1.2.1
   Created: /tmp/keep_v3/MANIFEST.toml
   Created: /tmp/keep_v3/__init__.py
   Regenerated: ui_options.py (from ui_options.ui)

   ✓ Copied 3 file(s)
   ✓ Copied 1 directory(ies)

   ✓ Converted log.* calls to api.logger.*
   ✓ Converted config.setting to api.global_config.setting
   ✓ Injected api in MyOptionsPage.__init__

   Migration complete! Plugin saved to: /tmp/keep_v3


After Migration
++++++++++++++++

1. Review the generated code
2. Address any warnings
3. Create git repository
4. Test installation

----

Quick Migration Checklist
--------------------------

Automated (Done by the Migration Tool)
++++++++++++++++++++++++++++++++++++++++

* [x] Extract metadata → MANIFEST.toml
* [x] Remove metadata from ``__init__.py``
* [x] Convert register calls → ``enable(api)``
* [x] Update Qt5 → Qt6
* [x] Fix function signatures
* [x] Convert config/log access

Manual
+++++++

* [ ] Create git repository
* [ ] Review warnings from migration tool
* [ ] Add translations (if needed)
* [ ] Test functionality

----

Step-by-Step Migration Using the Migration Tool
------------------------------------------------

Step 1: Initialize the Plugin Repository
+++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

   # Create new repository
   mkdir picard-plugin-myplugin
   cd picard-plugin-myplugin
   git init

   # Copy plugin files
   cp -r ~/old-plugin/* .

   # Initial commit
   git add .
   git commit -m "Initial commit - v2 plugin"


Step 2: Run the Plugin Migration Tool
+++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

   # Run the migration tool
   python scripts/migrate_plugin.py my_plugin.py .

   # Or for multi-file plugins
   python scripts/migrate_plugin.py my_plugin/__init__.py .

The tool will:

* Create ``.gitignore``
* Create ``MANIFEST.toml``
* Extract all PLUGIN_* metadata
* Convert code to v3 format
* Handle Qt5 → Qt6 conversions
* Regenerate UI files
* Format code with ruff

.. note::

   Manual review and testing is still required to ensure that the plugin works as expected.


**Old (v2) - in** ``__init__.py``:

.. code-block:: python

   PLUGIN_NAME = "Example Plugin"
   PLUGIN_AUTHOR = "John Doe"
   PLUGIN_VERSION = "1.0.0"
   PLUGIN_API_VERSIONS = ["2.0", "2.1"]
   PLUGIN_LICENSE = "GPL-2.0-or-later"
   PLUGIN_LICENSE_URL = "https://www.gnu.org/licenses/gpl-2.0.html"
   PLUGIN_DESCRIPTION = "Example plugin for demonstration"

**New (v3) -** ``MANIFEST.toml``:

.. code-block:: toml

   uuid = "550e8400-e29b-41d4-a716-446655440000"
   name = "Example Plugin"
   description = "Example plugin for demonstration"
   api = ["3.0"]
   authors = ["John Doe"]
   license = "GPL-2.0-or-later"
   license_url = "https://www.gnu.org/licenses/gpl-2.0.html"
   categories = ["metadata"]


Step 3: Review Generated Code
++++++++++++++++++++++++++++++

Check the output of the migration tool for any warnings:

.. code-block:: none

   ⚠️  Class 'MyClass' uses 'api' but injection failed - needs manual review

Address all of these warnings before proceeding.


Step 4: Review and update the ``MANIFEST.toml`` file
++++++++++++++++++++++++++++++++++++++++++++++++++++++

* Ensure ``uuid`` is unique. This should be auto-generated.
* Verify ``name`` as human readable.
* Ensure no linefeeds in ``description`` and less than 200 characters.
* Use markdown for ``long_description`` if required. Ensure less than 2000 characters.
* Confirm ``api`` list of compatible APIs (e.g. ["3.0", "3.1"]).
* Verify ``authors`` list.
* Add ``maintainers`` list if applicable.
* Confirm ``license`` (e.g. "GPL-2.0-or-later").
* Confirm ``license_url`` (e.g. "https://www.gnu.org/licenses/gpl-2.0.html").
* Add ``categories`` as a list containing one or more of "metadata", "coverart", "ui", "scripting", "formats", "other"
* Add ``homepage`` URL (typically documentation or GitHub repository).
* Add ``min_python_version`` if required (e.g. min_python_version = "3.9").


Step 5: Remove Old v2 Files
++++++++++++++++++++++++++++

Remove any old v2 files from the plugin directory. The migration tool will make a copy of any files that are replaced, adding the extension of ``.orig``.


Step 6: Create Translation Files (Optional):
+++++++++++++++++++++++++++++++++++++++++++++

If you plan to have your plugin support other languages/locales, you can create the translation files by extracting the text strings using the tool provided.

.. code-block:: bash

   python scripts/extract_plugin_translations.py {path_to_plugin}

This will create (or update) the ``locale`` directory and translation files for the plugin. See :doc:`Plugin Translations <plugins_translations>` for more information regarding the configuration and use of translations.


Step 7: Update Git Repository
+++++++++++++++++++++++++++++++

Update the repository to make the changes to the updated plugin available to Picard.

.. code-block:: bash

   git add .
   git commit -m "Migrated to V3"


Step 8: Test the Plugin
++++++++++++++++++++++++

Install the plugin from the local repository and test that it functions as expected in Picard v3.

.. code-block:: bash

   # Install from local directory
   picard-plugins --install ~/dev/picard-plugin-example

   # Test in Picard
   picard

   # Check logs for errors
   tail -f ~/.config/MusicBrainz/Picard/picard.log

   # Uninstall
   picard-plugins --uninstall example


Step 9: Publish the Plugin (Optional)
++++++++++++++++++++++++++++++++++++++

Request to add the plugin to Picard's official plugin registery.

a) Push the plugin repository to GitHub/GitLab
''''''''''''''''''''''''''''''''''''''''''''''''''''''

This makes you plugin available publicly so that it can be accessed by the registration utility.


b) Create releases
''''''''''''''''''''''''''

Create the releases (branches and/or tags) as appropriate for the plugin.

* For development: Use branches (e.g., ``main``, ``develop``)
* For stable versions: Tag releases (e.g., ``v1.0.0``, ``1.0.0``, ``release-1.0.0``)

.. note::

   The plugin system supports both branches and tags:

   * **Branches**: ``picard-plugins --update`` pulls latest commits
   * **Tags**: ``picard-plugins --update`` automatically finds and switches to the latest tag (based on version number)

   **Supported tag formats**:

   * ``v1.0.0``, ``v1.0``, ``v1`` (with v prefix)
   * ``1.0.0``, ``1.0``, ``1`` (without prefix)
   * ``release-1.0.0``, ``release/1.0.0`` (with release prefix)
   * ``2024.11.30`` (date-based)


c) Fork the registry repository
''''''''''''''''''''''''''''''''

Create a fork of the `https://github.com/metabrainz/picard-plugins-registry <https://github.com/metabrainz/picard-plugins-registry>`_ repository on GitHub and clone it locally. Switch to the directory containing the clone of the repository.


d) Add the plugin to the local registry
''''''''''''''''''''''''''''''''''''''''

Add the plugin using:

.. code-block:: bash

   uv run registry plugin add {plugin_url}

This will add the plugin to the local registry and assign it an id based on the plugin name. See :doc:`Plugins Registrt <plugins_registry>` for more information about the registry system.


e) Set the plugin categories
''''''''''''''''''''''''''''''

Set the categories for the plugin using:

.. code-block:: bash

   uv run registry plugin edit {plugin-id} --categories {categories}

where ``{plugin-id}`` is the id assigned to the plugin when it was added to the registry, and ``{categories}`` is a comma-separated list (with no spaces) from the valid categories: "metadata", "ui", "coverart", "scripting", "formats", "other". This is used to filter the plugins registry when browsing or installing a plugin.


f) Set the plugin trust level
''''''''''''''''''''''''''''''

Set the trust level using:

.. code-block:: bash

   uv run registry plugin edit {plugin-id} --trust {trust-level}

where ``{plugin-id}`` is the id assigned to the plugin when it was added to the registry, and ``{trust-level}`` is a valid level: "official", "trusted", "community". In most cases this should be set to "community".


g) Set the plugin versioning scheme
''''''''''''''''''''''''''''''''''''

Set the versioning scheme using:

.. code-block:: bash

   uv run registry plugin edit {plugin-id} --versioning-scheme {scheme}

where ``{plugin-id}`` is the id assigned to the plugin when it was added to the registry, and ``{scheme}`` is a valid versioning scheme: "semver", "calver" or "regex:<pattern>". Setting a versioning scheme enables automatic version discovery. If omitted, the registry uses explicit refs only.


h) Check and validate
''''''''''''''''''''''''''

Validate the registry and check the code quality using:

.. code-block:: bash

   # Ensure the registry is valid
   uv run registry validate

   # Check code quality
   uvx ruff check

   # Check formatting
   uvx ruff format

   # Final checks
   pre-commit run --all


i) Commit changes
''''''''''''''''''

Commit the changes, with the commit message "Add plugin: {plugin name}".


j) Create a pull request
'''''''''''''''''''''''''

Push to your fork of the repository, and create a pull request. The pull request should include in the description (as appropriate):

.. code-block:: none

   Repository: {url_to_plugin_repository}

   Migrated from: {url_to_old_plugin_repository}

   Changes from original plugin:
   - list changes as appropriate

You can also include a description of the plugin or any other information that will help the Picard Team evaluate the plugin.

----

API Access Pattern
-------------------

Explicit Parameter Passing
+++++++++++++++++++++++++++

The ``PluginApi`` is passed explicitly to functions and classes:

**For Processors:** API is injected as first parameter via ``functools.partial``

.. code-block:: python

   def process_track(api, track, metadata):
      """API is automatically injected as first parameter."""
      api.logger.info("Processing track")
      if api.global_config.setting['example_enabled']:
         metadata['example'] = 'value'


   def enable(api):
      # Picard wraps this as partial(process_track, api)
      api.register_track_metadata_processor(process_track)

**For Classes:** API is passed to `__init__` and stored as `self.api`

.. code-block:: python

   from picard.plugin3.api import OptionsPage

   class ExampleOptionsPage(OptionsPage):
      NAME = "example"
      TITLE = "Example"
      PARENT = "plugins"

      def __init__(self, api=None, parent=None):
         super().__init__(parent)
         self.api = api

      def load(self):
         self.api.logger.debug("Loading options")
         enabled = self.api.global_config.setting.get('example_enabled', False)


   def enable(api):
      """Entry point - register with API."""
      api.register_track_metadata_processor(process_track)
      api.register_options_page(ExampleOptionsPage)


**Why this works:**

* Processors receive ``api`` as first parameter (injected via ``functools.partial``)
* Classes receive ``api`` in ``__init__`` (passed during instantiation)
* No global variables needed
* Clean, explicit, and testable

----

Common Migration Patterns
--------------------------

Album Background Tasks (Web Requests)
++++++++++++++++++++++++++++++++++++++

If your v2 plugin used ``album._requests`` to track web requests, you need to migrate to the v3 task API.

**v2 Pattern:**

.. code-block:: python

   from picard.metadata import register_album_metadata_processor

   def fetch_data(album, metadata, release):
      album._requests += 1
      album.tagger.webservice.get(
         'example.com',
         '/api/data',
         handler=lambda response, reply, error: handle_response(album, response, error)
      )

   def handle_response(album, response, error):
      try:
         if not error:
               # Process response
               pass
      finally:
         album._requests -= 1
         album._finalize_loading(None)

   register_album_metadata_processor(fetch_data)

**v3 Pattern:**

.. code-block:: python

   from functools import partial

   def fetch_data(api, album, metadata, release):
      task_id = f'data_{album.id}'

      def create_request():
         return api.web_service.get_url(
               url='https://example.com/api/data',
               handler=partial(handle_response, api, album, task_id)
         )

      api.add_album_task(
         album, task_id,
         'Fetching data',
         request_factory=create_request
      )

   def handle_response(api, album, task_id, data, error):
      try:
         if not error:
               # Process data
               pass
      finally:
         api.complete_album_task(album, task_id)

   def enable(api):
      api.register_album_metadata_processor(fetch_data)

**Key changes:**

* ``album._requests`` → ``api.add_album_task()`` with ``request_factory``
* ``album.tagger.webservice`` → ``api.web_service``
* Use ``request_factory`` parameter to prevent race conditions
* Always call ``api.complete_album_task()`` in a ``finally`` block

**Why** ``request_factory``? The factory pattern ensures requests are created and registered atomically, preventing race conditions where an album could be removed between creating a request and registering it. Please see the :doc:`Plugin API <plugins_api>` documentation for more details.

----

Complete Example: Before and After
-----------------------------------

Before (v2)
+++++++++++++

**Directory structure:**

.. code-block:: none

   example-plugin/
      __init__.py
      ui_options.py


**__init__.py:**

.. code-block:: python

   PLUGIN_NAME = "Example Plugin"
   PLUGIN_AUTHOR = "John Doe"
   PLUGIN_VERSION = "1.0.0"
   PLUGIN_API_VERSIONS = ["2.0"]
   PLUGIN_LICENSE = "GPL-2.0-or-later"
   PLUGIN_LICENSE_URL = "https://www.gnu.org/licenses/gpl-2.0.html"
   PLUGIN_DESCRIPTION = "Example plugin"

   from picard import log, config
   from picard.metadata import register_track_metadata_processor
   from picard.ui.options import register_options_page, OptionsPage
   from PyQt5.QtWidgets import QCheckBox

   class ExampleOptionsPage(OptionsPage):
      NAME = "example"
      TITLE = "Example Plugin"
      PARENT = "plugins"

      def __init__(self, parent=None):
         super().__init__(parent)
         self.checkbox = QCheckBox("Enable processing")
         self.layout().addWidget(self.checkbox)

      def load(self):
         self.checkbox.setChecked(config.setting['example_enabled'])

      def save(self):
         config.setting['example_enabled'] = self.checkbox.isChecked()

   def process_track(api, album, metadata, track, release):
      log.info("Processing track: %s", track)
      if config.setting['example_enabled']:
         metadata['example'] = 'processed'

   def register():
      log.info("Registering Example Plugin")
      register_track_metadata_processor(process_track)
      register_options_page(ExampleOptionsPage)

After (v3)
++++++++++++

**Directory structure:**

.. code-block:: none

   picard-plugin-example/
      MANIFEST.toml
      __init__.py
      ui_options.py


**MANIFEST.toml:**

.. code-block:: toml

   uuid = "550e8400-e29b-41d4-a716-446655440000"
   name = "Example Plugin"
   description = "Example plugin for demonstration"
   api = ["3.0"]
   authors = ["John Doe"]
   license = "GPL-2.0-or-later"
   license_url = "https://www.gnu.org/licenses/gpl-2.0.html"
   categories = ["metadata"]


**__init__.py:**

.. code-block:: python

   from picard.plugin3.api import OptionsPage
   from PyQt6.QtWidgets import QCheckBox


   class ExampleOptionsPage(OptionsPage):
      NAME = "example"
      TITLE = "Example Plugin"
      PARENT = "plugins"

      def __init__(self, api=None, parent=None):
         super().__init__(parent)
         self.api = api
         self.checkbox = QCheckBox("Enable processing")
         self.layout().addWidget(self.checkbox)

      def load(self):
         enabled = self.api.global_config.setting.get('example_enabled', False)
         self.checkbox.setChecked(enabled)

      def save(self):
         self.api.global_config.setting['example_enabled'] = self.checkbox.isChecked()


   def process_track(api, track, metadata):
      api.logger.info(f"Processing track: {track}")
      if api.global_config.setting.get('example_enabled', False):
         metadata['example'] = 'processed'


   def enable(api):
      """Entry point for the plugin."""
      api.logger.info("Example Plugin loaded")
      api.register_track_metadata_processor(process_track)
      api.register_options_page(ExampleOptionsPage)

----

Breaking Changes
------------------

Removed Features
+++++++++++++++++

* ZIP-based distribution
* Python metadata in ``__init__.py``
* Direct ``tagger`` access
* PyQt5 support
* Config option objects (``TextOption``, ``BoolOption``, ``IntOption``, etc.)


Config Options (v2 → v3)
+++++++++++++++++++++++++

**v2 used option objects:**

.. code-block:: python

   from picard.config import TextOption, BoolOption

   my_text = TextOption("setting", "my_key", "default")
   my_bool = BoolOption("setting", "my_enabled", True)

   # Access via .value
   if my_bool.value:
      text = my_text.value


**v3 uses direct config access:**

.. code-block:: python

   # In processors
   def process(api, track, metadata):
      if api.plugin_config.get('my_enabled', True):
         text = api.plugin_config.get('my_key', 'default')

   # In OptionsPage
   from picard.plugin3.api import OptionsPage

   class MyPage(OptionsPage):
      def load(self):
         enabled = self.api.global_config.setting.get('my_enabled', True)

      def save(self):
         self.api.global_config.setting['my_enabled'] = self.checkbox.isChecked()


**OptionsPage** ``options`` **attribute removed:**

.. code-block:: python

   from picard.plugin3.api import OptionsPage

   # v2 - options attribute for metadata
   class MyPage(OptionsPage):
      options = [
         config.BoolOption("setting", "my_option", True),
      ]

   # v3 - no options attribute needed
   class MyPage(OptionsPage):
      # Just read/write config in load()/save()
      pass


Processor functions receive the PluginApi as first parameter
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

All the metadata and event processor functions now get the ``PluginApi`` instance passed as first parameter. For example a file post load processor previously looked like this:

.. code-block:: python

   def file_post_load_processor(file):
      pass

The new processor must expect the ``PluginApi`` instance for the plugin as first parameter:

.. code-block:: python

   def file_post_load_processor(api, file):
      pass


Track metadata processor parameters changed
+++++++++++++++++++++++++++++++++++++++++++++

Track metadata processors now get a ``Track`` object passed instead of an ``Album`` object. The track's album object can still be accessed using ``track.album``.

Old function signature:

.. code-block:: python

   def my_track_metadata_processor(album, metadata, track_node, release_node):
      pass

The new function signature:

.. code-block:: python

   def my_track_metadata_processor(api, track, metadata, track_node, release_node):
      pass


New Features
++++++++++++++++

* JSON-based translations (Plugin v2 had no translation support)


Changed Behavior
+++++++++++++++++++

* Plugins must be in git repositories
* Entry point is ``enable()`` instead of ``register()``
* All Picard access through PluginApi
* Configuration namespaced under plugin name
* Translations use JSON instead of .mo files

----

Getting Help
-------------

* **Documentation:** `https://picard-docs.musicbrainz.org/ <https://picard-docs.musicbrainz.org/>`_
* **Forum:** `https://community.metabrainz.org/c/picard <https://community.metabrainz.org/c/picard>`_
* **GitHub:** `https://github.com/metabrainz/picard <https://github.com/metabrainz/picard>`_

.. raw:: latex

   \clearpage
