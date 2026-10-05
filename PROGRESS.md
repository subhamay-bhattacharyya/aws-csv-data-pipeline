# Progress Tracker

**Overall:** 3/11 complete | **Last Updated:** 2026-10-04 23:30 | **Status:** 🔄 In Progress

---

## ✅ Checklist

| # | Resource | Status | Notes |
| --- | --- | --- | --- |
| 1 | S3 Bucket (CSV Raw Data) | ✅ | Bucket Created |
| 2 | S3 Bucket (CSV Processed Data) | ✅ | Bucket Created |
| 3 | S3 Bucket (CSV Final Data) | ✅ | Bucket Created |
| 4 | IAM Roles and Policies | 🔴 | Not Created |
| 5 | Lambda Functions | 🔴 | Not Created |
| 6 | Glue Database | 🔴 | Not Created |
| 7 | Glue Crawler | 🔴 | Not Created |
| 8 | Glue ETL Job | 🔴 | Not Created |
| 9 | S3 Event Notification | 🔴 | Not Created |
| 10 | Amazon Athena | 🔴 | Not Created |
| 11 | Amazon QuickSight | 🔴 | Not Created |

---

## 🔴 Blockers

### Issue: S3 Bucket Nested Template CloudFormation Integration

- **Status**: ✅ RESOLVED
- **What was fixed**:
  - Created nested S3 bucket template (templates/template.yaml)
  - Fixed parameter validation errors in root template
  - Configured S3 bucket policy for CloudFormation access
  - Uploaded templates to S3 (cfn-nested-aws-s3-bucket/template.yaml)

### Issue: Remaining Nested Stack Templates

- Lambda Function IAM Role
- Glue Database
- Glue Crawler
- Glue ETL Job
- S3 Event notification
- Athena Resources
- QuickSight Resources

- Why: Need to create CloudFormation nested stack templates for these resources

---

## 🟡 Current Work

### Resource: S3 Bucket Nested Templates

- [x] Create nested S3 bucket template (templates/template.yaml)
- [x] Fix CloudFormation parameter validation errors
- [x] Fix CI/CD pipeline S3 bucket policy issue
- [x] Upload nested templates to S3
- [ ] Update DeletionPolicy for S3 buckets (if needed)

---

## 🎯 Next Actions

1. Create Nested Stack Template for Lambda Function.
2. Create Nested Stack Template for Glue Database
3. Create Nested Stack Template for Glue Crawler
4. Create Nested Stack Template for Glue ETL Job
5. SCreate Nested Stack Template for 3 Event notification
6. Create Nested Stack Template for Athena Resources
7. Create Nested Stack Template for QuickSight Resources

---

## 📝 Notes

