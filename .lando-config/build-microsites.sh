#!/bin/bash

# Get the lando logger
. /helpers/log.sh

# mkdir /var/www/.nvm
# export NVM_DIR=/var/www/.nvm
touch /var/www/.bashrc
curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash -
# cp /root/.bashrc /var/www/.bashrc && source /var/www/.bashrc
source ~/.bashrc
nvm install 14.17.6 && lando_green "Installed node version 14.17.6"
nvm install 12.22.6 && lando_green "Installed node version 12.22.6"
npm install --global gatsby-cli@3.8.0 >> ~/gatsby-install.log
# Clone microsites if not present in project
if [ ! -d /app/microsites/ ]; then
  lando_green "Cloning microsites repo."
  git clone git@jira.jiratracker.com:sec/microsites.git
fi

cd /app/microsites
# nvm use 12 && lando_green "Using Node version 12"
rm -rf node_modules && npm install && lando_green "*****Microsite node install complete.*****"
nvm use 14

cd /app/microsites/test
composer install
