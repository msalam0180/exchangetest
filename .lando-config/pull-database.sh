#! /bin/bash

# Get the lando logger
. /helpers/log.sh

project="$1"
env="$2"
uri=""
siteAlias=""
fileName=""

lando_pink "Getting Environment Information."
/usr/local/bin/acli -n api:applications:environment-list insidergov > /app/.lando-config/exchange-envs.txt && lando_green "Success!"
declare environments=($(cat /app/.lando-config/exchange-envs.txt | sed -nr -e 's/.*"label": "(.*)",/\1/p'))
declare branches=($(cat /app/.lando-config/exchange-envs.txt | sed -nr 's/.*"path": "(.*)",/\1/p'))
envPrompt=$'Which environment?\n[0] Exit\n'

for i in ${!environments[@]}; do
  label=${environments[$i]}
  gitbranch=${branches[$i]}
  if [ $label == "Prod" ]; then
    envPrompt+="[1] prod     - currently on branch: $gitbranch"$'\n'
  elif [ $label == "Stg" ]; then
    envPrompt+="[2] stage    - currently on branch: $gitbranch"$'\n'
  elif [ $label == "Train" ]; then
    envPrompt+="[3] train    - currently on branch: $gitbranch"$'\n'
  elif [ $label == "Dev" ]; then
    envPrompt+="[4] dev      - currently on branch: $gitbranch"$'\n'
  elif [ $label == "Dev1" ]; then
    envPrompt+="[5] dev1     - currently on branch: $gitbranch"$'\n'
  elif [ $label == "Test0" ]; then
    envPrompt+="[6] test    - currently on branch: $gitbranch"$'\n'
  elif [ $label == "Test1" ]; then
    envPrompt+="[7] test1    - currently on branch: $gitbranch"$'\n'
  fi
done

fileName=exchangedb
# echo $'Which environment?\n[0] Exit\n[1] prod\n[2] stage\n[3] dev\n[4] dev1\n[5] test1'
echo "$envPrompt" | sort | sed 's@\\@@g'
rm /app/.lando-config/exchange-envs.txt

read env
case $env in 1 | 2 | 3 | 4 | 5 | 6 | 7)
  echo "Great! [$env]"
  ;;
*)
  lando_red "Error! Invalid Environment."
  exit
  ;;
esac

if [ $env == "1" ]; then
  siteAlias=insidergov.prod
elif [ $env == "2" ]; then
  siteAlias=insidergov.stg
elif [ $env == "3" ]; then
  siteAlias=insidergov.train
elif [ $env == "4" ]; then
  siteAlias=insidergov.dev
elif [ $env == "5" ]; then
  siteAlias=insidergov.dev1
elif [ $env == "6" ]; then
  siteAlias=insidergov.test0
elif [ $env == "7" ]; then
  siteAlias=insidergov.test1
fi

lando_pink "Pulling Database."
echo ""

msg1="*****Don't forget to run import command*****"
msg2=$'\n\n'
msg3="lando db-import $fileName.sql -h $fileName"
msg4=$'\n\n'

# /usr/local/bin/acli remote:drush $siteAlias -- sql-dump --extra=--no-tablespaces > $fileName.sql && lando_green "$msg1 $msg2 $msg3 $msg4" || lando_red "Pull failed."

## Once all site is on drush 10 switch to this command to exlude pulling cache tables
/usr/local/bin/acli remote:drush $siteAlias -- sql-dump --structure-tables-list=cache* --extra-dump=--no-tablespaces > $fileName.sql && lando_green "$msg1 $msg2 $msg3 $msg4" || lando_red "Pull failed."
