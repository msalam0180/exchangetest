#!/bin/sh
echo "Deploying code from dev to stage (test) environment"
#ssh -oStrictHostKeyChecking=no insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
drush @insidergov.dev ac-code-deploy test
sleep 60
drush @insidergov.test fra -y
drush @insidergov.test entup -y

