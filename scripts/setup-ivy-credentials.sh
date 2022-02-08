#!/bin/bash

# Creates an Ivy credentials file that enables authentication for access restricted binary repositories.
# Ivy is mainly used by SBT projects for dependency resolution.

IVY_CREDS_REALM=${IVY_CREDS_REALM:-"example"}
IVY_CREDS_URL=${IVY_CREDS_URL:-"example.com"}
IVY_CREDS_USERNAME=${IVY_CREDS_USERNAME:-"john"}
IVY_CREDS_PASSWORD=${IVY_CREDS_PASSWORD:-"example123"}

mkdir -p ${CI_PROJECT_DIR}/cache/ivy2
cat > ${CI_PROJECT_DIR}/cache/ivy2/.credentials <<EOF
realm=$IVY_CREDS_REALM
host=$IVY_CREDS_URL
user=$IVY_CREDS_USERNAME
password=$IVY_CREDS_PASSWORD
EOF

chmod 0600 ${CI_PROJECT_DIR}/cache/ivy2/.credentials
