{
    "policyAction": {
        "names": [
            {
                "value": "Validate API Specification",
                "locale": "en"
            }
        ],
        "templateKey": "validateAPISpec",
        "parameters": [
            {
                "templateKey": "schemaValidationFlag",
                "values": [.requestValidation.validatePayload]
            },
            {
                "templateKey": "validateQueryParams",
                "values": [.requestValidation.validateQueryParameters]
            },
            {
                "templateKey": "validatePathParams",
                "values": [.requestValidation.validatePathParameters]
            },
            {
                "templateKey": "validateCookieParams",
                "values": [.requestValidation.validateCookies]
            },
            {
                "templateKey": "validateContentTypes",
                "values": [.requestValidation.validateContentType]
            },
            {
                "templateKey": "headersValidationFlag",
                "values": [.requestValidation.validateHeaders]
            }
        ],
        "active": false
    }
}