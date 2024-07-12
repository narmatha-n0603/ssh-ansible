#!/bin/bash
INVENTORY_SCRIPT="./aws_ec2.yaml"
PUBLIC_KEY_PATH="/var/lib/jenkins/.ssh/id_rsa.pub"
SSH_USER="jenkins" 
HOSTS=$(yq e '.all.hosts[]' $INVENTORY_SCRIPT)
for HOST in $HOSTS; do
    ssh-copy-id -i "$PUBLIC_KEY_PATH" "$SSH_USER@$HOST"
done
