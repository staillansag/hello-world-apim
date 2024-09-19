. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"

if [[ -f "${ALIASES_SECUREFILEPATH}" ]]; then

    cat "${ALIASES_SECUREFILEPATH}"
    json_array=$(<"${ALIASES_SECUREFILEPATH}")

    len=$(echo "$json_array" | jq 'length')

    for i in $(seq 0 $(($len-1))); do
        json=$(echo "$json_array" | jq ".[$i]")

        ALIAS_NAME=$(echo "$json" | jq -r ".name")

        RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/alias" \
        -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
        --header 'accept: application/json' \
        --header 'Content-Type: application/json' \
        --data-raw "${json}")

        ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

        if [ "$ERROR_DETAILS" == "null" ] ; then
            echo "Creation of alias ${ALIAS_NAME} succeeded"
        else
            echo "Creation of alias ${ALIAS_NAME} failed: $ERROR_DETAILS"
            echo "Submitted payload:"
            echo $json
        fi
    done
else
    echo "No alias found"
fi
