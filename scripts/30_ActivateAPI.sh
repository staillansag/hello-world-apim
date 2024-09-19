. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "API_ID            = ${API_ID}"

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/apis/${API_ID}/activate" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json')

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API activation failed: $ERROR_DETAILS"
    echo ${RESPONSE}
    exit 1
fi
