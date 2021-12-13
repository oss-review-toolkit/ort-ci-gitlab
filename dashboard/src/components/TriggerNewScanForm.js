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
    Button,
    Form,
    Input,
    Select
} from 'antd';

const { Option } = Select;

const TriggerNewScanForm = (props) => {
    console.log('TriggerNewScanForm props', props);

    const {
        onSubmit,
        onSubmitFailed
    } = props;

    return (
        <Form
            autoComplete="off"
            initialValues={{ remember: true }}
            labelCol={{ span: 6 }}
            name="ort-trigger-new-scan"
            onFinish={onSubmit}
            onFinishFailed={onSubmitFailed}
            size="small"
            wrapperCol={{ span: 12 }}
        >
            <Form.Item
                extra="Name of project, product or component to be scanned."
                label="Software Name"
                name="swName"
                rules={[
                    {
                        required: true,
                        message: 'Please provide software name.'
                    }
                ]}
            >
                <Input />
            </Form.Item>

            <Form.Item
                extra="Project version number or release name (use the version from package metadata, not VCS revision)."
                label="Software Version"
                name="swVersion"
                rules={[
                    {
                        required: true,
                        message: 'Please provide software version.'
                    }
                ]}
            >
                <Input />
            </Form.Item>

            <Form.Item
                extra="Identifier of the project version control system (git, git-repo, mercurial or subversion)."
                initialValue="git"
                label="Type of Repository"
                name="vcsType"
                rules={[
                    {
                        required: true,
                        message: 'Please provide name of project, product or component to be scanned.'
                    }
                ]}
            >
                <Select placeholder="Type of version control system.">
                    <Option value="git">Git</Option>
                    <Option value="git-repo">Git-repo</Option>
                    <Option value="mercurial">Mercurial</Option>
                    <Option value="subversion">Subversion</Option>
                </Select>
            </Form.Item>

            <Form.Item
                extra="VCS URL (clone URL) of code repository to scan."
                label="Code Repository (clone) URL"
                name="vcsUrl"
                rules={[
                    {
                        required: true,
                        message: 'Please provide the clone URL of the code repository to scan.'
                    }
                ]}
            >
                <Input />
            </Form.Item>

            <Form.Item
                extra="SHA1 or tag to scan (not branch names, because they can move). If VCS_TYPE is 'git-repo', SHA1 must be unabbreviated, tag names must be prefixed with 'refs/tags/'."
                label="Code Revision"
                name="vcsRevision"
                rules={[
                    {
                        required: true,
                        message: 'Please provide VCS URL (clone URL) of code repository to scan.'
                    }
                ]}
            >
                <Input />
            </Form.Item>


            <Form.Item wrapperCol={{ offset: 6, span: 12 }}>
                <Button type="primary" htmlType="submit">
                    Submit
                </Button>
            </Form.Item>
        </Form>
    );
};

export default TriggerNewScanForm;