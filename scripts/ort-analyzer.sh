#!/bin/bash -e

if [ "$VCS_TYPE" = "git" ]; then
    pushd $PROJECT_DIR
    if [ "$DISABLE_SHALLOW_CLONE" = "true" ]; then
        echo "Unshallowing the cloned project..."
        git fetch --unshallow
    else
        # Fetch tags for deepened commits
        tags_list=$(mktemp)
        refs_list=$(mktemp)
        git ls-remote --tags > $tags_list
        git log --pretty=format:"%H" > $refs_list
        grep -Ff $refs_list $tags_list | awk '{print $2}' | sed 's/\^{}//' | xargs -r -I tag git fetch origin "tag:tag"
        rm $refs_list $tags_list
    fi
    popd
fi

ORT_ANALYZER_OPTIONS="--package-curations-file $ORT_CONFIG_CURATIONS_FILE"

if [[ -n "$ORT_CONFIG_FILE" ]]; then
    ORT_ANALYZER_OPTIONS="$ORT_ANALYZER_OPTIONS --repository-configuration-file $CI_PROJECT_DIR/$ORT_CONFIG_FILE";
fi

if [[ "$ORT_ALLOW_DYNAMIC_VERSIONS" = "true" ]]; then
    ORT_OPTIONS="-P ort.analyzer.allowDynamicVersions=true"
fi

if [[ "$VCS_TYPE" = "git-repo" ]]; then
  ANALYZER_INPUT_DIR="$PROJECT_DIR"
else
  ANALYZER_INPUT_DIR="${PROJECT_DIR}${VCS_PATH:+/$VCS_PATH}"
fi

# Convert the LABELS variable with format "key1=val1, key1=val2" into separate ORT label options (-l).
[[ -z "$LABELS" ]] || LABEL_OPTIONS=$(${CI_PROJECT_DIR}/scripts/labels.sh)

echo "------------------------------------------"
echo "Running ORT analyzer..."
echo "------------------------------------------"

$ORT \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    $ORT_OPTIONS \
    analyze \
    $ORT_ANALYZER_OPTIONS \
    -i $ANALYZER_INPUT_DIR \
    -o $ORT_RESULTS_DIR \
    -f JSON \
    -l GITLAB_PIPELINE_URL="$CI_PIPELINE_URL" \
    -l SW_NAME="$SW_NAME" \
    -l SW_VERSION="$SW_VERSION" \
    -l VCS_TYPE="$VCS_TYPE" \
    -l VCS_URL="$VCS_URL" \
    -l VCS_REVISION="$VCS_REVISION" \
    -l VCS_PATH="$VCS_PATH" \
    -l LABELS="$LABELS" \
    -l ORT_CONFIG_FILE="$ORT_CONFIG_FILE" \
    -l ORT_CONFIG_REPO_SSH_URL="$ORT_CONFIG_REPO_SSH_URL" \
    -l ORT_CONFIG_REVISION="$ORT_CONFIG_REVISION" \
    -l ALLOW_DYNAMIC_VERSIONS="$ORT_ALLOW_DYNAMIC_VERSIONS" \
    -l DISABLE_SHALLOW_CLONE="$DISABLE_SHALLOW_CLONE" \
    -l ORT_LOG_LEVEL="$ORT_LOG_LEVEL" \
    -l ORT_VERSION="$ORT_VERSION" \
    -l UPSTREAM_BRANCH="$UPSTREAM_BRANCH" \
    -l UPSTREAM_PROJECT_PATH="$UPSTREAM_PROJECT_PATH" \
    -l UPSTREAM_PROJECT_TITLE="$UPSTREAM_PROJECT_TITLE" \
    -l UPSTREAM_PROJECT_ID="$UPSTREAM_PROJECT_ID" \
    -l UPSTREAM_USER_LOGIN="$UPSTREAM_USER_LOGIN" \
    -l UPSTREAM_PROJECT_URL="$UPSTREAM_PROJECT_URL" \
    -l UPSTREAM_MERGE_REQUEST_IID="$UPSTREAM_MERGE_REQUEST_IID" \
    -l UPSTREAM_PIPELINE_URL="$UPSTREAM_PIPELINE_URL" \
    -l CI_PIPELINE_URL="$CI_PIPELINE_URL" \
    -l CI_JOB_URL="$CI_JOB_URL"
    $LABEL_OPTIONS
