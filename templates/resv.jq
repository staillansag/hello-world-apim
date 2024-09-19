{
    policyAction: {
        names: [
            {
                value: "Validate API Specification",
                locale: "en"
            }
        ],
        templateKey: "validateAPISpec",
        parameters: [
            {
                templateKey: "schemaValidationFlag",
                values: [ .responseValidation.validatePayload ]
            },
            {
                templateKey: "validateCookieParams",
                values: [ "false" ]
            },
            {
                templateKey: "validateContentTypes",
                values: [ .responseValidation.validateContentType ]
            },
            {
                templateKey: "headersValidationFlag",
                values: [ .responseValidation.validateHeaders ]
            },
            {
                templateKey: "validateQueryParams",
                values: [ "false" ]
            },
            {
                templateKey: "validatePathParams",
                values: [ "false" ]
            }
        ],
        active: false
    }
}