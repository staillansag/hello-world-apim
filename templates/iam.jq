{
  "policyAction": {
    "names": [
      {
        "value": "Identify & Authorize",
        "locale": "en"
      }
    ],
    "templateKey": "evaluatePolicy",
    "parameters": ([
      {
        "templateKey": "logicalConnector",
        "values": [.iam.logicalConnector]
      },
      {
        "templateKey": "allowAnonymous",
        "values": [.iam.allowAnonymous]
      }
    ] + 
    (
      .iam.conditions | map({
        "templateKey": "IdentificationRule",
        "parameters": [
          {
            "templateKey": "applicationLookup",
            "values": [.applicationLookup]
          },
          {
            "templateKey": "identificationType",
            "values": [.type]
          }
        ]
      })
    ) + 
    [{
      "templateKey": "triggerPolicyViolationOnMissingAuthorizationHeader",
      "values": ["false"]
    }]),
    "active": false
  }
}
