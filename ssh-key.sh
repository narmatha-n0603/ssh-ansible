#!/bin/bash
set -e
echo "Starting ssh-key.sh script at $(date)"
INVENTORY_SCRIPT="./aws_ec2.yaml"
PUBLIC_KEY_PATH="/var/lib/jenkins/.ssh/id_rsa.pub"
SSH_USER="jenkins"
if ! command -v yq &> /dev/null; then
    echo "yq command not found. Please install yq."
    exit 1
fi
if [ -z "$INVENTORY_SCRIPT" ] || [ ! -f "$INVENTORY_SCRIPT" ]; then
    echo "INVENTORY_SCRIPT is not set or file does not exist."
    exit 1
fi
if [ -z "$PUBLIC_KEY_PATH" ] || [ ! -f "$PUBLIC_KEY_PATH" ]; then
    echo "PUBLIC_KEY_PATH is not set or file does not exist."
    exit 1
fi
if [ -z "$SSH_USER" ]; then
    echo "SSH_USER is not set."
    exit 1
fi
HOSTS=$(yq e '.all.hosts[]' "$INVENTORY_SCRIPT")
for HOST in $HOSTS; do
    echo "Copying SSH key to $HOST"
    ssh-copy-id -i "$PUBLIC_KEY_PATH" "$SSH_USER@$HOST"
    if [ $? -eq 0 ]; then
        echo "Successfully copied SSH key to $HOST"
    else
        echo "Failed to copy SSH key to $HOST"
    fi
done
echo "Completed ssh-key.sh script at $(date)"

