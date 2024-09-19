{
    types: ["API"],
    scope: [
        {
            attributeName: "apiName",
            keyword: .metadata.name
        },
        {
            attributeName: "apiVersion",
            keyword: .metadata.version
        }
    ],
    responseFields: [
        "apiName",
        "apiVersion",
        "id",
        "policies"
    ],
    condition: "and"
}