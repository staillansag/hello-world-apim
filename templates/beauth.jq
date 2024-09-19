if .backendAuthentication.authType == "HTTP_BASIC" then
    {
        "policyAction": {
            "names": [{"value": "Outbound Auth - Transport", "locale": "en"}],
            "templateKey": "outboundTransportAuthentication",
            "parameters": [
                {
                    "templateKey": "transportSecurity",
                    "parameters": [
                        {"templateKey": "authType", "values": ["HTTP_BASIC"]},
                        {"templateKey": "authMode", "values": ["NEW"]},
                        {
                            "templateKey": "httpAuthCredentials",
                            "parameters": [
                                {"templateKey": "userName", "values": [.backendAuthentication.userName]},
                                {"templateKey": "password", "values": [.backendAuthentication.password]}
                            ]
                        }
                    ]
                }
            ],
            "active": false
        }
    }
elif .backendAuthentication.authType == "INCOMING_OAUTH_TOKEN" then
    {
        "policyAction": {
            "names": [{"value": "Outbound Auth - Transport", "locale": "en"}],
            "templateKey": "outboundTransportAuthentication",
            "parameters": [
                {
                    "templateKey": "transportSecurity",
                    "parameters": [
                        {"templateKey": "authType", "values": ["OAUTH2"]},
                        {"templateKey": "authMode", "values": ["INCOMING_OAUTH_TOKEN"]}
                    ]
                }
            ],
            "active": false
        }
    }
elif .backendAuthentication.authType == "INCOMING_JWT_TOKEN" then
    {
        "policyAction": {
            "names": [{"value": "Outbound Auth - Transport", "locale": "en"}],
            "templateKey": "outboundTransportAuthentication",
            "parameters": [
                {
                    "templateKey": "transportSecurity",
                    "parameters": [
                        {"templateKey": "authType", "values": ["JWT"]},
                        {"templateKey": "authMode", "values": ["INCOMING_JWT"]}
                    ]
                }
            ],
            "active": false
        }
    }
elif .backendAuthentication.authType == "INCOMING_HTTP_BASIC" then
    {
        "policyAction": {
            "names": [{"value": "Outbound Auth - Transport", "locale": "en"}],
            "templateKey": "outboundTransportAuthentication",
            "parameters": [
                {
                    "templateKey": "transportSecurity",
                    "parameters": [
                        {"templateKey": "authType", "values": ["HTTP_BASIC"]},
                        {"templateKey": "authMode", "values": ["INCOMING_HTTP_BASIC_AUTH"]}
                    ]
                }
            ],
            "active": false
        }
    }
elif .backendAuthentication.authType == "ALIAS" then
    {
        "policyAction": {
            "names": [{"value": "Outbound Auth - Transport", "locale": "en"}],
            "templateKey": "outboundTransportAuthentication",
            "parameters": [
                {
                    "templateKey": "transportSecurity",
                    "parameters": [
                        {"templateKey": "authType", "values": ["ALIAS"]},
                        {"templateKey": "authMode", "values": ["NEW"]},
                        {"templateKey": "alias", "values": [.backendAuthentication.alias]}
                    ]
                }
            ],
            "active": false
        }
    }
else
    null
end