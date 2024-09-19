map(
    if .stageKey == $STAGE_KEY then
        .enforcements += [{
            "enforcementObjectId": $POLICY_ID,
            "order": "\(.enforcements | length)"
        }]
    else
        .
    end
)
