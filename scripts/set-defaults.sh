# Check variables below and fix their value to default one if they aren't set or their value is empty string. 

export REBUILD_DOCKER_IMAGE=${REBUILD_DOCKER_IMAGE:-"false"}
export ORT_ALLOW_DYNAMIC_VERSIONS=${ORT_ALLOW_DYNAMIC_VERSIONS:-"false"}
export DISABLE_SHALLOW_CLONE=${DISABLE_SHALLOW_CLONE:-"false"}
export FAIL_ON_OUTDATED_NOTICE_FILE=${FAIL_ON_OUTDATED_NOTICE_FILE:-"false"}
export ORT_CONFIG_REVISION=${ORT_CONFIG_REVISION:-"main"}
export ORT_CONFIG_REPO_URL=${ORT_CONFIG_REPO_URL:-"https://github.com/oss-review-toolkit/ort-config.git"}
export ORT_DISABLE_ADVISOR=${ORT_DISABLE_ADVISOR:-"false"}
export ORT_DISABLE_EVALUATOR=${ORT_DISABLE_EVALUATOR:-"false"}
export ORT_DISABLE_SCANNER=${ORT_DISABLE_SCANNER:-"true"}
export ORT_LOG_LEVEL=${ORT_LOG_LEVEL:-"info"}
export ORT_USE_DEV_DB=${ORT_USE_DEV_DB:-"false"}
export NOTICE_FILE=${NOTICE_FILE:-"FOSS_NOTICE"}
export SW_NAME=${SW_NAME:-"$UPSTREAM_PROJECT_TITLE"}
export SW_VERSION=${SW_VERSION:-"${VCS_REVISION:0:7}"}
export VCS_URL=${VCS_URL:-"ssh://git@${CI_SERVER_HOST}/${UPSTREAM_PROJECT_PATH}"}
export VCS_REVISION=${VCS_REVISION:-"$UPSTREAM_COMMIT_SHA"}

# Save variable values in vars.env so we can use them in after_script.
echo "export VCS_URL='$VCS_URL'" >> vars.env
echo "export VCS_REVISION='$VCS_REVISION'" >> vars.env
echo "export SW_NAME='$SW_NAME'" >> vars.env
echo "export SW_VERSION='$SW_VERSION'" >> vars.env
echo "export ORT_ALLOW_DYNAMIC_VERSIONS='$ORT_ALLOW_DYNAMIC_VERSIONS'" >> vars.env
echo "export ORT_CONFIG_REPO_URL='$ORT_CONFIG_REPO_URL'" >> vars.env
echo "export ORT_DISABLE_ADVISOR='$ORT_DISABLE_ADVISOR'" >> vars.env
echo "export ORT_DISABLE_EVALUATOR='$ORT_DISABLE_EVALUATOR'" >> vars.env
echo "export ORT_DISABLE_SCANNER='$ORT_DISABLE_SCANNER'" >> vars.env
