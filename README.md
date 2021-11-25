# ORT for GitLab

This repository holds the scripts needed to run [OSS Review Toolkit][ort] (ORT) inside a [GitLab pipeline][gitlab-pipelines].

## Installation

### Prerequisites

Before you can use ORT for GitLab or its `ort-scan` job, you first need to:

1. [Mirror][gitlab-mirror] this repository and the [ORT configuration repository][ort-configuration-repo] in your GitLab account
2. Build your own version of the ORT Docker image:
  * In your mirror of this repository navigate to *CI/CD > Pipelines*
  * Click the *Run pipeline* button
  * Find and set `REBUILD_DOCKER_IMAGE` to 'true'
  * Click the *Run pipeline* button
  * Wait until `ort-build-image` completes successfully
3. Generate `ORT_TRIGGER_API_TOKEN`,  `ORT_READ_API_TOKEN` and `ORT_MR_API_TOKEN` access tokens to use ORT for GitLab in your project(s) pipelines:
  * Create a [personal access token][gitlab-personal-access-tokens] token named `ORT_READ_API_TOKEN`, set role to 'developer' and enable scope 'read_api'
  * Create a [personal access token][gitlab-personal-access-tokens] token named `ORT_MR_API_TOKEN`, set role to 'developer' and enable scope 'api'
  * Create a new [trigger token][gitlab-trigger-token] named `ORT_TRIGGER_API_TOKEN`
  * Store the tokens somewhere safe
  * Add `ORT_TRIGGER_API_TOKEN` and `ORT_READ_API_TOKEN` as masked [variables][gitlab-variables] to the projects to be scanned or their parent group
  * In your mirror of this repository, navigate to *Settings > CI/CD* and expand [Variables][gitlab-variables]:
    * Add as a masked variable `ORT_MR_API_TOKEN` 
    * Add `ORT_MR_USERNAME` with as value the name user/bot for the author of scan results comment in a merge request

## Getting started

ORT for GitLab or `ort-scan` job can be used in two ways:

1. Run it manually via *CI/CD > Pipelines* page, or
2. Include the job in your project's `.gitlab-ci.yml` and run it during a merge request or scheduled pipeline

### Run ORT scan manually

1. In your mirror of this repository, navigate to the *CI/CD > Pipelines* page
2. Click the *Run pipeline* button
3. In the pipeline variables form, fill in at least the following required fields:
   - `SW_NAME`: Name of project, product or component to be scanned
   - `SW_VERSION`: Project version number or release name (use the version from package metadata, not VCS revision)
   - `VCS_TYPE`: Identifier of the project version control system (`git`, `git-repo`, `mercurial` or `subversion`)
   - `VCS_URL`: VCS URL (clone URL) of project to scan
   - `VCS_REVISION`: SHA1 or tag to scan (not branch names, because they can move)
4. Click the *Run pipeline* button

#### Example

Assuming that you want to scan version 2.1.27 of the [mime-types][mime-types] project, use the following values in step 3 above:

- `SW_NAME`: "Mime Types"
- `SW_VERSION`: 2.1.27
- `VCS_TYPE`: git
- `VCS_URL`: https://github.com/jshttp/mime-types.git
- `VCS_REVISION`: 47b62ac45e9b176a2af35532d0eea4968bb9eb6d
- `ORT_ALLOW_DYNAMIC_VERSIONS`: true

Note:

To scan GitHub projects using their SSH clone URL, you need to base64-encode the required SSH private keys and add the resulting strings as masked [variables][gitlab-variables] to your [mirror][gitlab-mirror] of this repository. See [setup-ssh.sh](./scripts/setup-ssh.sh) for the `SSH_KEY` variable names.

### Include ORT scan in a project's pipeline
1. Import the ORT for GitLab file via an [include][gitlab-include] and then add the `ort-scan` to one of the [stages][gitlab-stages] in your `.gitlab-ci.yml` file.

```
include:
  - project: oss-review-toolkit/ort-gitlab-ci
    file: ort-gitlab-ci.yml

stages:
  - ort-scan
```

2. Add `ort-scan` as a [job][gitlab-job] to a project `.gitlab-ci.yml` and [choose when to run it][gitlab-job-control].

#### Example

```
ort-scan:
  stage: ort-scan
  retry: 2
  variables:
    SW_NAME: "Mime Types"
    SW_VERSION: "2.1.27"
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: manual
      allow_failure: true
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
```

3. Optionally, you can define the following [ort-scan variables][gitlab-variables]:

- `DISABLE_SHALLOW_CLONE`: If set to 'true', the full history of the project is cloned. This option works only if VCS_TYPE is 'git'
- `ORT_ALLOW_DYNAMIC_VERSIONS`: Enable only if dynamic dependency versions are allowed (note that version ranges specified for dependencies may cause unstable results). This field applies only to package managers that support lock files, e.g. NPM. Disabled by default. Set to 'true' to enable
- `ORT_CONFIG_FILE`: Path to the repository configuration file relative to the VCS root. If empty, '.ort.yml' is used as default
- `ORT_DISABLE_EVALUATOR`: If set to 'true', ORT's evaluator will not run (no policy checks)
- `ORT_DISABLE_SCANNER`: If set to 'true', ORT's scanner will not run (no copyright holders and licenses scan)
- `OSS_RETRY`: The maximum number of downstream `ort-scan` job status checks. The default value is 180. Together with OSS_RETRY_DELAY, this parameter determines the OSS pipeline timeout as OSS_RETRY X OSS_RETRY_DELAY (30 minutes if we use the default values)
- `OSS_RETRY_DELAY`: Time to wait (in seconds) between consecutive downstream job status checks. The default value is 10. Together with OSS_RETRY, this parameter determines the OSS pipeline timeout as OSS_RETRY X OSS_RETRY_DELAY (30 minutes if we use the default values)
- `NOTICE_FILE`: Path to open source attribution document relative to the VCS root. If empty 'FOSS_NOTICE' is used as default.
- `SW_NAME`: Name of project, product or component to be scanned. By default the name of the repository is used as shown in its clone URL.
- `SW_VERSION`: Project version number or release name (use the version from package metadata, not VCS revision). By default, the Git short SHA is used
- `VCS_URL`: VCS URL (clone URL) of the project to scan, use only when URL is not correctly detected

# License

Copyright (C) 2020-2021 HERE Europe B.V.

See the [LICENSE](./LICENSE) file in the root of this project for license details.

OSS Review Toolkit (ORT) is a [Linux Foundation project](https://www.linuxfoundation.org) and part of [ACT](https://automatecompliance.org/).

[gitlab-include]: https://docs.gitlab.com/ee/ci/yaml/#include
[gitlab-job]: https://docs.gitlab.com/ee/ci/jobs
[gitlab-job-control]: https://docs.gitlab.com/ee/ci/jobs/job_control.html
[gitlab-mirror]: https://docs.gitlab.com/ee/user/project/repository/mirror
[gitlab-personal-access-tokens]: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
[gitlab-pipelines]: https://docs.gitlab.com/ee/ci/pipelines/
[gitlab-project-access-tokens]: https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#creating-a-project-access-token
[gitlab-stages]: https://docs.gitlab.com/ee/ci/yaml/#stages
[gitlab-trigger-token]: https://docs.gitlab.com/ee/ci/triggers/#adding-a-new-trigger
[gitlab-variables]: https://docs.gitlab.com/ee/ci/variables/#create-a-custom-variable-in-the-ui
[mime-types]: https://github.com/jshttp/mime-types.git
[ort]: https://github.com/oss-review-toolkit/ort
[ort-configuration-repo]: https://gitlab.com/tsteenbe/ort-configuration
