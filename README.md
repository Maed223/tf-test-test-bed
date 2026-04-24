# Terraform Test Bed

This repository is a minimal Terraform module plus a native `terraform test` suite.

It is intentionally configured to fail cleanup during `terraform test` and to leak an orphaned local file during test runs.

It uses only credential-free providers:

- `hashicorp/random` to generate a unique suffix
- `hashicorp/local` to write a file on the local filesystem

## Files

- `main.tf`: creates a managed local file, creates a second file via a provisioner side effect, and deliberately fails a destroy-time provisioner during cleanup
- `basic.tftest.hcl`: checks the planned outputs and verifies both files during apply

## Run it

```sh
terraform init
terraform test
```

`terraform test` is expected to fail during teardown. The `terraform_data.orphaned_test_artifact` resource has a destroy-time provisioner that exits non-zero, so Terraform reports a cleanup error for a tracked resource. The side-effect file created during apply is also intentionally left behind.

To inspect the orphaned files after a test run:

```sh
ls *-orphan-*.txt
```
