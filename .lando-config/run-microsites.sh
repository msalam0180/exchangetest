#!/bin/bash

# Get the lando logger
. /helpers/log.sh

source ~/.bashrc

# Set default opts
MODE="1"

# PARSE THE ARGZZ
# TODO: compress the mostly duplicate code below?
while (("$#")); do
  case "$1" in
  -m | --mode | --mode=*)
    if [ "${1##--mode=}" != "$1" ]; then
      MODE="${1##--mode=}"
      shift
    else
      MODE=$2
      shift 2
    fi
    ;;
  --surprise)
    echo "MUHAHAH! You've found a non explicitly declared option for this script which is going to give you an error!"
    exit 666
    ;;
  --)
    shift
    break
    ;;
  -* | --*=)
    echo "Error: Unsupported flag $1" >&2
    exit 1
    ;;
  *)
    shift
    ;;
  esac
done

case $MODE in 1 | 2)
  lando_pink "Mode selected: [$MODE]"
  ;;
*)
  lando_red "Error! Invalid Mode."
  exit
  ;;
esac

LATEST_CONTENT=$(drush @local.exchange sql-query "select max(changed) as t from taxonomy_term_field_data where vid = 'site_section' and status = 1 union select max(changed) as t from node_field_data n inner join node__field_site_section s on s.entity_id = n.nid where n.status = 1 order by t desc limit 1 ")

LATEST_BUILD=$(cat ~/.lastbuild.local.exchange)

if [ ! -e /app/docroot/files/gatsby.key ]; then
  echo "Creating gatsby keys locally."
  cd /app/docroot/files
  openssl genrsa -out gatsby.key 2048
  openssl rsa -in gatsby.key -pubout >gatsby.public.key
fi

if
  [ "$MODE" == "1" ]
then
  if
    [ "$LATEST_CONTENT" != "$LATEST_BUILD" ]
  then
    lando_pink "New content detected, running gatsby build for local.exchange"
    echo $LATEST_CONTENT >~/.lastbuild.local.exchange
    cd /app/microsites
    nvm use 12 >~/microsites-build.log 2>&1 && lando_green "Using Node version 12"
    gatsby telemetry --disable >~/microsites-build.log 2>&1
    export $(grep -v "^#" .env.local | xargs)
    export GATSBY_API_TOKEN=$(curl -k -X POST -d "client_id=${GATSBY_API_UUID}&grant_type=password&client_secret=${GATSBY_API_SECRET}&username=${GATSBY_API_USER}&password=${GATSBY_API_PWD}" $GATSBY_API_DOMAIN/oauth/token | jq -r ".access_token")

    gatsby clean >~/microsites-build.log 2>&1 && lando_pink "gatsby clean - done"
    lando_pink "gatsby build log file within lando ~/microsites-build.log"
    gatsby build --prefix-paths >~/microsites-build.log 2>&1 && lando_pink "gatsby build - done"

    cd public
    tar -czf ../public.local.tar.gz . && lando_pink "Created tar.gz - done"

    # Create directory for microsites previews
    if [ ! -d /app/docroot/files/sites/demo/ ]; then
      mkdir -p /app/docroot/files/sites/demo && lando_pink "Created directory /app/docroot/files/sites/demo"
    fi

    cp ../public.local.tar.gz /app/docroot/files/sites/demo/ && lando_pink "Copy tar.gz to /app/docroot/files/sites/demo"
    rm ../public.local.tar.gz
    cd /app/docroot/files/sites/demo && lando_pink "Change directory to /app/docroot/files/sites/demo"
    tar -xzf public.local.tar.gz && lando_pink "Unzip tar.gz - done"
    lando_green "---------- Deployment to local.exchange complete ----------"
  else
    lando_green "---------- No Changes detected ----------"
  fi
fi

if
  [ "$MODE" == "2" ]
then
  cd /app/microsites
  nvm use 12 >~/microsites-build.log 2>&1 && lando_green "Using Node version 12"
  gatsby telemetry --disable >~/microsites-build.log 2>&1
  export $(grep -v "^#" .env.local | xargs)
  export GATSBY_API_TOKEN=$(curl -k -X POST -d "client_id=${GATSBY_API_UUID}&grant_type=password&client_secret=${GATSBY_API_SECRET}&username=${GATSBY_API_USER}&password=${GATSBY_API_PWD}" $GATSBY_API_DOMAIN/oauth/token | jq -r ".access_token")

  gatsby clean >~/microsites-develop.log 2>&1 && lando_pink "gatsby clean - done"
  lando_pink "gatsby develop log file within lando ~/microsites-develop.log"
  gatsby develop --host 0.0.0.0 >~/microsites-develop.log 2>&1
fi
