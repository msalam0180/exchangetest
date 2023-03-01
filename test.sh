#!/bin/sh

#echo "Running PHPUnit Tests"
#cd docroot/core
#../vendor/phpunit/phpunit/phpunit  --group sec
#../vendor/phpunit/phpunit/phpunit  --group insider

echo "Running PHPUnit Tests"
cd docroot/core
chmod a+x ../../vendor/bin/phpunit 
chmod a+x ../../vendor/phpunit/phpunit/phpunit
../../vendor/bin/phpunit --group insider

cd ../../
echo "Running PHP CodeSniffer on docroot/sites/insider/modules/"
phpcs --standard=phpcs_ruleset.xml -s --warning-severity=0 docroot/modules/custom 

cd docroot/
echo "Running ESLint on docroot/themes/custom/insider/"
#eslint themes/custom/insider/**/*.scss
eslint themes/custom/insider/js/shared.js
echo "Running ESLint on docroot/sites/insider/modules/"
#eslint modules/custom
