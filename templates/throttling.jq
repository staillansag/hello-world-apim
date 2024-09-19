{
    policyAction: {
        id: "3381ca72-e5cf-4d58-8bd0-e06f689b30c8",
        names: [
            {
                value: "Traffic Optimization",
                locale: "en"
            }
        ],
        templateKey: "throttle",
        parameters: ([
            {
                templateKey: "throttleRule",
                parameters: [
                    {templateKey: "throttleRuleName", values: ["requestCount"]},
                    {templateKey: "monitorRuleOperator", values: ["GT"]},
                    {templateKey: "value", values: [.throttling.limit]}
                ]
            },
            {templateKey: "consumerIds", values: .throttling.consumers},
            {templateKey: "consumerSpecificCounter", values: ["false"]},
            {templateKey: "alertInterval", values: [.throttling.alertInterval]},
            {templateKey: "alertIntervalUnit", values: [.throttling.alertIntervalUnit]},
            {templateKey: "alertFrequency", values: [.throttling.alertFrequency]},
            {templateKey: "alertMessage", values: [.throttling.alertMessage]}
        ] + [
            .throttling.destinations[] | {
                templateKey: "destination",
                parameters: [
                    {
                        templateKey: "destinationType",
                        values: [.]
                    }
                ]
            }
        ]),
        active: false
    }
}