#!/bin/bash

# Execute ORT's Evaluator to evaluate copyright, file, package and license findings
# against customizable policy rules.

if [[ "$ORT_DISABLE_SCANNER" = "true" ]]; then
    if [[ "$ORT_DISABLE_ADVISOR" = "true" ]]; then
        ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_ANALYZER_FILE
    else
        ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_ADVISOR_FILE
    fi
else
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_SCANNER_FILE
fi

if [[ -f "$ORT_CONFIG_LICENSE_CLASSIFICATIONS_FILE" ]]; then
    ORT_EVALUATOR_OPTIONS="--license-classifications-file $ORT_CONFIG_LICENSE_CLASSIFICATIONS_FILE"
else
    ORT_EVALUATOR_OPTIONS=""
fi

if [[ -d "$ORT_CONFIG_PACKAGE_CONFIGURATION_DIR" ]]; then
    ORT_EVALUATOR_OPTIONS="$ORT_EVALUATOR_OPTIONS --package-configuration-dir $ORT_CONFIG_PACKAGE_CONFIGURATION_DIR"
elif [[ -f "$ORT_CONFIG_PACKAGE_CONFIGURATION_FILE" ]]; then
    ORT_EVALUATOR_OPTIONS="$ORT_EVALUATOR_OPTIONS --package-configuration-file $ORT_CONFIG_PACKAGE_CONFIGURATION_FILE"
elif [[ -d "$ORT_CONFIG/packages" ]]; then
    # Use legacy named package configuration directory if present.
    ORT_EVALUATOR_OPTIONS="$ORT_EVALUATOR_OPTIONS --package-configuration-dir $ORT_CONFIG/packages"
    ORT_CONFIG_PACKAGE_CONFIGURATION_DIR=$ORT_CONFIG/packages
fi

if [[ ! -f "$ORT_CONFIG_RULES_FILE" ]]; then
    # Use legacy named policy rules file if present
    if [[ -f "$ORT_CONFIG_DIR/rules.kts" ]]; then
        ORT_CONFIG_RULES_FILE="$ORT_CONFIG_DIR/rules.kts"
    else
        # Use first found file with .rules.kts extension 
        FIND_RESULTS=$(find $ORT_CONFIG_DIR -type f -name '*.rules.kts')
        RESULT_FILES=( $FIND_RESULTS )
        ORT_CONFIG_RULES_FILE="${RESULT_FILES[0]}"
    fi
fi

if [[ -f "$ORT_CONFIG_RULES_FILE" ]]; then
    echo "Using ORT policy rules file found in $ORT_CONFIG_RULES_FILE..."
else
    echo "Error: ORT policy rules file (*.rules.kts) not found. Please set ORT_CONFIG_RULES_FILE"
fi

$ORT_CLI \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    evaluate \
    $ORT_EVALUATOR_OPTIONS \
    -i $ORT_RESULTS_INPUT_FILE \
    -o $ORT_RESULTS_DIR \
    -r $ORT_CONFIG_RULES_FILE \
    -f JSON

EXIT_CODE=$?
if [ $EXIT_CODE -ge 2 ]; then
    EXIT_CODE=2
fi

# Upload the final ORT result to PostgreSQL.
# $ORT_CLI \
#     --$ORT_LOG_LEVEL \
#     --stacktrace \
#     -c $ORT_CLI_CONFIG_FILE \
#     upload-result-to-postgres \
#     -i $ORT_RESULTS_EVALUATOR_FILE \
#     --table-name ossreview \
#     --column-name result

exit $EXIT_CODE
