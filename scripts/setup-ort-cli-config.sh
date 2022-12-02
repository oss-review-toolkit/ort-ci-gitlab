#!/bin/bash -e

# Create the YAML configuration file used by ORT.

ORT_POSTGRES=$(cat <<-END
postgresStorage:
  url: '$ORT_DB_URL'
  schema: 'public'
  username: '$ORT_POSTGRES_USERNAME'
  password: '$ORT_POSTGRES_PASSWORD'
  sslmode: 'require'
END
)

if [[ ! -z "$ORT_POSTGRES_PASSWORD_BASE64_DEV" && "$ORT_USE_DEV_DB" == "true" ]]; then
  ORT_POSTGRES_PASSWORD=$(echo $ORT_POSTGRES_PASSWORD_BASE64_DEV | base64 -d)
  ORT_DB_URL="$ORT_POSTGRES_DEV_URL"
  ORT_STORAGE_READERS="postgres"
  ORT_STORAGE_WRITERS="postgres"
elif [[ ! -z "$ORT_POSTGRES_PASSWORD_BASE64" ]]; then
  ORT_POSTGRES_PASSWORD=$(echo $ORT_POSTGRES_PASSWORD_BASE64 | base64 -d)
  ORT_DB_URL="$ORT_POSTGRES_PROD_URL"
  ORT_STORAGE_READERS="postgres"
  ORT_STORAGE_WRITERS="postgres"
else
  ORT_STORAGE_READERS="local"
  ORT_STORAGE_WRITERS="local"
  ORT_POSTGRES=""
fi

envsubst < $CI_PROJECT_DIR/scripts/config.yml.template > $ORT_CLI_CONFIG_FILE
