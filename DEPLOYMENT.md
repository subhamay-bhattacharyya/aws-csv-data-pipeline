# CloudFormation Template Deployment Guide

## Overview

This repository contains CloudFormation templates for deploying AWS infrastructure. The templates use a nested stack pattern where the root template references nested templates stored in S3.

## Template Structure

- **Root Template**: `cloudformation/template.yaml` - Main template that invokes nested stacks
- **Nested Template**: `templates/s3-bucket.yaml` - Template for creating S3 buckets with security defaults
- **Parameters**: `cloudformation/parameters.json` - Parameters for stack deployment

## Prerequisites

1. **AWS CLI**: Install and configure AWS CLI with appropriate credentials
2. **S3 Bucket**: Create an S3 bucket to store nested templates (or use the default)
3. **IAM Permissions**: Ensure your AWS principal has permissions for:
   - CloudFormation operations
   - S3 operations (upload/download)
   - IAM role assumptions
   - KMS operations (if using encryption)

## Step 1: Upload Templates to S3

Before deploying, the nested templates must be uploaded to S3:

```bash
# Using the deployment script (recommended)
./scripts/deploy-templates.sh [BUCKET_NAME] [REGION]

# Or manually upload
aws s3 cp templates/s3-bucket.yaml s3://your-bucket-name/cloudformation-template/s3-bucket.yaml
```

**Default Bucket Name**: `subhamay-cfn-nested-templates-270453428528-devl-us-east-1`

If you're using a different bucket, update the `NestedStacksS3BucketName` parameter in the root template or parameters file.

## Step 2: Validate Templates

Validate the templates before deployment:

```bash
# Validate nested template
aws cloudformation validate-template --template-body file://templates/s3-bucket.yaml

# Validate root template (requires nested template to be in S3)
aws cloudformation validate-template --template-body file://cloudformation/template.yaml
```

## Step 3: Deploy Stack

Deploy the CloudFormation stack:

```bash
aws cloudformation deploy \
  --template-file cloudformation/template.yaml \
  --stack-name aws-csv-data-pipeline-stack \
  --parameter-overrides file://cloudformation/parameters.json \
  --capabilities CAPABILITY_IAM \
  --region us-east-1
```

## Step 4: Monitor Deployment

Check stack events:

```bash
aws cloudformation describe-stack-events \
  --stack-name aws-csv-data-pipeline-stack \
  --region us-east-1
```

Check stack status:

```bash
aws cloudformation describe-stacks \
  --stack-name aws-csv-data-pipeline-stack \
  --region us-east-1
```

## Parameters

### Root Template Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| NestedStacksS3BucketName | String | subhamay-cfn-nested-templates-270453428528-devl-us-east-1 | S3 bucket name where nested templates are stored |
| ProjectName | String | ztc-etl | Project name to use as bucket prefix |
| RawDataBucketBaseName | String | csv-raw-data | Base name for raw data bucket |
| ProcessedDataBucketBaseName | String | csv-processed-data | Base name for processed data bucket |
| FinalDataBucketBaseName | String | csv-final-data | Base name for final data bucket |
| Environment | String | devl | Deployment environment (devl, stag, prod) |
| KmsKey | String | (empty) | KMS Key for S3 encryption (alias or ARN) |
| EnableBucketKey | String | false | Enable S3 Bucket Key for KMS cost optimization |
| CiSuffix | String | (empty) | Optional CI suffix for bucket names |

## Bucket Naming Convention

Buckets are named using the following pattern:

```
{ProjectName}-{BucketBaseName}-{AccountId}-{Environment}-{Region}[-{CiSuffix}]
```

**Example**: `ztc-etl-csv-raw-data-123456789012-devl-us-east-1`

## Encryption Configuration

### Without KMS Encryption (default)
No changes needed. Buckets will use S3-managed encryption.

### With KMS Encryption
Set the `KmsKey` parameter to one of:
- KMS Key Alias: `alias/my-key`
- KMS Key ID: `arn:aws:kms:region:account:key/key-id`
- Plain key name (auto-converted to alias): `my-key`

Set `EnableBucketKey` to `true` for cost optimization with KMS.

## Troubleshooting

### Error: "Parameters do not exist in the template"
This error occurs when CloudFormation tries to validate the nested template but can't access it. Solutions:
1. Ensure nested templates are uploaded to S3
2. Verify the S3 bucket name and path match the TemplateURL
3. Check IAM permissions for S3 and CloudFormation

### Error: "S3 bucket does not exist"
Ensure the S3 bucket specified in `NestedStacksS3BucketName` exists and is accessible.

### Error: "Access Denied"
Check IAM permissions:
- S3: `s3:GetObject`, `s3:ListBucket`
- CloudFormation: `cloudformation:*`
- IAM: `iam:PassRole` (if using roles)

## Cleanup

To delete the stack:

```bash
# This will delete the root stack and all nested stacks
aws cloudformation delete-stack \
  --stack-name aws-csv-data-pipeline-stack \
  --region us-east-1
```

Note: S3 buckets have `DeletionPolicy: Retain`, so they won't be deleted when the stack is removed.

## CI/CD Integration

The repository includes GitHub Actions workflows for automated deployment:
- **CI Workflow** (`.github/workflows/ci.yaml`): Validates and deploys on pull requests
- **Release Workflow** (`.github/workflows/release.yaml`): Creates releases on merge to main

Before CI/CD can work, ensure GitHub environment variables are configured:
- `AWS_REGION`: CloudFormation deployment region
- `AWS_ACCOUNT_ID`: AWS account ID
- `OIDC_ROLE_NAME`: IAM role for OIDC trust
- `CFN_TEMPLATES_S3_BUCKET`: S3 bucket for templates

## Additional Resources

- [AWS CloudFormation User Guide](https://docs.aws.amazon.com/cloudformation/)
- [Nested Stacks](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html)
- [S3 Bucket Configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/BucketConfiguration.html)
