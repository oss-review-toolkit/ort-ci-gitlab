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

const {
    appendWebpackPlugin
} = require('@rescripts/utilities')
const dotEnv = require('dotenv-webpack');
const {
    editWebpackPlugin
} = require('@rescripts/utilities')
const fse = require('fs-extra');
const HTMLInlineCSSWebpackPlugin = require('html-inline-css-webpack-plugin').default;
const WebpackEventPlugin = require('webpack-event-plugin');

module.exports = {
    webpack: config => {
        const configA = appendWebpackPlugin(
            new dotEnv({
                systemvars: true
            }),
            config,
        );
        
        if (process.env.NODE_ENV !== 'development') {
            const configB = editWebpackPlugin(
                p => {
                    p.inlineSource = '.(js|css)$';
                    p.chunks = ['chunk'];
                    p.title = 'ORT for GitLab Dashboard';

                    return p
                },
                'HtmlWebpackPlugin',
                configA,
            );

            const configC = editWebpackPlugin(
                p => {
                    p.tests = [/.*/];
                    return p
                },
                'InlineChunkHtmlPlugin',
                configB,
            );

            const configD = appendWebpackPlugin(
                new HTMLInlineCSSWebpackPlugin(),
                configC,
            );

            const configE = appendWebpackPlugin(
                new WebpackEventPlugin([{
                    hook: 'done',
                    callback: (compilation) => {
                        console.log('Removing unneeded files and dirs in build dir...');

                        fse.remove('./build/asset-manifest.json')
                            .catch(err => {
                                console.error(err);
                            });

                        fse.remove('./build/static')
                            .catch(err => {
                                console.error(err);
                            });
                    }
                }]),
                configD
            )

            return configE;
        }

        return configA;
    }
};
