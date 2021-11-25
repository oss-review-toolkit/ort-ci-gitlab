#!/bin/bash -e

REQUIRED_VAR_NAMES=(
SW_NAME
SW_VERSION
VCS_TYPE
VCS_URL
VCS_REVISION
)

RC=0
for REQUIRED_VAR_NAME in "${REQUIRED_VAR_NAMES[@]}"; do
  if [[ -z ${!REQUIRED_VAR_NAME} ]]; then
    echo "[ERROR] Required variable $REQUIRED_VAR_NAME is not specified"
    RC=1
  fi
done

exit $RC
