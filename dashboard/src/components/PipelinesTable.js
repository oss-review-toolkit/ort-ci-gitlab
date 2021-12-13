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

import {
    Descriptions,
    Table,
    Tooltip
} from 'antd';
import {
    AuditOutlined,
    CheckCircleOutlined,
    ChromeOutlined,
    ClockCircleOutlined,
    CloseCircleOutlined,
    CodeOutlined,
    DownloadOutlined,
    FileDoneOutlined,
    FileTextOutlined,
    IeOutlined,
    LoadingOutlined,
    TableOutlined
} from '@ant-design/icons';

const PipelinesTable = (props) => {
    console.log('PipelinesTable props', props);

    const {
        config,
        data,
        filteredInfo,
        loading,
        pagination,
        onChange,
        sortedInfo
    } = props;
    const {
        gitLabJobsUrl,
        gitLabPipelinesUrl,
        ortCycloneDxReportFile,
        ortEvaluatedModelReportFile,
        ortExcelReportFile,
        ortNoticeReportFile,
        ortReportFormats,
        ortScanResultsDownloadUrl,
        ortScanResultsPagesUrl,
        ortSpdxJsonReportFile,
        ortSpdxYamlReportFile,
        ortStaticHtmlReportFile,
        ortWebAppReportFile
    } = config;

    window.formats = ortReportFormats;

    const columns = [
        {
            title: 'Status',
            align: 'center',
            dataIndex: 'status',
            filters: (() => [
                {
                    text: (
                        <span>
                            <CloseCircleOutlined
                                className="ort-failed"
                            />
                            {' Failed'}
                        </span>
                    ),
                    value: 'failed'
                },
                {
                    text: (
                        <span>
                            <LoadingOutlined
                                className="ort-running"
                            />
                            {' Running'}
                        </span>
                    ),
                    value: 'running'
                },
                {
                    text: (
                        <span>
                            <CheckCircleOutlined
                                className="ort-success"
                            />
                            {' Success'}
                        </span>
                    ),
                    value: 'success'
                }
            ])(),
            filteredValue: filteredInfo.status || null,
            onFilter: (value, record) => record.status === value,
            key: 'status',
            render: (status) => (
                <span>
                    {
                        status === 'failed'
                        && (
                            <CloseCircleOutlined
                                className="ort-failed"
                            />
                        )
                    }
                    {
                        status === 'running'
                        && (
                            <LoadingOutlined
                                className="ort-running"
                            />
                        )
                    }
                    {
                        status === 'success'
                        && (
                            <CheckCircleOutlined
                                className="ort-success"
                            />
                        )
                    }
                </span>
            ),
            width: '2em'
        },
        {
            title: 'Scanned Project',
            dataIndex: 'scannedProject',
            key: 'scannedProject'
        },
        {
            title: 'Job',
            dataIndex: ['ortScanJob', 'id'],
            key: 'job',
            render: (job) => (
                <span>
                    {
                        renderAhref(
                            (
                                <span>
                                    <CodeOutlined />
                                    {` ${job}`}
                                </span>
                            ),
                            gitLabJobsUrl.replace(':id', job)
                        )
                    }
                </span>
            ),
            sorter: (a, b) => a.ortScanJob.id - b.ortScanJob.id,
            sortOrder: sortedInfo.field === 'job' && sortedInfo.order,
            width: '9em'
        },
        {
            title: 'Job Artifacts',
            dataIndex: ['ortScanJob', 'id'],
            key: 'job',
            render: (id) => (
                <span className="ort-scan-results">
                    {
                        ortReportFormats.has('WebApp')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="WebApp report"
                                >
                                    <ChromeOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortWebAppReportFile}`.replace(':id', id)
                        )
                    }
                    {
                        ortReportFormats.has('CycloneDx')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="CycloneDx report"
                                >
                                    <FileDoneOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortCycloneDxReportFile}`.replace(':id', id),
                            '_self'
                        )
                    }
                    {
                        ortReportFormats.has('EvaluatedModel')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="Evaluated Model (JSON)"
                                >
                                    <FileTextOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortEvaluatedModelReportFile}`.replace(':id', id)
                        )
                    }
                    {
                        ortReportFormats.has('Excel')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="Excel report"
                                >
                                    <TableOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortExcelReportFile}`.replace(':id', id),
                            '_self'
                        )
                    }
                    {
                        ortReportFormats.has('StaticHtml')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="Static HTML report"
                                >
                                    <IeOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortStaticHtmlReportFile}`.replace(':id', id)
                        )
                    }
                    {
                        ortReportFormats.has('Notice')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="Open Source Notices"
                                >
                                    <AuditOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortNoticeReportFile}`.replace(':id', id),
                            '_self'
                        )
                    }
                    {
                        ortReportFormats.has('SpdxJson')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="SPDX report (JSON)"
                                >
                                    <FileDoneOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortSpdxJsonReportFile}`.replace(':id', id)
                        )
                    }
                    {
                        ortReportFormats.has('SpdxYaml')
                        && renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="SPDX report (YAML)"
                                >
                                    <FileDoneOutlined />
                                </Tooltip>
                            ),
                            `${ortScanResultsPagesUrl}/${ortSpdxYamlReportFile}`.replace(':id', id),
                            '_self'
                        )
                    }
                    {
                        renderAhref(
                            (
                                <Tooltip
                                    placement="top"
                                    title="Download artifacts archive"
                                >
                                    <DownloadOutlined />
                                </Tooltip>
                            ),
                            ortScanResultsDownloadUrl.replace(':id', id),
                            '_self'
                        )
                    }
                </span>
            ),
            width: '10em'
        },
        {
            title: 'Duration',
            dataIndex: ['ortScanJob', 'duration'],
            key: 'duration',
            render: (duration, record) => (
                <span>
                    <ClockCircleOutlined />
                    {' '}
                    {record.ortScanJob.durationInHHMMSS}
                </span>
            ),
            sorter: (a, b) => ~~a.ortScanJob.duration - ~~b.ortScanJob.duration,
            sortOrder: Array.isArray(sortedInfo.field)
                && sortedInfo.field[0] === 'ortScanJob'
                && sortedInfo.field[1] === 'duration'
                && sortedInfo.order,
            width: '9em'
        },
        {
            title: 'Pipeline',
            dataIndex: ['id'],
            defaultSortOrder: 'ascend',
            key: 'id',
            render: (id) => (
                <span>
                    {
                        renderAhref(
                            <span>
                                <CodeOutlined />
                                {` ${id}`}
                            </span>,
                            gitLabPipelinesUrl.replace(':id', id)
                        )
                    }
                </span>
            ),
            responsive: ['md'],
            sorter: (a, b) => a.id - b.id,
            sortOrder: sortedInfo.field === 'id' && sortedInfo.order,
            width: '9em'
        },
    ];

    const renderAhref = (element, href, target = '_blank') => (
        <a
            children={element}
            href={href}
            rel="noopener noreferrer"
            target={target}
        >
        </a>
    );

    return (
        <Table
            columns={columns}
            dataSource={data}
            expandedRowRender={
                (pipeline) => (
                    <Descriptions
                        bordered
                        column={1}
                        className="ort-scan-params"
                        size="small"
                    >
                        {
                            Object.entries(pipeline.variables).map(([key, value]) => (
                                <Descriptions.Item
                                    key={`ort-scan-param-${key}`}
                                    label={key}
                                >
                                    {
                                        value.startsWith('http') || value.startsWith('ssh')
                                            ? (
                                                <a
                                                    href={
                                                        value.startsWith('ssh')
                                                        ? value
                                                            .replace('ssh://git@', 'https://')
                                                            .replace(':3389', '')
                                                        : value
                                                    }
                                                    rel="noopener noreferrer"
                                                    target="_blank"
                                                >
                                                    {value}
                                                </a>
                                            )
                                            : value
                                    }
                                </Descriptions.Item>
                            ))
                        }
                    </Descriptions>
                )
            }
            locale={{
                emptyText: 'No pipeline information'
            }}
            pagination={pagination}
            loading={loading}
            rowKey={record => record.id}
            onChange={onChange}
            size="small"
        />
    );
};

export default PipelinesTable;