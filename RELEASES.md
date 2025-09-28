# Setup and Processing

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
- **Custom match**: ^v?([1-9]\\d*)\\.
- **Version type**: Branch
- **Action**: Activate version

This will automatically activate any new version branches beginning with a non-zero number followed by a period (plus any additional characters).  Typically this would be major versions such as `3.x`.

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
- **Custom match**: ^v?([1-9]\\d*)\\.
- **Version type**: Branch
- **Action**: Activate version

This will automatically activate any new version branches beginning with a non-zero number followed by a period (plus any additional characters).  Typically this would be major versions such as `3.x`.

Once the translation project has been created, it is then added to the main project as a translation by selecting the appropriate translation project from the dropdown list.

## ReadTheDocs Processing

When a change is pushed or merged in the repository, ReadTheDocs will automatically initiate a build for the updated branch:

- If the branch is `master`, the `latest` revision will be updated.

- If the branch is a numbered revision branch (e.g. `2.x`) identified in the ReadTheDocs settings, the numbered revision will be updated. If the branch is a numbered revision branch which is **not** identified in the ReadTheDocs settings, the numbered revision will be added to the project (both main project and translation projects).

- If the branch is a numbered revision branch and is the highest numbered revision branch, the `stable` revision will be updated regardless of whether or not the numbered revision branch is indentified in the ReadTheDocs settings.

- The corresponding revisions for other languages (configured as translation projects in ReadTheDocs) will be updated.

## Preparing a New Version

Preparing a new version of the documentation is typically performed in one of two methods, depending on whether the vew version constitutes a major revision with significant changes and is planned to be released at a later date (typically as a `beta` or `pre-release` version initially). Method 1 would typically be used for the major revision case, while Method 2 would be typically used for incremental changes released as point updates. The main difference between the two methods is that Method 1 allows collecting the changes but not displaying them in the `latest` revision on ReadTheDocs immediately, but holds them until a testing version of Picard is released. Method 2 makes the changes to the `latest` revision on ReadTheDocs immediately, even if the corresponding updated version of Picard has not been released.

### New Version (Method 1)

This method captures the changes for the new version in a separate branch that will not be automatically added to the project on ReadTheDocs. For example in a branch such as `new_version_3.x`. Once the new version of the program is generally released as a `beta` or `pre-release` version for testing, the "new version" branch is merged into the `master` branch. This will allow updated translation (POT and PO) files to be generated for processing on Weblate, and will make the changes available on ReadTheDocs in the `latest` revision. At this point, the "new version" branch can be deleted from the repository.

### New Version (Method 2)

This method captures the changes for a new version in the `master` branch, thus making them immediately visible in the `latest` revision for the project on ReadTheDocs, even if the corresponding updated version of Picard has not been released. When a page from the `latest` revision on ReadTheDocs is displayed, the system is set to provide a brief popup dialog to warn the user that this is the documentation for the latest development version of Picard and that some features may not yet be available. This method allows the user to view new or changed functionality for the upcoming release of Picard.

## Updating Translations

Whenever changes have been merged to the `master` branch of the repository, the translation (POT and PO) files should be updated and merged so that the changes are picked up by Weblate and made available to the translators. The updates can be generated simply by executing the python script `python dev_utils.py build pot` in the root directory of the repository, where they can be staged and merged as a new commit to the `master` branch.
