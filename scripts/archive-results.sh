#!/bin/bash -e

declare -a files_to_compress=(
  "$ORT_RESULTS_ANALYZER_FILE"
  "$ORT_RESULTS_SCANNER_FILE"
  "$ORT_RESULTS_EVALUATOR_FILE"
  "$ORT_RESULTS_EVALUATED_MODEL_FILE"
)

for file in "${files_to_compress[@]}"; do
  if [ -f "$file" ]; then
    echo "Compressing '$file' to '$file.xz'."
    xz -1 $file
  fi
done
