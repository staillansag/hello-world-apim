{
  "policyAction": {
    "names": [
      {
        "value": "Request Transformation",
        "locale": "en"
      }
    ],
    "templateKey": "requestTransformation",
    "parameters": [
      {
        "templateKey": "transformationConditions",
        "parameters": [
          {
            "templateKey": "logicalConnector",
            "values": ["OR"]
          }
        ]
      },
      {
        "templateKey": "requestTransformationConfiguration",
        "parameters": [
          {
            "templateKey": "commonTransformation",
            "parameters": 
            (.requestTransformations[0].requestTransformationConfigurations | reduce .[] as $item ([]; 
              if $item.type == "addOrModify" then
                . + [
                  {
                    "templateKey": "addOrModify",
                    "parameters": [
                      {
                        "templateKey": "transformationVariable",
                        "values": [$item.target]
                      },
                      {
                        "templateKey": "transformationValue",
                        "values": [$item.value]
                      }
                    ]
                  }
                ]
              elif $item.type == "remove" then
                . + [
                  {
                    "templateKey": "remove",
                    "values": [$item.target]
                  }
                ]
              else
                .
              end
            ))
          }
        ]
      }
    ],
    "active": false
  }
}
