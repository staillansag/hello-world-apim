. ./scripts/00_Utils.sh

json=$(jq -f ./templates/searchapiversion.jq manifest.json)

RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}")

ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')
API_ID=$(echo "$RESPONSE" | jq -r '.api[0].id')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API search failed: $ERROR_DETAILS"
    echo $RESPONSE | jq
    exit 1
fi

if [ "$API_ID" == "null" ]; then

    json=$(jq -f ./templates/searchapi.jq manifest.json)

    RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
    -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
    --header 'accept: application/json' \
    --header 'Content-Type: application/json' \
    --data-raw "${json}")

    ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')
    API_ID=$(echo "$RESPONSE" | jq -r '.api[0].id')

    if [ "$ERROR_DETAILS" != "null" ] ; then
        echo "--- API search failed: $ERROR_DETAILS"
        echo $RESPONSE | jq
        exit 1
    fi

    if [ "$API_ID" == "null" ] ; then
        echo "--- API not found"
        echo "##vso[task.setvariable variable=ACTION;]CREATE"
    else
        echo "--- API ${API_NAME} already exists with a different version than ${API_VERSION}"
        echo "--- Creation of new API version not yet supported"
        exit 2
    fi

else
    echo "--- API found with ID: ${API_ID}"
    echo "##vso[task.setvariable variable=API_ID;]${API_ID}"

    API_POLICY_ID=$(echo $RESPONSE | jq -r '.api[0].policies[0]')
    echo "--- API policy ID: ${API_POLICY_ID}"
    echo "##vso[task.setvariable variable=API_POLICY_ID;]${API_POLICY_ID}"

    echo "##vso[task.setvariable variable=ACTION;]UPDATE"
fi

