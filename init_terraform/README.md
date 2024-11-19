```bash
$ gcloud components update
$ gcloud services enable \
    cloudresourcemanager.googleapis.com \
    artifactregistry.googleapis.com

gcloud artifacts repositories add-iam-policy-binding my-repository \
--location=asia-northeast1 --member=allUsers --role=roles/artifactregistry.reader
```

```bash
$ gcloud org-policies set-policy drs-policy.yaml
```

```bash
$ gcloud org-policies set-policy drs-policy.yaml
API [orgpolicy.googleapis.com] not enabled on project [test-project-373118]. Would you like to enable and retry (this will take a few minutes)? (y/N)?  y

Enabling service [orgpolicy.googleapis.com] on project [test-project-373118]...
Operation "operations/acat.p2-593997455442-72845d77-95a1-42b7-9dd8-de27c9528e2b" finished successfully.
Updated policy [organizations/391933904932/policies/iam.allowedPolicyMemberDomains].
etag: CISo+LkGEOjds5oB-
name: organizations/391933904932/policies/iam.allowedPolicyMemberDomains
spec:
  etag: CISo+LkGEOjds5oB
  rules:
  - condition:
      expression: resource.matchTag('391933904932/environment', 'dev')
    values:
      allowedValues:
      - is:C01i6zm4u
  - values:
      allowedValues:
      - is:C01i6zm4u
  updateTime: '2024-11-20T16:53:24.323809Z'
```
