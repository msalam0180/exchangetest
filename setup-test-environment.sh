#!/bin/sh
echo "Running script as "
whoami
echo "Setting up test environment on Gitlab"
cd ~/sec/insider/
echo "Checking out $CI_COMMIT_REF_NAME"
git clean -fd;
git fetch --all
git checkout $CI_COMMIT_REF_NAME -f;
git reset --hard origin/$CI_COMMIT_REF_NAME
echo "Pulling latest from Gitlab $CI_COMMIT_REF_NAME"
git pull origin $CI_COMMIT_REF_NAME -f;
echo "Pulling latest from Acquia $CI_COMMIT_REF_NAME"
git pull acquia $CI_COMMIT_REF_NAME;
cd ~/sec/insider/docroot
echo "Running updb on test env"
~/vendor/bin/drush updb -y;
echo "Running entup on test env"
~/vendor/bin/drush entup -y;
echo "Running cr on test env"
~/vendor/bin/drush cr;
echo "Running cim on test env"
~/vendor/bin/drush cim sync -y;
echo "Test environment is ready for testing of $CI_COMMIT_REF_NAME branch"
cd ~/sec/insider/
