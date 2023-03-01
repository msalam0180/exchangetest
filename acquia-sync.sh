#!/bin/sh
echo "git remote set-url origin git@jira.jiratracker.com:sec/insider.git"
git remote set-url origin git@jira.jiratracker.com:sec/insider.git
echo "Adding Acquia as a remote repository"
git remote add acquia insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
echo "git checkout $CI_BUILD_REF_NAME;"
git checkout $CI_BUILD_REF_NAME;
echo "git pull origin $CI_BUILD_REF_NAME;"
git pull origin $CI_BUILD_REF_NAME;
echo "git pull acquia $CI_BUILD_REF_NAME;"
git pull acquia $CI_BUILD_REF_NAME;
echo "git push -u acquia $CI_BUILD_REF_NAME;"
git push -u acquia $CI_BUILD_REF_NAME;
git push acquia $CI_BUILD_REF_NAME;
echo "git fetch acquia --tags"
git fetch acquia --tags
echo "git push origin --tags"
git push origin --tags

echo "****************************"
