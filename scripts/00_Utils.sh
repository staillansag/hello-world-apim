if [[ -f "${TRUSTSTORE_SECUREFILEPATH}" ]]; then
    export CURL_CA_BUNDLE=${TRUSTSTORE_SECUREFILEPATH}
    echo "Curl trustStore set to ${CURL_CA_BUNDLE}"
fi

createPolicyEnforcement() {
    local jq_file="$1"
    local json_file="$2"
    local stage_key="$3"
    local enforcement_file="$4"

    # Check if files exist
    if [[ ! -f "$jq_file" ]]; then
        echo "The jq template file $jq_file does not exist." >&2
        return 1
    fi

    if [[ ! -f "$json_file" ]]; then
        echo "The JSON file $json_file does not exist." >&2
        return 1
    fi

    if [[ ! -f "$enforcement_file" ]]; then
        echo "The enforcement file $enforcement_file does not exist." >&2
        return 1
    fi

    # Validate the stage_key value
    case "$stage_key" in
        transport|IAM|LMT|requestPayloadProcessing|routing|responseProcessing)
            ;; # Valid values
        *)
            echo "Invalid stage_key value: $stage_key" >&2
            return 1
            ;;
    esac

    local json=$(jq -f "$jq_file" "$json_file")

    local policy_id=$(curl -s --location --request POST "${APIGW_URL}/policyActions" \
        -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
        --header 'accept: application/json' \
        --header 'Content-Type: application/json' \
        --data-raw "${json}" | jq -r '.policyAction.id')

    if [[ -z "$policy_id" || "$policy_id" == "null" ]]; then
        echo "Failed to obtain policy enforcement ID." >&2
        echo "Policy enforcement JSON:"
        echo ${json}
        return 1
    fi

    # Update the enforcement file using jq
    jq -f ./templates/enforcement.jq --arg POLICY_ID "$policy_id" --arg STAGE_KEY "$stage_key" "$enforcement_file" > ./tmp && mv ./tmp "$enforcement_file"

}

deleteAPI() {
    local api_id="$1"

    if [ -z "$api_id" ]; then
        echo "API ID is missing" >&2
        return 1
    fi

    RESPONSE=$(curl -s --location --request DELETE "${APIGW_URL}/apis/${API_ID}" \
    -u ${APIGW_USERNAME}:${APIGW_PASSWORD})

}
