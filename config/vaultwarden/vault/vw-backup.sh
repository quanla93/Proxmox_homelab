#!/bin/bash
# Vaultwarden Full Backup Script
# Features:
# 1. Backup Vaultwarden /data from Docker container
# 2. Encrypt backup using AES-256
# 3. Upload encrypted backup to Cloudflare R2 via rclone
# 4. Delete local backups older than 30 days
# 5. Delete R2 backups older than 90 days
# 6. Log the process

# -------------------- Configuration --------------------
CONTAINER="vaultwarden"
BACKUP_DIR="/opt/vault/backups"
PASSWORD_FILE="/root/.vault_backup_pass"  # contains AES-256 passphrase
R2_REMOTE="r2vault:vw-backups"           # rclone remote:path
LOG_FILE="/opt/vault/backups/logs/vault_backup.log"

# Timestamp for filenames and logs
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/vw-backup-$NOW.tar.gz"
ENCRYPTED_FILE="$BACKUP_FILE.enc"

# -------------------- Prepare --------------------
mkdir -p "$BACKUP_DIR"
echo "[$NOW] Starting Vaultwarden backup..." | tee -a "$LOG_FILE"

# -------------------- Backup Vaultwarden --------------------
echo "[$NOW] Creating backup from container $CONTAINER..." | tee -a "$LOG_FILE"
docker exec $CONTAINER tar czf /tmp/vw-backup-$NOW.tar.gz -C /data .
docker cp $CONTAINER:/tmp/vw-backup-$NOW.tar.gz "$BACKUP_FILE"
docker exec $CONTAINER rm /tmp/vw-backup-$NOW.tar.gz
echo "[$NOW] Backup saved to $BACKUP_FILE" | tee -a "$LOG_FILE"

# -------------------- Encrypt Backup --------------------
echo "[$NOW] Encrypting backup..." | tee -a "$LOG_FILE"
openssl enc -aes-256-cbc -pbkdf2 -salt \
    -in "$BACKUP_FILE" \
    -out "$ENCRYPTED_FILE" \
    -pass file:$PASSWORD_FILE
rm "$BACKUP_FILE"
echo "[$NOW] Encrypted backup saved to $ENCRYPTED_FILE" | tee -a "$LOG_FILE"

# -------------------- Cleanup local old backups --------------------
echo "[$NOW] Cleaning up local backups older than 30 days..." | tee -a "$LOG_FILE"
find "$BACKUP_DIR" -type f -name "vw-backup-*.tar.gz.enc" -mtime +30 -delete

# -------------------- Upload to Cloudflare R2 --------------------
echo "[$NOW] Uploading encrypted backup to Cloudflare R2 ($R2_REMOTE)..." | tee -a "$LOG_FILE"
rclone copy "$ENCRYPTED_FILE" "$R2_REMOTE" --s3-no-check-bucket

# -------------------- Cleanup old R2 backups (>90 days) --------------------
echo "[$NOW] Deleting R2 backups older than 90 days..." | tee -a "$LOG_FILE"
rclone delete --min-age 90d "$R2_REMOTE" --s3-no-check-bucket

echo "[$NOW] Backup process completed successfully." | tee -a "$LOG_FILE"
