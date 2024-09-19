. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "API_ID            = ${API_ID}"

# We update metadata related to the API

json=$(curl -s --location --request GET "${APIGW_URL}/apis/${API_ID}" \
    -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
    --header 'accept: application/json' \
    | jq -r '.apiResponse.api' \
    | jq --slurpfile meta manifest.json '. + {
    apiDescription: $meta[0].metadata.description,
    apiGroups: $meta[0].metadata.groups,
    maturityState: $meta[0].metadata.maturityState
    }')

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/apis/${API_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}" )

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')
API_ID=$(echo $RESPONSE | jq -r '.apiResponse.api.id')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API metadata update failed: $ERROR_DETAILS"
    echo $RESPONSE | jq
    exit 1
fi

# We look for an Oauth2 scope matching metadata.scope

json=$(jq -f ./templates/searchscope.jq manifest.json)

RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}")

ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')
SCOPE_ID=$(echo "$RESPONSE" | jq -r '.gateway_scope[0].id')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- Oauth2 scope search failed: $ERROR_DETAILS"
    exit 1
fi

if [ "$SCOPE_ID" == "null" ] ; then
    echo "--- Oauth2 scope not found"
    exit 1
fi

# if this scope if found then we update it, by adding the API to the array of assets
# (but only if the API wasn't already included in the array)

json=$(curl -s --location --request GET "${APIGW_URL}/scopes/${SCOPE_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
| jq -r '.scope' \
| jq --arg api "$API_ID" '.apiScopes += if (.apiScopes | index($api)) == null then [$api] else [] end')

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/scopes/${SCOPE_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}" )

ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- Oauth2 scope update failed: $ERROR_DETAILS"
    exit 1
fi

echo "SCOPE_ID          = ${APIGW_USERNAME}"