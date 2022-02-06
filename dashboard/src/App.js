/*
 * Copyright (C) 2021-2022 HERE Europe B.V.
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

import './App.css';
import {
    Col,
    Row,
    Tabs
} from 'antd';
import React from 'react';
import {
    FileSearchOutlined,
    ScanOutlined
} from '@ant-design/icons';
import {
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
} from './environmentVars';
import PipelinesTable from './components/PipelinesTable';
import TriggerNewScanForm from './components/TriggerNewScanForm';

const { TabPane } = Tabs;

class App extends React.Component { 
    constructor(props) {
        super(props);

        this.state = {
            config: {
                gitLabJobsUrl: ORT_PIPELINE_JOBS_URL,
                gitLabJobsApiUrl: ORT_PIPELINE_JOBS_API_URL,
                gitLabPipelinesUrl: ORT_PIPELINES_URL,
                gitLabPipelinesApiUrl: ORT_PIPELINES_API_URL,
                gitlabScanJobName: ORT_SCAN_JOB_NAME,
                ortScanResultsUrl: ORT_SCAN_RESULTS_URL,
                ortScanResultsDownloadUrl: ORT_SCAN_RESULTS_DOWNLOAD_URL,
                ortScanResultsPagesUrl: ORT_SCAN_RESULTS_PAGES_URL,
                ortCycloneDxReportFile: ORT_CYCLONE_DX_REPORT_FILE,
                ortEvaluatedModelReportFile: ORT_EVALUATED_MODEL_REPORT_FILE,
                ortExcelReportFile: ORT_EXCEL_REPORT_FILE,
                ortNoticeReportFile: ORT_NOTICE_REPORT_FILE,
                ortReportFormats: new Set(ORT_REPORT_FORMATS.replace(/ /g, '').split(',')),
                ortSpdxJsonReportFile: ORT_SPDX_JSON_REPORT_FILE,
                ortSpdxYamlReportFile: ORT_SPDX_YAML_REPORT_FILE,
                ortStaticHtmlReportFile: ORT_STATIC_HTML_REPORT_FILE,
                ortWebAppReportFile: ORT_WEBAPP_REPORT_FILE
            },
            data: {
                pipelinesMap: new Map()
            },
            pipelinesTable: {
                filteredInfo: {},
                pagination: {
                    current: 1,
                    defaultPageSize: 20,
                    pageSize: 20,
                    pageSizeOptions: ['20', '40', '60', '100'],
                    position: ['topRight', 'bottomRight'],
                    showSizeChanger: true
                },
                loading: false,
                sortedInfo: {}
            },
            tabs: {
                activeKey: 'ort-scan-jobs' //'ort-trigger-new-scan'
            },
            triggerNewScanForm: {

            }
        }
    };

    componentDidMount() {
        const {
            pipelinesTable: {
                pagination
            }
        } = this.state;
        this.fetchPipelinesData(pagination);
    }

    fetchPipelinesData = (pagination) => {
        this.setState(
            { 
                ...this.state,
                pipelinesTable: {
                    ...this.state.pipelinesTable,
                    loading: true,
                    pagination
                }
            }
        );

        fetch(`${ORT_PIPELINES_API_URL}?per_page=${pagination.pageSize}&page=${pagination.current}&source=trigger`, {
            method: 'GET',
            cache: 'no-cache',
            headers: {
                'Content-Type': 'application/json',
                'PRIVATE-TOKEN': ORT_READ_API_TOKEN
            }
        })
        .then((response) => {
            if (response.ok) {
                const total = ~~response.headers.get('X-Total');
                const totalPages = ~~response.headers.get('X-Total-Pages');

                this.setState(
                    { 
                        ...this.state,
                        pipelinesTable: {
                            ...this.state.pipelinesTable,
                            loading: true,
                            pagination: {
                                ...this.state.pipelinesTable.pagination,
                                total,
                                totalPages
                            }
                        }
                    }
                );

                return response.json();
            }

            return Promise.reject(response);
        })
        .then((pipelines) => {
            const fetches = [];
            
            pipelines.forEach(pipeline => {
                const { id } = pipeline;

                fetches.push(
                    fetch(
                        ORT_PIPELINE_JOBS_API_URL.replace(':id', id), 
                        {
                            method: 'GET',
                            cache: 'no-cache',
                            headers: {
                                'Content-Type': 'application/json',
                                'PRIVATE-TOKEN': ORT_READ_API_TOKEN
                            }
                        }
                    )
                );

                fetches.push(
                    fetch(
                        ORT_PIPELINE_VARS_API_URL.replace(':id', id), 
                        {
                            method: 'GET',
                            headers: {
                                'Content-Type': 'application/json',
                                'PRIVATE-TOKEN': ORT_READ_API_TOKEN
                            }
                        }
                    )
                );
            });

            Promise.all(fetches)
            .then((pipelineJobsAndVarsResults) => Promise.all(pipelineJobsAndVarsResults.map(r => r.json())))
            .then((pipelineJobsAndVarsResults) => {
                const jobs = [];
                const vars = [];

                pipelineJobsAndVarsResults.forEach((element, index) => {
                    if (index % 2 === 0) {
                        jobs.push(pipelineJobsAndVarsResults[index]);
                    } else {
                        vars.push(pipelineJobsAndVarsResults[index]);
                    }
                });

                return pipelines.reduce(
                    (acc, pipeline, index) => {
                        let ortScanJob = {};
                        let variables = {};

                        if (Array.isArray(jobs[index])) {
                            ortScanJob = jobs[index].reduce(
                                (acc, job) => {
                                    if (job.name && job.name === ORT_SCAN_JOB_NAME) {
                                        acc = { ...job };
                                    }
                                    return acc;
                                },
                                {}
                            );

                            if (ortScanJob.duration) {
                                ortScanJob.durationInHHMMSS = new Date(ortScanJob.duration * 1000).toISOString().substr(11, 8);
                            }
                        }

                        if (Array.isArray(vars[index])) {
                            variables = vars[index].reduce(
                                (acc, envVar) => {
                                    if (envVar.variable_type === 'env_var') {
                                        acc[envVar.key] = envVar.value;   
                                    }

                                    return acc;
                                },
                                {}
                            );
                        }

                        // Only add pipelines for which data is available
                        if (Object.entries(ortScanJob).length !== 0 && Object.entries(variables).length !== 0) {
                            acc.push({
                                ...pipeline,
                                ortScanJob,
                                scannedProject: variables.SW_NAME || variables.UPSTREAM_PROJECT_TITLE,
                                variables 
                            });
                        }

                        return acc;
                    },
                    []
                );
            }).then((pipelines) => {
                const tmp = pipelines.reduce(
                    (acc, pipeline) => {
                        const { id } = pipeline;
                        acc.set(id, pipeline);

                        return acc;
                    },
                    new Map()
                );

                const pipelinesMap = new Map(
                    [
                        ...this.state.data.pipelinesMap
                    ].concat([...tmp]));

                this.setState(
                    { 
                        ...this.state,
                        data: {
                            pipelinesMap 
                        },
                        pipelinesTable: {
                            ...this.state.pipelinesTable,
                            loading: false,
                            pagination: {
                                ...this.state.pipelinesTable.pagination,
                                pageSize: pipelinesMap.size
                            }
                        }
                    }
                );
            });
        })
    };

    handleNewScanSubmit = (values) => {
        console.log('values', values);
    };

    handleNewScanSubmitFailed = (values) => {
        console.log('failed values', values);
    };

    handlePipelineTableChange = (pagination, filters, sorter) => {
        console.log('handlePipelineTableChange', pagination, filters, sorter);
        if (pagination
            && (
                pagination.current !== this.state.pipelinesTable.pagination.current
                || pagination.pageSize !== this.state.pipelinesTable.pagination.pageSize
            )
        ) {
            this.fetchPipelinesData(pagination);
        } else {
            this.setState(
                { 
                    ...this.state,
                    pipelinesTable: {
                        ...this.state.pipelinesTable,
                        filteredInfo: filters,
                        sortedInfo: sorter
                    }
                }
            );
        }
    };

    handleTabsChange = (activeKey) => {
        this.setState(
            { 
                ...this.state,
                tabs: {
                    activeKey
                }
            }
        );
    };

    render() {
        const {
            config,
            data,
            pipelinesTable: {
                filteredInfo,
                pagination,
                loading,
                sortedInfo
            },
            tabs: {
                activeKey
            }
        } = this.state;

        return (
            <Row className="ort-app">
                <Col span={24}>
                    <Tabs
                        activeKey={activeKey}
                        animated="false"
                        onChange={this.handleTabsChange}
                    >
                        <TabPane
                            tab={(
                                <span>
                                    <FileSearchOutlined />
                                    Scans
                                </span>
                            )}
                            key="ort-scan-jobs"
                        >
                            <PipelinesTable
                                config={config}
                                data={Array.from(data.pipelinesMap.values())}
                                filteredInfo={filteredInfo}
                                loading={loading}
                                onChange={this.handlePipelineTableChange}
                                pagination={pagination}
                                sortedInfo={sortedInfo}
                            />
                        </TabPane>
                        <TabPane
                            tab={(
                                <span>
                                    <ScanOutlined />
                                    New Scan
                                </span>
                            )}
                            key="ort-trigger-new-scan"
                        >
                            <TriggerNewScanForm
                                onSubmit={this.handleNewScanSubmit}
                                onSubmitFailed={this.handleNewScanSubmitFailed}
                            />
                        </TabPane>
                    </Tabs>
                </Col>
            </Row>
        );
    };
}

export default App;
