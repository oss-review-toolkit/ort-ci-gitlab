#!/bin/bash

# Executes ORT's Advisor to retrieve security advisories
# for used dependencies from configured vulnerability data services.

if [[ "$ORT_DISABLE_SCANNER" = "true" ]]; then
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_ANALYZER_FILE
else
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_SCANNER_FILE
fi

$ORT_CLI \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    advise \
    -a $ORT_ADVISOR_PROVIDERS
    -i $ORT_RESULTS_INPUT_FILE \
    -o $ORT_RESULTS_DIR \
    -f JSON

EXIT_CODE=$?
if [ $EXIT_CODE -ge 2 ]; then
    EXIT_CODE=2
fi