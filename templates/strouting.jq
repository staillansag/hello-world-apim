{
    "policyAction": {
        "names": [
            {
                "value": "Straight Through Routing",
                "locale": "en"
            }
        ],
        "templateKey": "straightThroughRouting",
        "parameters": [
            {
                "templateKey": "endpointUri",
                "values": [.routing.endpointUri]
            },
            {
                "templateKey": "method",
                "values": [.routing.method]
            },
            (if .routing.keyStoreAlias? or .routing.keyAlias? or .routing.truststoreAlias? then
                {
                    "templateKey": "sslConfig",
                    "parameters": [
                        (if .routing.keyStoreAlias? then
                            {
                                "templateKey": "keyStoreAlias",
                                "values": [.routing.keyStoreAlias]
                            }
                        else
                            empty
                        end),
                        (if .routing.keyAlias? then
                            {
                                "templateKey": "keyAlias",
                                "values": [.routing.keyAlias]
                            }
                        else
                            empty
                        end),
                        (if .routing.truststoreAlias? then
                            {
                                "templateKey": "truststoreAlias",
                                "values": [.routing.truststoreAlias]
                            }
                        else
                            empty
                        end)
                    ]
                }
            else
                empty
            end),
            (if .routing.connectTimeout? then
                {
                    "templateKey": "connectTimeout",
                    "values": [.routing.connectTimeout]
                }
            else
                empty
            end),
            (if .routing.readTimeout? then
                {
                    "templateKey": "readTimeout",
                    "values": [.routing.readTimeout]
                }
            else
                empty
            end)
        ],
        "active": false
    }
}
