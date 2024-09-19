# Build parameters
def buildParameters:
    [
        # TTL is always there
        {
            templateKey: "ttl",
            values: [.caching.ttl]
        },
        # Include max-payload-size only if it's present
        (if .caching.maximumPayloadSize? then 
            {
                templateKey: "max-payload-size",
                values: [.caching.maximumPayloadSize]
            } 
         else 
            empty 
         end),
        # cacheCriteria processing
        (if .caching.cacheCriteria? and (.caching.cacheCriteria | length > 0) then
            {
                templateKey: "cacheCriteria",
                parameters: .caching.cacheCriteria[] | (
                    if .type == "header" then
                        {
                            templateKey: "httpHeader",
                            parameters: [
                                {
                                    templateKey: "httpHeaderName",
                                    values: [.name]
                                },
                                {
                                    templateKey: "whiteList",
                                    values: .values
                                }
                            ]
                        }
                    elif .type == "queryParameter" then
                        {
                            templateKey: "queryParam",
                            parameters: [
                                {
                                    templateKey: "queryParamName",
                                    values: [.name]
                                },
                                {
                                    templateKey: "whiteList",
                                    values: .values
                                }
                            ]
                        }
                    else
                        empty
                    end
                )
            }
         else
            empty
         end)
    ] | select(. != []);

# Construct the final policyAction object
{
    policyAction: {
        names: [
            {
                value: "Service Result Cache",
                locale: "en"
            }
        ],
        templateKey: "serviceResultCache",
        parameters: buildParameters,
        active: false
    }
} | if (buildParameters | length) == 0 then del(.policyAction.parameters) else . end
