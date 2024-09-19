if [ "$ACTION" != "UPDATE" ] ; then
    echo "--- New API, skipping update step"
    exit 0
fi

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "SPEC_TYPE         = ${SPEC_TYPE}"
echo "API_SPEC_FILE     = ${API_SPEC_FILE}"
echo "API_NAME          = ${API_NAME}"
echo "API_VERSION       = ${API_VERSION}"
echo "API_ID            = ${API_ID}"
echo "API_POLICY_ID     = ${API_POLICY_ID}"
echo "ACTION            = ${ACTION}"

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/apis/${API_ID}/deactivate" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json')

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API deactivation failed: $ERROR_DETAILS"
    echo ${RESPONSE}
    exit 1
fi

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/apis/${API_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--form "type=${SPEC_TYPE}" \
--form "apiName=${API_NAME}" \
--form "apiVersion=${API_VERSION}" \
--form "policies=${API_POLICY_ID}" \
--form "file=@${API_SPEC_FILE}" | jq 'del(.apiResponse.api.apiDefinition)')

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API update failed: $ERROR_DETAILS"
    exit 1
fi

# We look for the ID of the team having name = metadata.team

json=$(jq -f ./templates/searchteam.jq manifest.json)

RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}")

ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')
TEAM_ID=$(echo "$RESPONSE" | jq -r '.accessprofiles[0].id')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- Team search failed: $ERROR_DETAILS"
    exit 1
fi

if [ "$TEAM_ID" == "null" ] ; then
    echo "--- Team not found"
    exit 1
fi

# Then we update the team of the API

json=$(jq -n --arg api_id "$API_ID" --arg team_id "$TEAM_ID" '{
    "assetType": "API",
    "assetIds": [
        $api_id
    ],
    "newTeams": [
        $team_id
    ]
}')

RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/assets/team" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}" )

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API creation failed: $ERROR_DETAILS"
    exit 1
fi

echo "TEAM_ID           = ${TEAM_ID}"