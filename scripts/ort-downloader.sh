#!/bin/bash

echo "------------------------------------------"
echo "Running ORT downloader..."
echo "------------------------------------------"

# Remove all special characters and whitespace from the PROJECT_NAME, because some tools cannot handle them.
SAFE_PROJECT_NAME=$(echo $PROJECT_NAME | sed -e 's/[^A-Za-z0-9 \-\_]//g' -e 's/\s/_/g')

$ORT \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    download \
    --project-name "$SAFE_PROJECT_NAME" \
    --project-url "$VCS_URL" \
    --vcs-type "$VCS_TYPE" \
    --vcs-revision "$VCS_REVISION" \
    --vcs-path "$VCS_PATH" \
    -o $PROJECT_DIR
