#!/bin/sh
echo "Begin CSS compiling"
echo "Adding Acquia as a remote repository"
git remote add acquia insidergov@svn-23659.prod.hosting.acquia.com:insidergov.git
echo "Checking out $CI_COMMIT_REF_NAME"
git clean -fd;
git checkout $CI_COMMIT_REF_NAME -f;
git reset --hard
echo "Pulling latest from Gitlab master"
git pull origin $CI_COMMIT_REF_NAME -f;
echo "Pulling latest from Acquia master"
git pull acquia $CI_COMMIT_REF_NAME;
echo "Compiling the SASS"
cd docroot/themes/custom/insider
npm install
gulp sass
cd ../../../..
echo "Committing the compiled CSS."
git add -A
git commit -m "Compiling sass files."
echo "Pushing latest to Acquia master"
git push --force acquia $CI_COMMIT_REF_NAME;

