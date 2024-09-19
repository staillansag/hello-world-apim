{
    types: ["GATEWAY_SCOPE"],
    scope: [
        {
            attributeName: "scopeName",
            keyword: .metadata.scope
        }
    ],
    responseFields: [
        "scopeName",
        "id"
    ],
    condition: "and"
}