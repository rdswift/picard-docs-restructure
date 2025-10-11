# Setup and Processing

## Repository Setup

### Branch Structure

The repository is generally based on three main types of branches:

#### Master Branch

This is the main branch (called `master`) for the repository.

- This branch is the one connected to Weblate for translations to other locales.
- The `master` branch is automatically published as the `latest` version on ReadTheDocs whenever changes are merged to the branch.
- This is typically the target branch for pull requests proposing changes to the current version of the documentation, including upcoming point release versions of the software.

#### Stable Versions

These are branches containing the stable documentation for released versions of the software. They are named for the major version of the release in the form `{major}.{minor}` such as `2.13` or `3.0`.

- These branches will be automatically published as the branch name version (e.g. `2.13`) on ReadTheDocs whenever changes are merged to the branch.
- The highest numbered branch will automatically be published as the `stable` version on ReadTheDocs.
- The `master` branch will typically be merged into the highest numbered stable version branch when translations are updated or when the updated point version of the software documented in the `master` branch is released. It is unusual for pull requests to target a stable branch unless some functionality of a higher major version of the software has been backported to an earlier major release (e.g. a new configuration option in the version `3.0` release is backported to the `2.13` version).

#### Next Version

This branch is called `next_version`, and is intended to collect documentation changes related to new or changed functionality for an upcoming major version of the software that hasn't yet been publically released.

- This branch will not be automatically published on ReadTheDocs.
- The branch will typically be merged into the `master` branch when the software is publicly released.
- When the software is publicly released as a production (non-beta) version, a corresponding stable version branch should be created as `{major}.{minor}` from the updated `master` branch. The `next_version` branch should then only be used for documentation changes associated with the next major release version of the software.

### Directory Structure

The directory structure for the repository is generally as follows:

#### Root Directory

This directory contains the configuration files for the documentation project as well as miscellaneous repository documentation and utilities, including:

- `.readthedocs.yaml`: ReadTheDocs project build configuration.
- `conf.py`: Sphinx configuration.
- `DEV_UTILS.md`: Brief description of the developer utilities script.
- `dev_utils.py`: Developer utilities script.
- `genindex.rst`: Placeholder file for the generated documentation index.
- `index.rst`: Master index for building the HTML documentation.
- `pdf_build.sh`: BASH script used by `.readthedocs.yaml` to build the PDF documentation file.
- `pdf.rst`: Master index for building the PDF documentation.
- `requirements_dev.txt`: Requirements for developers.
- `requirements.txt`: Requirements for building the documentation for ReadTheDocs.
- `tag_mapping.py`: Module to maintain tag mapping information and to automatically generate the tag mapping pages, HTML table and Excel spreadsheet.

#### Project Directories

The directories containing additional files used by the project are identified as such by beginning with an underscore. These include:

- `_build`: This directory is not included in the repository but is created whenever a build is triggered.
- `_extensions`: This directory contains extensions used by the Sphinx program.
- `_locale`: This directory contains all language translation POT and PO files.
- `_static`: This directory contains static files to be included, such as additional css definitions and favicon image.
- `_templates`: This directory contains custom templates used to override the default templates used by ReadTheDocs.

#### Documentation Directories

The remaining directories not beginning with an underscore contain the documentation restructured text (RST) source files. Each directory is intended to help separate and organize the documentation content.

## ReadTheDocs Setup

### Main Project

The main project is set up on ReadTheDocs with the following settings:

- **Name**: Picard User Guide
- **Repository URL**: https://github.com/rdswift/picard-docs-restructure
- **Connected Repository**: No connected repository
- **Language**: English
- **Default version**: Stable
- **URL versioning scheme**: Multiple versions with translations
- **Default branch**: master
- **Path for .readthedocs.yaml**: \<blank>
- **Programming Language**: Only Words
- **Project homepage**: https://picard.musicbrainz.org
- **Description**: A full-featured, cross-platform music file tagging system
- **Tags**: \<blank>
- **Build pull requests for this project**: \<unchecked>

In addition, an automation rule is added with the following settings:

- **Description**: Add new stable versions
- **Match**: Custom match
- **Custom match**: ^([1-9]\\d*\\.\\d+)$
- **Version type**: Branch
- **Action**: Activate version

