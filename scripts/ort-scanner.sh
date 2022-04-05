#!/bin/bash

# Executes ORT's Scanner which uses configured source code scanners to detect license / copyright findings.

export JAVA_OPTS="-Xmx24G"

echo "Scan source code for packages defined as dependencies and store results in $ORT_RESULTS_DIR."
$ORT_CLI \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    -c $ORT_CLI_CONFIG_FILE \
    scan \
    -i $ORT_RESULTS_ANALYZER_FILE \
    -o $ORT_RESULTS_DIR \
    -f JSON
