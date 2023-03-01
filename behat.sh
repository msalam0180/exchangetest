#!/bin/sh
echo "Deleting previous behat-* test files"
cd ~/sec/insider/docroot/files/exchange/
find . -name '\behat-*.*' -type f -delete

cd ~/sec/insider/test
export BEHAT_PARAMS='{"extensions": {"Behat\\MinkExtension": {"base_url": "http://insider.jiratracker.com"},"Drupal\\DrupalExtension": {"drupal": {"drupal_root": "/home/gitlab-runner/sec/insider/docroot"}}}}'
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