# Introduction
This module suite contains the base Insider Solr Search module which provides some base functionality and dependencies, the Insider Solr Search Acquia Module which contains the configuration for Acquia Solr Search, and the Insider Solr Search Local module which contains configuration for local development.

# Installation
If you have a previous version of the Insider Solr Search module, it should be uninstalled which will disable the module and remove the active config. Then enabling either the Insider Solr Search Acquia or Insider Solr Search Local module will enable the base module and setup the configs for the environment chosen.

## Local Configuration files
In the insider_solr_search/solr-conf dir there exists a conf dir. This is the currently configured conf to allow for synonyms and elevate/promote/best-bets.

Copy this directory to your core e.g. replace your <path_to_solr>/insider_dev1/solr/collection1/conf dir
