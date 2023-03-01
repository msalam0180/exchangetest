#!/bin/sh
cd ~/sec/theexchange/test
export BEHAT_PARAMS='{"extensions": {"Behat\\MinkExtension": {"base_url": "http://theexchange.jiratracker.com"},"Drupal\\DrupalExtension": {"drupal": {"drupal_root": "/home/gitlab-runner/sec/theexchange/docroot"}}}}'
echo "Checking for behat installation"
if [ -e bin/behat ]
then
    echo "Behat found, running tests"
    bin/behat
else
    echo "Behat not found, running composer install"
    composer install
    echo "Running Behat tests"
    bin/behat
fi
