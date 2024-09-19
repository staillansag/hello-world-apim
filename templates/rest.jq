{
    policyAction: {
        names: [
            {
                value: "Response Transformation",
                locale: "en"
            }
        ],
        templateKey: "responseTransformation",
        parameters: [
            {
                templateKey: "transformationConditions",
                parameters: [
                    {
                        templateKey: "logicalConnector",
                        values: [ "OR" ]
                    }
                ]
            },
            {
                templateKey: "responseTransformationConfiguration",
                parameters: 
                .responseTransformations[0].responseTransformationConfigurations | map(
                    if .type == "addOrModify" then 
                        {
                            templateKey: "restHeaderTransformation",
                            parameters: [
                                {
                                    templateKey: "addOrModify",
                                    parameters: [
                                        {
                                            templateKey: "transformationVariable",
                                            values: [ .target ]
                                        },
                                        {
                                            templateKey: "transformationValue",
                                            values: [ .value ]
                                        }
                                    ]
                                }
                            ]
                        } 
                    elif .type == "remove" then 
                        {
                            templateKey: "restHeaderTransformation",
                            parameters: [
                                {
                                    templateKey: "remove",
                                    values: [ .target ]
                                }
                            ]
                        }
                    elif .type == "statusTransformation" then
                        {
                            templateKey: "statusTransformation",
                            parameters: [
                                {
                                    templateKey: "statusCodeOptional",
                                    values: [ .target ]
                                },
                                {
                                    templateKey: "statusMessage",
                                    values: [ .value ]
                                }
                            ]
                        }
                    else empty
                    end
                )
            }
        ],
        active: false
    }
}