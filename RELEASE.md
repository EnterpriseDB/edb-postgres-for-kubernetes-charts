# Cloud Native PostgreSQL release procedure

**Steps:**

The following steps assume version 0.2.0 as the one to be released. Alter the
instructions accordingly.

1. Create branch `release/v0.2.0`
1. Approve the PR that is automatically generated.
1. The tag 0.2.0 will be created when the PR is merged.
1. The helm chart will be automatically added to the chart index.

To check the chart was updated correctly, run:
```bash
helm repo add cnp https://enterprisedb.github.io/cloud-native-postgresql-helm/
# or "helm repo update" if already added
helm search repo cnp
```
and you should see the latest version available.
