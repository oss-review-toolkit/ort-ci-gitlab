#!/bin/bash

if [[ "$ORT_DISABLE_SCANNER" = "true" ]]; then
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_ANALYZER_FILE
elif [[ "$ORT_DISABLE_ADVISOR" = "false" ]]; then
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_ADVISOR_FILE
else
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_SCANNER_FILE
fi

$ORT \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    evaluate \
    -i $ORT_RESULTS_INPUT_FILE \
    -o $ORT_RESULTS_DIR \
    -r $ORT_CONFIG_DIR/rules.kts \
    -f JSON \
    --license-classifications-file $ORT_CONFIG_LICENSE_CONFIGURATION_FILE \
    --package-configuration-dir $ORT_CONFIG_PACKAGE_CONFIGURATION_DIR

EXIT_CODE=$?
if [ $EXIT_CODE -ge 2 ]; then
    EXIT_CODE=2
fi

# Upload the final ORT result to PostgreSQL.
# $ORT \
#     --$ORT_LOG_LEVEL \
#     --stacktrace \
#     -c $ORT_CLI_CONFIG_FILE \
#     upload-result-to-postgres \
#     -i $ORT_RESULTS_EVALUATOR_FILE \
#     --table-name ossreview \
#     --column-name result

exit $EXIT_CODE