This will automatically activate any new version branches beginning with a non-zero number followed by a period and additional digits (plus any additional characters).  Typically this would be major.minor versions such as `2.13` or `3.0`.

### Translations to Other Languages

Translations to other languages are added as new projects on ReadTheDocs with the following settings:

- **Name**: Picard User Guide ({language})
- **Repository URL**: https://github.com/rdswift/picard-docs-restructure
- **Connected Repository**: No connected repository
- **Language**: {language}
- **Default version**: Stable
- **URL versioning scheme**: Multiple versions with translations
- **Default branch**: master
- **Path for .readthedocs.yaml**: \<blank>
- **Programming Language**: Only Words
- **Project homepage**: https://picard.musicbrainz.org
- **Description**: A full-featured, cross-platform music file tagging system
- **Tags**: \<blank>
- **Build pull requests for this project**: \<unchecked>

In addition, an automation rule is added with the following settings:

- **Description**: Add new stable versions
- **Match**: Custom match
- **Custom match**: ^([1-9]\\d*\\.\\d+)$
- **Version type**: Branch
- **Action**: Activate version

This will automatically activate any new version branches beginning with a non-zero number followed by a period and additional digits (plus any additional characters).  Typically this would be major.minor versions such as `2.13` or `3.0`.

Once the translation project has been created, it is then added to the main project as a translation by selecting the appropriate translation project from the dropdown list.

## ReadTheDocs Processing

When a change is pushed or merged in the repository, ReadTheDocs will automatically initiate a build for the updated branch:

- If the branch is `master`, the `latest` revision will be updated.

- If the branch is a numbered revision branch (e.g. `2.13`) identified in the ReadTheDocs settings, the numbered revision will be updated. If the branch is a numbered revision branch which is **not** identified in the ReadTheDocs settings, the numbered revision will be added to the project (both main project and translation projects).

- If the branch is a numbered revision branch and is the highest numbered revision branch, the `stable` revision will be updated regardless of whether or not the numbered revision branch is indentified in the ReadTheDocs settings.

- The corresponding revisions for other languages (configured as translation projects in ReadTheDocs) will be updated.

## Preparing a New Version

Preparing a new version of the documentation is typically performed in one of two methods, depending on whether the vew version constitutes a major revision with significant changes and is planned to be released at a later date (typically as a `beta` or `pre-release` version initially). Method 1 would typically be used for the major revision case, while Method 2 would be typically used for incremental changes released as point updates. The main difference between the two methods is that Method 1 allows collecting the changes but not displaying them in the `latest` revision on ReadTheDocs immediately, but holds them until a testing version of Picard is released. Method 2 makes the changes to the `latest` revision on ReadTheDocs immediately, even if the corresponding updated version of Picard has not been released.

### New Version (Method 1)

This method captures the changes for the new version in a separate branch that will not be automatically added to the project on ReadTheDocs. For example in a branch such as `new_version_3`, although the `next_version` branch has been created specifically for this purpose. Once the new version of the program is generally released as a `beta` or `pre-release` version for testing, the "new version" (`next_version`) branch is merged into the `master` branch. This will allow updated translation (POT and PO) files to be generated for processing on Weblate, and will make the changes available on ReadTheDocs in the `latest` revision. At this point the "new version" branch can be deleted from the repository, although the default `next_version` branch should not be deleted.

### New Version (Method 2)

This method captures the changes for a new version in the `master` branch, thus making them immediately visible in the `latest` revision for the project on ReadTheDocs, even if the corresponding updated version of Picard has not been released. When a page from the `latest` revision on ReadTheDocs is displayed, the system is set to provide a brief popup dialog to warn the user that this is the documentation for the latest development version of Picard and that some features may not yet be available. This method allows the user to view new or changed functionality for the upcoming release of Picard.

## Updating Translations

Whenever changes have been merged to the `master` branch of the repository, the translation (POT and PO) files should be updated and merged so that the changes are picked up by Weblate and made available to the translators. The updates can be generated simply by executing the python script `python dev_utils.py build pot` in the root directory of the repository, where they can be staged and merged as a new commit to the `master` branch.
