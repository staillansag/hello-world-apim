{
    types: ["ACCESSPROFILES"],
    scope: [
        {
            attributeName: "name",
            keyword: .metadata.team
        }
    ],
    responseFields: [
        "name",
        "id"
    ],
    condition: "and"
}