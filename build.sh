#!/bin/sh
echo "Building insidergov"
echo "Adding Acquia remote"
git remote add acquia insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
echo "fixing origin remote"
git remote set-url origin git@jira.jiratracker.com:sec/insider.git
echo "Checking out master"
git clean -fd;
git checkout master -f;
git reset --hard
echo "Pulling latest from Gitlab master"
git pull origin master -f;
echo "Pulling latest from Acquia master"
git pull acquia master;
#echo "Pushing latest to Gitlab master"
#git push origin master;
echo "Pushing latest to Acquia master"
git push acquia master;
echo "git fetch acquia --tags"
git fetch acquia --tags
echo "git push origin --tags"
git push origin --tags
echo "Executing Drush commands"

#ssh -oStrictHostKeyChecking=no insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
#drush @insidergov.dev updb
#drush @insidergov.dev entup -y
#drush @insidergov.dev fra -y
