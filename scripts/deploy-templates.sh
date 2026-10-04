#!/bin/bash

set -e

BUCKET_NAME="${1:-subhamay-cfn-nested-templates-270453428528-devl-us-east-1}"
REGION="${2:-us-east-1}"
TEMPLATE_DIR="templates"
S3_PREFIX="cloudformation-template"

echo "Uploading CloudFormation templates to S3..."
echo "Bucket: $BUCKET_NAME"
echo "Region: $REGION"
echo "Prefix: $S3_PREFIX"

if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "Error: Template directory '$TEMPLATE_DIR' not found"
  exit 1
fi

aws s3 sync "$TEMPLATE_DIR" "s3://$BUCKET_NAME/$S3_PREFIX/" \
  --region "$REGION" \
  --delete \
  --exclude "*" \
  --include "*.yaml" \
  --include "*.yml" \
  --metadata "ManagedBy=CloudFormation"

echo "Templates uploaded successfully!"
