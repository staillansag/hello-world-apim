. ./scripts/00_Utils.sh

if [[ ! -f "manifest.json" ]]; then
    echo "The manifest.json file does not exist."
    exit 1
fi

SPEC_TYPE=$(jq -r '.metadata.specificationType' manifest.json)
API_SPEC_FILE=$(jq -r '.metadata.specificationFile' manifest.json)
API_NAME=$(jq -r '.metadata.name' manifest.json)
API_VERSION=$(jq -r '.metadata.version' manifest.json)

# Checking API metadata and existence of file
# We also inject key metadata into the pipeline variables

if [ "$SPEC_TYPE" == "null" ] ; then
    echo "metadata.specificationType missing"
    exit 1
else  
    if [[ "$SPEC_TYPE" != "openapi" && "$SPEC_TYPE" != "swagger" && "$SPEC_TYPE" != "raml" ]]; then
        echo "metadata.specificationType must be one of: openapi, swagger, raml"
        exit 1
    else
        echo "##vso[task.setvariable variable=SPEC_TYPE;]${SPEC_TYPE}"
    fi
fi

if [ "$API_SPEC_FILE" == "null" ] ; then
    echo "metadata.specificationFile missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=API_SPEC_FILE;]${API_SPEC_FILE}"
fi

if [[ ! -f "$API_SPEC_FILE" ]]; then
    echo "The API specification file $API_SPEC_FILE does not exist."
    exit 1
fi

if [ "$API_NAME" == "null" ] ; then
    echo "metadata.name missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=API_NAME;]${API_NAME}"
fi

if [ "$API_VERSION" == "null" ] ; then
    echo "metadata.version missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=API_VERSION;]${API_VERSION}"
fi

# Checking policies. We need at least a transport policy and a routing policy

array_length=$(jq '.transport | length' manifest.json)
if [ "$array_length" -eq 0 ]; then
    echo "transport information missing"
    exit 1
fi

valid_transports=("http" "https")
transport_values=$(jq -r '.transport[]' manifest.json)

for value in $transport_values; do
    if [[ ! " ${valid_transports[@]} " =~ " ${value} " ]]; then
        echo "transport $value is invalid"
        exit 1
    fi
done

ROUTING=$(jq -r '.routing' manifest.json)
if [ "$ROUTING" == "null" ] ; then
    echo "routing information missing"
    exit 1
fi