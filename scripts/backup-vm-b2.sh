#!/bin/sh

VM_NAME="haos"  # Name of the VM
BACKUP_XML="/opt/data/backup.xml" # Path to the backup XML configuration
BACKUP_PATH="/opt/backup/haos_backup.qcow2"  # Directory to store local backups
S3_BUCKET="ha-camelias-backup"  # S3 bucket name
DATE=$(date +%Y%m%d%H%M%S)  # Timestamp for backup
BACKUP_NAME="${VM_NAME}_backup_${DATE}.qcow2"  # Backup file name
AWS_ENDPOINT="https://s3.eu-central-003.backblazeb2.com"

sudo rm "$BACKUP_PATH"

virsh backup-begin "$VM_NAME" "$BACKUP_XML"
virsh event "$VM_NAME" --event block-job

aws s3 cp "$BACKUP_PATH" "s3://$S3_BUCKET/$BACKUP_NAME" \
  --profile "b2" \
  --endpoint-url="$AWS_ENDPOINT"
