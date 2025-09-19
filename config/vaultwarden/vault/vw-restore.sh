#!/bin/bash
# Restore Vaultwarden backup from Cloudflare R2
# Usage: ./restore.sh <backup-file-name>

BACKUP_FILE="$1"
PASSWORD_FILE="/root/.vault_backup_pass"
RESTORE_DIR="/opt/vault/restore"
CONTAINER="vaultwarden"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup-file-name>"
    exit 1
fi

# Download from R2
rclone copy r2vault:vw-backups/"$BACKUP_FILE" .

# Decrypt
openssl enc -d -aes-256-cbc -pbkdf2 \
    -in "$BACKUP_FILE" \
    -out restore.tar.gz \
    -pass file:$PASSWORD_FILE

# Extract
mkdir -p "$RESTORE_DIR"
tar xzf restore.tar.gz -C "$RESTORE_DIR"

# Copy back to container
docker cp "$RESTORE_DIR/." $CONTAINER:/data/

# Restart container
docker restart $CONTAINER

echo "Restore completed from $BACKUP_FILE"
