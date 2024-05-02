# GitLab Job Template for ORT

Run licensing, security and best practices checks and generate reports/SBOMs using [ORT][ort].

## Usage

See [.gitlab-ci.yml](.gitlab-ci.yml)

### Prerequisites

GitLab Commmunity or Enterprise Edition, version 15 or higher.

### Basic

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

Alternatively, you can also use ORT to scan any Git, Git-repo, Mercurial or Subversion project.

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'ssh://git@github.com:jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      when: manual
      allow_failure: true
    - if: '$CI_PIPELINE_SOURCE == "schedule"'
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

### Scenarios

- [Run ORT and analyze only specified package managers](#Run-ORT-and-analyze-only-specified-package-managers)
- [Run ORT with labels](#Run-ORT-with-labels)
- [Run ORT and fail job on policy violations or security issues](#Run-ORT-and-fail-job-on-policy-violations-or-security-issues)
- [Run ORT on private repositories](#Run-ORT-on-private-repositories)
- [Run ORT with a custom global configuration](#Run-ORT-with-a-custom-global-configuration)
- [Run ORT with a custom Docker image](#Run-ORT-with-a-custom-Docker-image)
- [Run ORT with PostgreSQL database](#Run-ORT-with-PostgreSQL-database)
- [Run only parts of the GitLab Job Template for ORT](#Run-only-parts-of-the-GitLab-Job-Template-for-ORT)

#### Run ORT and analyze only specified package managers

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'ssh://git@github.com:jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    ORT_CLI_ARGS: '-P ort.analyzer.enabledPackageManagers=NPM,Yarn,Yarn2 -P ort.forceOverwrite=true --stacktrace'
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

#### Run ORT with labels

Use labels to track scan related info or execute policy rules for specific product, delivery or organization.

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'ssh://git@github.com:jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    ORT_CLI_ANALYZE_ARGS: >
      -l project=oss-project
      -l dist=external
      -l org=engineering-sdk-xyz-team-germany-berlin
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

### Run ORT and fail job on policy violations or security issues

Set `FAIL_ON` to fail the pipeline if:
- policy violations reported by Evaluator exceed the `severeRuleViolationThreshold` level.
- security issues reported by the Advisor exceed the `severeIssueThreshold` level.

By default `severeRuleViolationThreshold` and `severeIssueThreshold` are set to `WARNING` 
but you can change this to for example `ERROR` in your [config.yml][ort-config-yml].

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'ssh://git@github.com:jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    FAIL_ON: 'violations'
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

#### Run ORT on private repositories

To run ORT on private Git repositories, we recommend to:
- Set up an account with read-only access rights
- Use [masked variables][gitlab-define-variable] for authentication secrets such as passwords or key values
- Use the `before_script` to generate the required authentication configuration files or set authentication tokens.

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

image: 'ubuntu:latest'

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'ssh://git@github.com:jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
  before_script:
    # Generate .netrc configuration file
    - echo "default login ${NETRC_LOGIN} password ${NETRC_PASSWORD}" > ${HOME}/.netrc
    # Add SSH private key and generate SSH configuration file
    # Based on https://gitlab.com/gitlab-examples/ssh-private-key
    - |
    - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
    - eval $(ssh-agent -s)
    - ssh-add <(echo "$SSH_PRIVATE_KEY" | base64 --decode)
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'ssh://git@github.com:jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    ORT_CONFIG_REPOSITORY: "https://oauth2:${EXAMPLE_ORG_AUTH_TOKEN}@git.example.com/ort-project/ort-config.git"
  before_script:
    # Set network proxy server environment variables 
    - |
      export https_proxy='http://proxy.example.com:3128/'
      export http_proxy='http://proxy.example.com:3128/'
      printenv >> vars.env
    # Use HTTPS with personal token instead of SSH for Git cloning
    - |
      git config --global url.'https://oauth2:${GITHUB_PERSONAL_TOKEN}@github.com/'.insteadOf 'ssh://git@github.com/'
      git config --global url.'https://oauth2:${EXAMPLE_ORG_AUTH_TOKEN}@git.example.com/'.insteadOf 'ssh://git@git.example.com/'
      git config --global url.'https://oauth2:${EXAMPLE_ORG_AUTH_TOKEN}@git.example.com/'.insteadOf 'https://git.example.com/'
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

### Run ORT with a custom global configuration

Use `ORT_CONFIG_REPOSITORY` to specify the location of your ORT global configuration repository.
If `ORT_CONFIG_REVISION` is not automatically latest state of configuration repository will be used.

Alternatively, you can also define your ORT global configuration files in `~/.ort/config` 
using `before_script` within the `ort-scan` job.

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort-scan
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'https://github.com/jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    ORT_CONFIG_REPOSITORY: 'https://github.com/oss-review-toolkit/ort-config.git'
    ORT_CONFIG_REVISION: 'e4ae8f0a2d0415e35d80df0f48dd95c90a992514'
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

### Run ORT with a custom Docker image

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  image: 'example.com/my-org/ort-container:latest'
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'https://github.com/jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

### Run ORT with PostgreSQL database

ORT supports using a PostgreSQL database to caching scan data to speed-up scans.

Set the following [masked variables][gitlab-define-variable] at project, group or instance level to specify the database to use:
- `POSTGRES_URL`: 'jdbc:postgresql://ort-db.example.com:5432/ort'
- `POSTGRES_USERNAME`: 'ort-db-username'
- `POSTGRES_PASSWORD`: 'ort-db-password'
- `POSTGRES_SCHEMA`: 'ort-prod'

Next, call GitLab Pipeline for ORT as shown below:

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'https://github.com/jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    DB_URL: "${POSTGRES_URL}"
    DB_SCHEMA: "${POSTGRES_SCHEMA}"
    DB_USERNAME: "${POSTGRES_USERNAME}"
    DB_USER: "${POSTGRES_PASSWORD}"
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

### Run only parts of the GitLab Job Template for ORT

```yaml
include:
  - https://raw.githubusercontent.com/oss-review-toolkit/ort-ci-gitlab/main/templates/ort-scan.yml

stages:
  - ort

ort-scan:
  stage: ort
  extends: .ort-scan
  variables:
    SW_NAME: 'Mime Types'
    SW_VERSION: '2.1.35'
    VCS_URL: 'https://github.com/jshttp/mime-types.git'
    VCS_REVISION: 'ef932231c20e716ec27ea159c082322c3c485b66'
    ALLOW_DYNAMIC_VERSIONS: 'true'
    RUN: >
      labels,
      analyzer,
      advisor,
      reporter
  before_script:
    # Use HTTPS instead of SSH for Git cloning
    - git config --global url.https://github.com/.insteadOf ssh://git@github.com/
  artifacts:
    when: always
    paths:
      - $ORT_RESULTS_PATH
```

# Want to Help or have Questions?

All contributions are welcome. If you are interested in contributing, please read our
[contributing guide][ort-contributing-md], and to get quick answers
to any of your questions we recommend you [join our Slack community][ort-slack].

# License

Copyright (C) 2020 [The ORT Project Authors](./NOTICE).

See the [LICENSE](./LICENSE) file in the root of this project for license details.

OSS Review Toolkit (ORT) is a [Linux Foundation project][lf] and part of [ACT][act].

[act]: https://automatecompliance.org/
[gitlab-define-variable]: https://docs.gitlab.com/ee/ci/variables/#define-a-cicd-variable-in-the-ui
[ort]: https://github.com/oss-review-toolkit/ort
[ort-config-yml]: https://github.com/oss-review-toolkit/ort/blob/main/model/src/main/resources/reference.yml
[ort-contributing-md]: https://github.com/oss-review-toolkit/.github/blob/main/CONTRIBUTING.md
[ort-slack]: http://slack.oss-review-toolkit.org
[lf]: https://www.linuxfoundation.org
