#!/bin/bash

# Creates a .netrc file based on provided variables to access private code repositories.

NETRC_URL=${NETRC_URL:-"example.com"}
NETRC_USERNAME=${NETRC_USERNAME:-"john"}
NETRC_PASSWORD=${NETRC_PASSWORD:-"example123"}

cat > ~/.netrc <<EOF
machine $NETRC_URL
login $NETRC_USERNAME
password $NETRC_PASSWORD
EOF

chmod 0600 ~/.netrc