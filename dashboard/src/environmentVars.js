/*
 * Copyright (C) 2021 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

/*
 * This file specifies environment variables
 * At a minimum the following are required to be defined in a .env file or as system variables.
 * CI_API_V4_URL=https://gitlab.example.com/api/v4
 * CI_PAGES_DOMAIN=https://pages.gitlab.example.com
 * ORT_READ_API_TOKEN=ReplaceWithYourToken
 * ORT_TRIGGER_API_TOKEN=ReplaceWithYourToken
 * ORT_GITLAB_CI_PROJECT_ID=ReplaceWithYourGroupIdForOrtGitLabRepository
 * ORT_GITLAB_CI_PROJECT_URL=https://gitlab.example.com/oss-review-toolkit/ort-gitlab-ci
 * ORT_NOTICE_REPORT_FILE=EXAMPLE_ORG_NOTICE
 * ORT_SCAN_RESULTS_DOWNLOAD_URL=https://gitlab.example.com/oss-review-toolkit/ort-gitlab-ci/-/jobs/:id/artifacts/download
 * ORT_SCAN_RESULTS_PAGES_URL=https://pages.gitlab.example.com/-/oss-review-toolkit/ort-gitlab-ci/-/jobs/:id/artifacts/ort-results
*/

const CI_API_V4_URL = process.env.CI_API_V4_URL
const ORT_GITLAB_CI_PROJECT_ID = process.env.ORT_GITLAB_CI_PROJECT_ID;
const ORT_GITLAB_CI_PROJECT_URL = process.env.ORT_GITLAB_CI_PROJECT_URL;
const ORT_PIPELINE_JOBS_URL = process.env.ORT_PIPELINE_JOBS_URL
    || `${ORT_GITLAB_CI_PROJECT_URL}/-/jobs/:id`;
const ORT_PIPELINE_JOBS_API_URL = process.env.ORT_PIPELINE_JOBS_API_URL
    || `${CI_API_V4_URL}/projects/${ORT_GITLAB_CI_PROJECT_ID}/pipelines/:id/jobs`;
const ORT_PIPELINES_URL = process.env.ORT_PIPELINES_URL
    || `${ORT_GITLAB_CI_PROJECT_URL}/-/pipelines/:id`;
const ORT_PIPELINES_API_URL = process.env.ORT_PIPELINES_API_URL
    || `${CI_API_V4_URL}/projects/${ORT_GITLAB_CI_PROJECT_ID}/pipelines`;
const ORT_PIPELINE_VARS_API_URL = process.env.ORT_PIPELINE_VARS_API_URL
    || `${CI_API_V4_URL}/projects/${ORT_GITLAB_CI_PROJECT_ID}/pipelines/:id/variables`;
const ORT_READ_API_TOKEN = process.env.ORT_READ_API_TOKEN
const ORT_SCAN_JOB_NAME = process.env.ORT_SCAN_JOB_NAME || 'ort-scan';
const ORT_SCAN_RESULTS_URL = process.env.ORT_SCAN_RESULTS_URL
    || `${ORT_GITLAB_CI_PROJECT_URL}/-/jobs/:id/artifacts/browse/ort-results`;
const ORT_SCAN_RESULTS_DOWNLOAD_URL = process.env.ORT_SCAN_RESULTS_DOWNLOAD_URL
    || `${ORT_GITLAB_CI_PROJECT_URL}/-/jobs/:id/artifacts/download`;
const ORT_SCAN_RESULTS_PAGES_URL = process.env.ORT_SCAN_RESULTS_PAGES_URL;

const ORT_CYCLONE_DX_REPORT_FILE = process.env.ORT_CYCLONE_DX_REPORT_FILE || 'cyclone-dx-report.xml';
const ORT_EVALUATED_MODEL_REPORT_FILE = process.env.ORT_EVALUATED_MODEL_REPORT_FILE || 'evaluated-model.json';
const ORT_EXCEL_REPORT_FILE = process.env.ORT_EXCEL_REPORT_FILE || 'scan-report.xlsx';
const ORT_NOTICE_REPORT_FILE = process.env.ORT_NOTICE_REPORT_FILE || 'ORT_NOTICE';
const ORT_SPDX_JSON_REPORT_FILE = process.env.ORT_SPDX_JSON_REPORT_FILE || 'scan-report.spdx.json';
const ORT_SPDX_YAML_REPORT_FILE = process.env.ORT_SPDX_YAML_REPORT_FILE || 'scan-report.spdx.yml';
const ORT_STATIC_HTML_REPORT_FILE = process.env.ORT_STATIC_HTML_REPORT_FILE || 'scan-report.html';
const ORT_WEBAPP_REPORT_FILE = process.env.ORT_WEBAPP_REPORT_FILE || 'scan-report-web-app.html';

// Report formats to show in Job Artifacts column
// Options: CycloneDx, EvaluatedModel, Excel, Notice, StaticHtml, SpdxJson, SpdxYaml or WebApp
const ORT_REPORT_FORMATS = process.env.ORT_REPORT_FORMATS || 'Notice, StaticHtml, WebApp';

export {
    ORT_CYCLONE_DX_REPORT_FILE,
    ORT_EVALUATED_MODEL_REPORT_FILE,
    ORT_EXCEL_REPORT_FILE,
    ORT_NOTICE_REPORT_FILE,
    ORT_PIPELINE_JOBS_URL,
    ORT_PIPELINE_JOBS_API_URL,
    ORT_PIPELINES_URL,
    ORT_PIPELINES_API_URL,
    ORT_PIPELINE_VARS_API_URL,
    ORT_READ_API_TOKEN,
    ORT_REPORT_FORMATS,
    ORT_SCAN_JOB_NAME,
    ORT_SCAN_RESULTS_URL,
    ORT_SCAN_RESULTS_DOWNLOAD_URL,
    ORT_SCAN_RESULTS_PAGES_URL,
    ORT_SPDX_JSON_REPORT_FILE,
    ORT_SPDX_YAML_REPORT_FILE,
    ORT_STATIC_HTML_REPORT_FILE,
    ORT_WEBAPP_REPORT_FILE
};