#!/bin/bash
set -e
echo "Starting ssh-key.sh script at $(date)"
INVENTORY_SCRIPT="./aws_ec2.yaml"
PUBLIC_KEY_PATH="/var/lib/jenkins/.ssh/id_rsa.pub"
SSH_USER="jenkins"
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

