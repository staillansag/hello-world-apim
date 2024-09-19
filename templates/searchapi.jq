{
    types: ["API"],
    scope: [
        {
            attributeName: "apiName",
            keyword: .metadata.name
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