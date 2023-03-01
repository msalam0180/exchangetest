#!/bin/sh
#
# Cloud Hook: drush-user-update
#
# Run drush uublk and urol in all non-prod environments.

# Map the script inputs to convenient names.
site=$1
target_env=$2
db_name="$3"
source_env="$4"
drush_alias=$site'.'$target_env

# List of drush command based on site.
drush_exchange="drush10 @$drush_alias"

# Variables USER_EXCHANGE will be pulled from Environment Varialbes from Acquia UI.

# Execute commands if environment is NOT prod.
if [ $target_env != "prod" ]; then
  case $db_name in
    "insidergov")
      $drush_exchange uublk "$USER_EXCHANGE"
      $drush_exchange urol administrator "$USER_EXCHANGE"
    ;;
  esac
else
  echo "Did not execute any drush commands."
fi
