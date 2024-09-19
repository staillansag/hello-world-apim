. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "API_ID            = ${API_ID}"

ENDPOINTS=$(curl -s --location --request GET "${APIGW_URL}/apis/${API_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' | jq '.apiResponse.gatewayEndPoints')

if [ -z "$ENDPOINTS" ]; then
  echo "--- No endpoints found for API"
  exit 1
fi

json=$(jq -f ./templates/searchportal.jq manifest.json)

RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}")

ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API search failed: $ERROR_DETAILS"
    echo $RESPONSE | jq
    exit 1
fi

PORTAL_ID=$(echo "$RESPONSE" | jq -r '.portal_gateway[0].id')

if [ "$PORTAL_ID" == "null" ] ; then
    echo "--- Developer Portal not found"
    exit 1
fi

COMMUNITY=$(jq -r '.metadata.community' manifest.json)

COMMUNITY_ID=$(curl -s --location --request GET "${APIGW_URL}/portalGateways/communities?portalGatewayId=${PORTAL_ID}&apiId=${API_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' | jq -r --arg community "$COMMUNITY" '.portalGatewayResponse.communities.portalCommunities[] | select(.name == $community) | .id')

if [ "$COMMUNITY_ID" == "null" ] ; then
    echo "--- Community not found"
    exit 1
fi

json=$(jq --argjson endpoints "$ENDPOINTS" --arg communityId "$COMMUNITY_ID" \
'{
    communities: [{id: $communityId}],
    endpoints: $endpoints
}' <<< '{}')

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/apis/${API_ID}/publish?portalGatewayId=${PORTAL_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}")

ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API publish failed: $ERROR_DETAILS"
    echo $RESPONSE | jq
    echo "Posted json: ${json}"
    exit 1
fi
