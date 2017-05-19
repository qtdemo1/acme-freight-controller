#!/bin/bash
# Set app's env vars
if [ "$REPO_BRANCH" == "master" ]; then
  ACME_FREIGHT_ENV="PROD"
else
  ACME_FREIGHT_ENV="DEV"
fi
echo "ACME_FREIGHT_ENV: $ACME_FREIGHT_ENV"

domain=".mybluemix.net"
case "${REGION_ID}" in
  ibm:yp:eu-gb)
    domain=".eu-gb.mybluemix.net"
  ;;
  ibm:yp:au-syd)
  domain=".au-syd.mybluemix.net"
  ;;
esac
# Deploy app
if ! cf app $CF_APP; then
  cf push $CF_APP -n $CF_APP --no-start
  cf set-env $CF_APP ACME_FREIGHT_ENV ${ACME_FREIGHT_ENV}
  cf set-env $CF_APP ERP_SERVICE https://$ERP_SERVICE_APP_NAME$domain
  cf set-env $CF_APP OPENWHISK_AUTH "${OPENWHISK_AUTH}"
  cf set-env $CF_APP OPENWHISK_PACKAGE ${RECOMMENDATION_PACKAGE_NAME}
  cf set-env $CF_APP OW_API_KEY "${OW_API_KEY}"
  cf set-env $CF_APP OW_API_URL "${OW_API_URL}"
  cf start $CF_APP
else
  OLD_CF_APP=${CF_APP}-OLD-$(date +"%s")
  rollback() {
    set +e
    if cf app $OLD_CF_APP; then
      cf logs $CF_APP --recent
      cf delete $CF_APP -f
      cf rename $OLD_CF_APP $CF_APP
    fi
    exit 1
  }
  set -e
  trap rollback ERR
  cf rename $CF_APP $OLD_CF_APP
  cf push $CF_APP -n $CF_APP --no-start
  cf set-env $CF_APP ACME_FREIGHT_ENV ${ACME_FREIGHT_ENV}
  cf set-env $CF_APP ERP_SERVICE https://$ERP_SERVICE_APP_NAME$domain
  cf set-env $CF_APP OPENWHISK_AUTH "${OPENWHISK_AUTH}"
  cf set-env $CF_APP OPENWHISK_PACKAGE ${RECOMMENDATION_PACKAGE_NAME}
  cf set-env $CF_APP OW_API_KEY "${OW_API_KEY}"
  cf set-env $CF_APP OW_API_URL "${OW_API_URL}"
  cf start $CF_APP
  cf delete $OLD_CF_APP -f
fi
