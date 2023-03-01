#! /bin/bash

# Get the lando logger
. /helpers/log.sh

cd /app/docroot/themes/custom/insider
npm install && npm run compile && lando_green "*****Exchange theme build complete.*****"
