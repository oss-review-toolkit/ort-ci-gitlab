#!/bin/bash -e

# Generates SSH configuration based on provided variables.

mkdir -p ~/.ssh

SSH_KEY_1_HOST=${SSH_KEY_1_HOST:-"example.com"}
SSH_KEY_2_HOST=${SSH_KEY_2_HOST:-"example.edu"}
SSH_KEY_3_HOST=${SSH_KEY_3_HOST:-"example.net"}
SSH_KEY_4_HOST=${SSH_KEY_4_HOST:-"example.org"}
SSH_KEY_1_USER=${SSH_KEY_1_USER:-"git"}
SSH_KEY_2_USER=${SSH_KEY_2_USER:-"git"}
SSH_KEY_3_USER=${SSH_KEY_3_USER:-"git"}
SSH_KEY_4_USER=${SSH_KEY_4_USER:-"git"}

if [[ ! -z "$SSH_KEY_1_BASE64" ]]; then 
  echo "Created SSH config for host '$SSH_KEY_1_HOST' and user '$SSH_KEY_1_USER'..."
  echo $SSH_KEY_1_BASE64 | base64 -d > ~/.ssh/id_key_1
fi

if [[ ! -z "$SSH_KEY_2_BASE64" ]]; then 
  echo "Created SSH config for host '$SSH_KEY_2_HOST' and user '$SSH_KEY_2_USER'..."
  echo $SSH_KEY_2_BASE64 | base64 -d > ~/.ssh/id_key_2
fi

if [[ ! -z "$SSH_KEY_3_BASE64" ]]; then 
  echo "Created SSH config for host '$SSH_KEY_3_HOST' and user '$SSH_KEY_3_USER'..."
  echo $SSH_KEY_3_BASE64 | base64 -d > ~/.ssh/id_key_3
fi

if [[ ! -z "$SSH_KEY_4_BASE64" ]]; then 
  echo "Created SSH config for host '$SSH_KEY_4_HOST' and user '$SSH_KEY_4_USER'..."
  echo $SSH_KEY_4_BASE64 | base64 -d > ~/.ssh/id_key_4
fi

cat > ~/.ssh/config <<EOF

Host $SSH_KEY_1_HOST
    User $SSH_KEY_1_USER
    IdentityFile ~/.ssh/id_key_1

Host $SSH_KEY_2_HOST
    User $SSH_KEY_2_USER
    IdentityFile ~/.ssh/id_key_2

Host $SSH_KEY_3_HOST
    User $SSH_KEY_3_USER
    IdentityFile ~/.ssh/id_key_3

Host $SSH_KEY_4_HOST
    User $SSH_KEY_4_USER
    IdentityFile ~/.ssh/id_key_4

Host *
    StrictHostKeyChecking=no
    UserKnownHostsFile=/dev/null
EOF

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_key_*
chmod 600 ~/.ssh/config
