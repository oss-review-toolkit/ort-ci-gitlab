#!/bin/bash

# Executes ORT's Downloader to fetch the project to be scanned.

echo "------------------------------------------"
echo "Running ORT downloader..."
echo "------------------------------------------"

# Remove all special characters and whitespace from the PROJECT_NAME, because some tools cannot handle them.
SAFE_SW_NAME=$(echo $SW_NAME | sed -e 's/[^A-Za-z0-9 \-\_]//g' -e 's/\s/_/g')

$ORT_CLI \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    download \
    --project-name "$SAFE_SW_NAME" \
    --project-url "$VCS_URL" \
    --vcs-type "$VCS_TYPE" \
    --vcs-revision "$VCS_REVISION" \
    --vcs-path "$VCS_PATH" \
    -o $PROJECT_DIR
