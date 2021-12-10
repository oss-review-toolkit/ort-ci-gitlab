#!/bin/bash -e

# Prints data used to create metadata.json which can be used to reproduce the scan
# or perform more easily audits over multiple scan runs.

jq -n \
  --arg sw_name "$SW_NAME" \
  --arg sw_version "$SW_VERSION" \
  --arg vcs_type "$VCS_TYPE" \
  --arg vcs_url "$VCS_URL" \
  --arg vcs_revision "$VCS_REVISION" \
  --arg vcs_path "$VCS_PATH" \
  --arg gitlab_project_id "$GITLAB_PROJECT_ID" \
  --arg ort_config_file "$ORT_CONFIG_FILE" \
  --arg ort_config_ssh_url "$ORT_CONFIG_REPO_SSH_URL" \
  --arg ort_config_revision "$ORT_CONFIG_REVISION" \
  --arg ort_allow_dynamic_versions "$ORT_ALLOW_DYNAMIC_VERSIONS" \
  --arg notice_file "$NOTICE_FILE" \
  --arg notice_files_differ "$NOTICE_FILES_DIFFER" \
  --arg disable_shallow_clone "$DISABLE_SHALLOW_CLONE" \
  --arg ort_use_dev_db "$ORT_USE_DEV_DB" \
  --arg ort_log_level "$ORT_LOG_LEVEL" \
  --arg ort_revision "$ORT_REVISION" \
  --arg ort_version "$ORT_VERSION" \
  --arg rebuild_docker_image "$REBUILD_DOCKER_IMAGE" \
  --arg upstream_branch "$UPSTREAM_BRANCH" \
  --arg upstream_project_id "$UPSTREAM_PROJECT_ID" \
  --arg upstream_project_path "$UPSTREAM_PROJECT_PATH" \
  --arg upstream_project_title "$UPSTREAM_PROJECT_TITLE" \
  --arg upstream_project_url "$UPSTREAM_PROJECT_URL" \
  --arg upstream_project_repository_languages "$UPSTREAM_PROJECT_REPOSITORY_LANGUAGES" \
  --arg upstream_user_login "$UPSTREAM_USER_LOGIN" \
  --arg upstream_merge_request_iid "$UPSTREAM_MERGE_REQUEST_IID" \
  --arg upstream_pipeline_url "$UPSTREAM_PIPELINE_URL" \
  --arg pipeline_url "$CI_PIPELINE_URL" \
  --arg ci_job_url "$CI_JOB_URL" \
  --arg labels "$LABELS" \
  --argjson stats "${STATS:-null}" \
  --arg analyzer_status "${ANALYZER_STATUS:-not_run}" \
  --arg analyzer_start_time "$ANALYZER_START_TIME" \
  --arg analyzer_end_time "$ANALYZER_END_TIME" \
  --arg scanner_status "${SCANNER_STATUS:-not_run}" \
  --arg scanner_start_time "$SCANNER_START_TIME" \
  --arg scanner_end_time "$SCANNER_END_TIME" \
  --arg advisor_status "${ADVISOR_STATUS:-not_run}" \
  --arg advisor_start_time "$ADVISOR_START_TIME" \
  --arg advisor_end_time "$ADVISOR_END_TIME" \
  --arg evaluator_status "${EVALUATOR_STATUS:-not_run}" \
  --arg evaluator_start_time "$EVALUATOR_START_TIME" \
  --arg evaluator_end_time "$EVALUATOR_END_TIME" \
  --arg reporter_status "${REPORTER_STATUS:-not_run}" \
  --arg reporter_start_time "$REPORTER_START_TIME" \
  --arg reporter_end_time "$REPORTER_END_TIME" \
  --arg result "$CI_JOB_STATUS" \
  --arg package_manager "$ORT_PACKAGE_MANAGER" \
  --arg start_time "$JOB_STARTED_AT" \
  --arg end_time "$JOB_FINISHED_AT" \
   '{ 
      "@version": "0.1.0",
      variables: {
        SW_NAME: $sw_name,
        SW_VERSION: $sw_version,
        VCS_TYPE: $vcs_type,
        VCS_URL: $vcs_url,
        VCS_REVISION: $vcs_revision,
        VCS_PATH: $vcs_path,
        GITLAB_PROJECT_ID: $gitlab_project_id,
        ORT_CONFIG_FILE: $ort_config_file,
        ORT_CONFIG_REPO_SSH_URL: $ort_config_ssh_url,
        ORT_CONFIG_REVISION: $ort_config_revision,
        ORT_ALLOW_DYNAMIC_VERSIONS: $ort_allow_dynamic_versions,
        DISABLE_SHALLOW_CLONE: $disable_shallow_clone,
        NOTICE_FILE: $notice_file,
        NOTICE_FILES_DIFFER: $notice_files_differ,
        ORT_USE_DEV_DB: $ort_use_dev_db,
        ORT_LOG_LEVEL: $ort_log_level,
        ORT_REVISION: $ort_revision,
        ORT_VERSION: $ort_version,
        UPSTREAM_BRANCH: $upstream_branch,
        UPSTREAM_PROJECT_PATH: $upstream_project_path,
        UPSTREAM_PROJECT_ID: $upstream_project_id,
        UPSTREAM_PROJECT_TITLE: $upstream_project_title,
        UPSTREAM_PROJECT_REPOSITORY_LANGUAGES: $upstream_project_repository_languages,
        UPSTREAM_PROJECT_URL: $upstream_project_url,
        UPSTREAM_USER_LOGIN: $upstream_user_login,
        UPSTREAM_MERGE_REQUEST_IID: $upstream_merge_request_iid,
        UPSTREAM_PIPELINE_URL: $upstream_pipeline_url,
        PIPELINE_URL: $pipeline_url,
        CI_JOB_URL: $ci_job_url,
        LABELS: $labels,
        PACKAGE_MANAGER: $package_manager,
        REBUILD_DOCKER_IMAGE: $rebuild_docker_image
      },
      stats: {
        $stats,
        analyzer: {
          status: $analyzer_status,
          start_time: $analyzer_start_time,
          end_time: $analyzer_end_time
        },
        scanner: {
          status: $scanner_status,
          start_time: $scanner_start_time,
          end_time: $scanner_end_time
        },
        advisor: {
          status: $advisor_status,
          start_time: $advisor_start_time,
          end_time: $advisor_end_time
        },
        evaluator: {
          status: $evaluator_status,
          start_time: $evaluator_start_time,
          end_time: $evaluator_end_time
        },
        reporter: {
          status: $reporter_status,
          start_time: $reporter_start_time,
          end_time: $reporter_end_time
        }
      },
      status: $result,
      start_time: $start_time,
      end_time: $end_time
    }'
