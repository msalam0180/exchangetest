# About

This module contains a suite of views, flags, and Link field updates to be used for creating and curating Quicklinks.

# Installation

- Enable the module per usual methods
- Ensure the feature is reverted

# Configuration

Content creators should mark nodes of the link content type as Available with the additional option of marking it as a default Quicklink.

The current quicklinks limit is set to 12 and that setting is in insider_quicklinks.module file.
The My Quicklinks standalone view is set to allow for 13 due to a Quicklink being temporarily allowed until the onFlag event in src/EventSubscriber/QuicklinksFlagSubscriber is called.

# Tests

- Ensure "Add to Quicklinks" checkbox exists (or not) for the appropriate roles

- Ensure "Add as Default Quicklinks" checkbox exists (or not) for the appropriate roles

- Ensure Default QUicklinks menu is generated when user has chosen no Quicklinks

- Ensure Users can choose their own quicklinks

- Ensure User's chosen Quicklinks show in Menu

- Ensure Edit link exists in Quicklinks Menu
