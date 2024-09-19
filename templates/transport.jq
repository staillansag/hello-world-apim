{
    policyAction: {
        names: [
            {
                value: "Enable HTTP / HTTPS",
                locale: "en"
            }
        ],
        templateKey: "entryProtocolPolicy",
        parameters: [
            {
                templateKey: "protocol",
                values: .transport
            }
        ],
        active: false
    }
}