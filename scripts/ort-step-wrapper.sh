#!/bin/bash

# Wrapper for individual ORT bash scripts so we can capture
# status, start and end times and use them in metadata.json

STEP=$1
[[ -z "$STEP" ]] && { echo "STEP is not specified" ; exit 1; }
STEP_NAME_UPPERCASED=${STEP^^}

START_TIME=$(date +"%Y-%m-%dT%H:%M:%S%z")

./scripts/ort-${STEP}.sh
EXIT_CODE=$?

END_TIME=$(date +"%Y-%m-%dT%H:%M:%S%z")

case "$EXIT_CODE" in
    0 ) STATUS="success"
    ;;
    1 ) STATUS="failed"
    ;;
    * ) STATUS="unstable"
    ;;
esac

echo "export ${STEP_NAME_UPPERCASED}_START_TIME='${START_TIME}'" >> vars.env
echo "export ${STEP_NAME_UPPERCASED}_STATUS='${STATUS}'" >> vars.env
echo "export ${STEP_NAME_UPPERCASED}_END_TIME='${END_TIME}'" >> vars.env

[[ $EXIT_CODE -eq 1 ]] && exit 1 || exit 0