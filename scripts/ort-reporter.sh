#!/bin/bash

# Executes ORT's Reporter to presents scan results in various formats (defined by ORT_REPORT_FORMATS) such as visual reports,
# Open Source notices or Bill-Of-Materials (BOMs) to easily identify dependencies, licenses, copyrights or policy rule violations.

echo "------------------------------------------"
echo "Generating ORT reports..."
echo "------------------------------------------"

if [[ "$ORT_DISABLE_SCANNER" = "true" && "$ORT_DISABLE_EVALUATOR" = "true" ]]; then
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_ANALYZER_FILE
elif [[ "$ORT_DISABLE_SCANNER" = "true" && "$ORT_DISABLE_EVALUATOR" = "false" ]]; then
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_EVALUATOR_FILE
elif [[ "$ORT_DISABLE_SCANNER" = "false" && "$ORT_DISABLE_EVALUATOR" = "true" ]]; then
    ORT_RESULTS_INPUT_FILE=$ORT_RESULTS_SCANNER_FILE
fi

$ORT \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    report \
    -f $ORT_REPORT_FORMATS \
    -i $ORT_RESULTS_INPUT_FILE \
    -o $ORT_RESULTS_DIR \
    --copyright-garbage-file $ORT_CONFIG_COPYRIGHT_GARBAGE_FILE \
    --resolutions-file $ORT_CONFIG_RESOLUTIONS_FILE \
    --custom-license-texts-dir $ORT_CONFIG_CUSTOM_LICENSE_TEXTS_DIR \
    --license-classifications-file $ORT_CONFIG_LICENSE_CONFIGURATION_FILE \
    --package-configuration-dir $ORT_CONFIG_PACKAGE_CONFIGURATION_DIR \
    --how-to-fix-text-provider-script $ORT_HOW_TO_FIX_TEXT_PROVIDER_FILE \
    -O EvaluatedModel=output.file.formats=json \
    -O NoticeTemplate=project-types-as-packages="SpdxDocumentFile" \
    -O NoticeTemplate=template.path=$ORT_CONFIG_NOTICE_TEMPLATE_PATHS \
    -O SpdxDocument=document.name="${SW_NAME}" \
    -O SpdxDocument=output.file.formats=json,yaml

if [[ -f "$ORT_RESULTS_NOTICE_SUMMARY_FILE" ]]; then
    cp $ORT_RESULTS_NOTICE_SUMMARY_FILE $ORT_RESULTS_DIR/$NOTICE_FILE || true;
fi
