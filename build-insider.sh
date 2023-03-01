#!/bin/sh
echo "Building insidergov"
echo "Adding Acquia remote"
git remote add acquia insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
echo "fixing origin remote"
git remote set-url origin git@jira.jiratracker.com:sec/insider.git
echo "Checking out insider/dev"
git clean -fd;
git checkout insider/dev -f;
git reset --hard
echo "Pulling latest from Gitlab insider/dev"
git pull origin insider/dev -f;
echo "Pulling latest from Acquia insider/dev"
git pull acquia insider/dev;
#echo "Pushing latest to Gitlab insider/dev"
#git push origin insider/dev;
echo "Pushing latest to Acquia insider/dev"
git push acquia insider/dev;
echo "git fetch acquia --tags"
git fetch acquia --tags
echo "git push origin --tags"
git push origin --tags
echo "Executing Drush commands"

#ssh -oStrictHostKeyChecking=no insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
#drush @insidergov.dev1 updb
#drush @insidergov.dev1 entup -y
#drush @insidergov.dev1 fra -y
