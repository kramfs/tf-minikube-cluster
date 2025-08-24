plugin "aws" {}

# Minimal tflint configuration: enable core rules only. Add provider-specific rules as needed.
rule "terraform_unused_declarations" {
  enabled = true
}
