. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "API_ID            = ${API_ID}"

if [ -z "$API_ID" ]; then
    echo "API_ID is empty - API wasn't created so nothing to do"
    exit 0
fi

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" --location --request DELETE "${APIGW_URL}/apis/${API_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD})

if [ "$RESPONSE" != "204" ] ; then
    echo "--- API deletion failed: $RESPONSE"
    exit 1
fi
