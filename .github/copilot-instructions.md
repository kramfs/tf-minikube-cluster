## Purpose
Short, focused instructions to help an AI coding agent become productive in this repository (a small Terraform module that provisions a local Minikube cluster).

## Quick read (what to open first)
- `README.md` — usage examples and module interface.
- `main.tf` — provider declaration and primary `minikube_cluster` resource (the core of the module).
- `variable.tf` — canonical inputs and defaults (note: most variables are strings).
- `output.tf` — outputs exposed by the module; several are marked sensitive.
- `taskfile.yaml` — project automation (uses the `task` runner). Use it for typical commands.

## Big picture / architecture
- Purpose: lightweight Terraform module that creates a local Minikube cluster using the community `scott-the-programmer/minikube` provider.
- Single resource boundary: one `minikube_cluster` resource named `minikube_cluster.docker` (see `main.tf`). The module is intended to be imported by higher-level Terraform code.
- State/backends: no active remote backend in the repo — a commented HCP/cloud workspace block exists in `main.tf`. Do not enable HCP changes without explicit credentials and a follow-up change to CI/Docs.

## Developer workflows (concrete commands)
  - `task init` — runs `terraform init -upgrade` (via env PARAMETER).
  - `task plan` — runs `terraform plan`.
  - `task apply` / `task create_cluster` — runs `terraform apply --auto-approve` (create cluster convenience task runs init then apply).
  - `task destroy` / `task cleanup` — runs `terraform destroy --auto-approve` and a filesystem cleanup step.

Example quick run (locally):

## CI
- This repo includes a GitHub Actions CI workflow at `.github/workflows/ci.yml`.
- CI jobs:
  - `validate` — runs `terraform fmt -check -recursive`, `tflint`, `terraform init -backend=false -upgrade -input=false`, and `terraform validate`.
  - `plan` — runs `terraform plan` in the repo root (no backend).
  - `plan_examples` — runs `terraform plan` for `./examples` (no backend).

Notes:
- tflint is enforced in CI; fix lint errors before opening a PR.
- `plan` jobs run without a backend; they are safe but may not reflect real remotes that require credentials.


## Variable compatibility note
- New numeric wrapper variables were added for safer typed calling:
  - `cpus_num` (number, default 0) — when >0 it takes precedence over `cpus` string.
  - `memory_mb` (number, default 0) — when >0 it formats into `<N>mb` and takes precedence over `memory` string.
  - `nodes_num` (number, default 0) — when >0 it takes precedence over `nodes` string.
- The module remains backward compatible: legacy string variables continue to work. When editing callers, prefer the numeric wrappers for typed Terraform code.
```bash
task init
task create_cluster
task plan
task destroy
```

Also useful during edits: `terraform validate` and `terraform fmt` before opening a PR.

## Project-specific patterns & gotchas
- Provider pin: `main.tf` pins the Minikube provider source to `scott-the-programmer/minikube` with version `~>0.3`. When updating the provider, update docs and test locally.
- Variables are declared as strings (see `variable.tf`): e.g. `cpus = "2"`, `memory = "4096mb"`, `nodes = "1"`. Callers may pass strings or use the module-wrapping pattern in `README.md`.
- `kubernetes_version` handling: the variable is a string (no default). `main.tf` contains a conditional that attempts to read `var.kubernetes_version.default` in some call-sites — this indicates the module is sometimes used where `kubernetes_version` is passed as a map/object from higher-level code. Do not change the variable shape without updating the README + callers.
- Addons default: `variable.tf` enables `default-storageclass`, `storage-provisioner`, `metrics-server` by default — agents should preserve these defaults unless there's an explicit change request.

## Outputs & secrets
- `output.tf` exposes several outputs; note these are sensitive and must not be leaked in logs or plain-text PR output:
  - `minikube_cluster_client_certificate` (sensitive)
  - `minikube_cluster_client_key` (sensitive)
  - `minikube_cluster_ca_certificate` (sensitive)
- Non-sensitive outputs include `minikube_cluster_host`, `minikube_cluster_name`, `minikube_cluster_dns_domain`, `minikube_cluster_kubernetes_version`.

## PR guidance for agents
- Keep provider version pinning unless a clear compatibility reason exists. If upgrading, run a local `task create_cluster` and verify cluster creation against the new provider.
- Don't enable the commented HCP/cloud backend without adding CI secrets and documenting workspace names.
- If changing input types (for example making `cpus` an integer), update `variable.tf`, `README.md` examples, and any code that calls the module.
- Avoid printing sensitive outputs during CI; rely on Terraform outputs marked `sensitive = true` and treat them as secrets.

## Where to look for live behavior / tests
- There are no unit tests or automated Terraform tests in the repo. The fastest verification is to run the Taskfile workflows locally and inspect `terraform plan` and `terraform apply` results.

## Closing / feedback
If anything in this file is unclear or you want the agent to adopt stricter rules (for example, a required PR checklist or automated test harness), tell me which area to expand and I will iterate.
