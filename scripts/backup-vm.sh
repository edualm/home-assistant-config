#!/bin/sh

VM_NAME="haos"  # Name of the VM
BACKUP_XML="/opt/data/backup.xml" # Path to the backup XML configuration
BACKUP_PATH="/opt/backup/haos_backup.qcow2"  # Directory to store local backups
S3_BUCKET="ha-camelias"  # S3 bucket name
S3_PATH="backups/$VM_NAME"  # Path in the S3 bucket
DATE=$(date +%Y%m%d%H%M%S)  # Timestamp for backup
BACKUP_NAME="${VM_NAME}_backup_${DATE}.qcow2"  # Backup file name
AWS_REGION="eu-west-1"  # AWS region (e.g., us-east-1)

sudo rm "$BACKUP_PATH"

virsh backup-begin "$VM_NAME" "$BACKUP_XML"
virsh event "$VM_NAME" --event block-job

aws s3 cp "$BACKUP_PATH" "s3://$S3_BUCKET/$S3_PATH/$BACKUP_NAME" \
  --storage-class GLACIER \
  --region "$AWS_REGION"
