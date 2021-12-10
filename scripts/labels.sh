#!/bin/bash -e

# Converts the LABELS variable with format "key1=val1, key1=val2" into separate ORT label options (-l).

# Remove square brackets and replace comma with newline
LABELS_LIST="$(echo -e $LABELS | sed -e 's/[][]//g' -e 's/\, /\n/g')"

# Associate multiple values with one key so that 'key1=val1, key1=val2,' becomes 'key1=val1,val2'
declare -A array
while IFS== read key value; do
    array[$key]="${array[$key]}${array[$key]:+,}$value"
done <<< "$LABELS_LIST"

# Print labels in format suitable for ORT
for key in "${!array[@]}"; do
    echo -n "-l "
    [ -z ${array[$key]} ] && echo -n "$key " || echo -n "$key=${array[$key]} " 
done