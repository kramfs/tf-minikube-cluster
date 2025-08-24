## Contributing

Short guide to get changes accepted quickly.

1) Local checks (run before opening PR)
   - Install Terraform (recommended v1.6.x) and tflint (recommended v0.45.x).
   - Run formatting and validation:
     ```bash
     terraform fmt -recursive
     terraform validate
     tflint
     ```

2) Running examples
   - Examples live in `./examples`. To validate the migration wrapper example:
     ```bash
     cd examples
     terraform init -backend=false -upgrade
     terraform validate
     ```

3) CI expectations
   - The repo CI runs `terraform fmt -check -recursive`, `tflint`, `terraform init -backend=false -upgrade -input=false`, and `terraform validate`.
   - Fix tflint issues before opening a PR; the CI will fail on lint errors.

4) PR checklist
   - Run local checks above and ensure `terraform validate` passes.
   - Add or update `README.md` when behavior or variable shapes change.
   - Avoid leaking sensitive outputs in PR descriptions or logs.

If you need help migrating callers from the legacy map-based input to the new typed interface, see `examples/migration_wrapper.tf` or open an issue and I can prepare a conversion patch.
