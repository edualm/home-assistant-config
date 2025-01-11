#!/bin/bash

# Variables
retain_count=5
bucket_name="ha-camelias"
backup_prefix="backups/haos"

# List and sort backups
backup_files=$(aws s3api list-objects-v2 --bucket $bucket_name --prefix $backup_prefix --query 'Contents[?contains(Key, `.qcow2`)] | sort_by(@, &LastModified) | reverse(@)' --output json)

# Identify backups to delete
delete_files=$(echo "$backup_files" | jq -r --argjson retain_count $retain_count '.[($retain_count):] | .[].Key')

# Delete old backups
for file in $delete_files; do
  aws s3 rm s3://$bucket_name/$file
done
