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

if [[ -f "$ORT_CONFIG_COPYRIGHT_GARBAGE_FILE" ]]; then
    ORT_REPORTER_OPTIONS="--copyright-garbage-file $ORT_CONFIG_COPYRIGHT_GARBAGE_FILE"
else
    ORT_REPORTER_OPTIONS=""
fi

if [[ -d "$ORT_CONFIG_CUSTOM_LICENSE_TEXTS_DIR" ]]; then
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --custom-license-texts-dir $ORT_CONFIG_CUSTOM_LICENSE_TEXTS_DIR"
fi

if [[ -f "$ORT_HOW_TO_FIX_TEXT_PROVIDER_FILE" ]]; then
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --how-to-fix-text-provider-script $ORT_HOW_TO_FIX_TEXT_PROVIDER_FILE"
fi

if [[ -f "$ORT_CONFIG_LICENSE_CLASSIFICATIONS_FILE" ]]; then
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --license-classifications-file $ORT_CONFIG_LICENSE_CLASSIFICATIONS_FILE"
fi

if [[ -d "$ORT_CONFIG_PACKAGE_CONFIGURATION_DIR" ]]; then
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --package-configuration-dir $ORT_CONFIG_PACKAGE_CONFIGURATION_DIR"
elif [[ -f "$ORT_CONFIG_PACKAGE_CONFIGURATION_FILE" ]]; then
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --package-configuration-file $ORT_CONFIG_PACKAGE_CONFIGURATION_FILE"
elif [[ -d "$ORT_CONFIG/packages" ]]; then
    # Use legacy named package configuration directory if present.
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --package-configuration-dir $ORT_CONFIG/packages"
    ORT_CONFIG_PACKAGE_CONFIGURATION_DIR=$ORT_CONFIG/packages
fi

if [[ -f "$ORT_CONFIG_RESOLUTIONS_FILE" ]]; then
    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS --resolutions-file $ORT_CONFIG_RESOLUTIONS_FILE"
fi

if [[ $ORT_REPORT_FORMATS =~ "EvaluatedModel" ]]; then
   ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS -O EvaluatedModel=output.file.formats=json"
fi

if [[ $ORT_REPORT_FORMATS =~ "NoticeTemplate" ]]; then
   ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS -O NoticeTemplate=project-types-as-packages=\"SpdxDocumentFile\""
   ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS -O NoticeTemplate=template.path=$ORT_CONFIG_NOTICE_TEMPLATE_PATHS"
fi

# FIXME: Below statement fails if SW_NAME contains a space
# if [[ $ORT_REPORT_FORMATS =~ "SpdxDocument" ]]; then
#    ORT_REPORTER_OPTIONS="$ORT_REPORTER_OPTIONS -O SpdxDocument=document.name='${SW_NAME}' \ -O SpdxDocument=output.file.formats=json,yaml"
# fi

$ORT \
    --$ORT_LOG_LEVEL \
    --stacktrace \
    report \
    $ORT_REPORTER_OPTIONS \
    -f $ORT_REPORT_FORMATS \
    -i $ORT_RESULTS_INPUT_FILE \
    -o $ORT_RESULTS_DIR \
    -O SpdxDocument=document.name="${SW_NAME}" \
    -O SpdxDocument=output.file.formats=json,yaml

if [[ -f "$ORT_RESULTS_NOTICE_SUMMARY_FILE" ]]; then
    cp $ORT_RESULTS_NOTICE_SUMMARY_FILE $ORT_RESULTS_DIR/$NOTICE_FILE || true;
fi
