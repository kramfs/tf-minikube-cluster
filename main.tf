##############
## MINIKUBE ##
##############
# Description: Provision a local minikube cluster for that can be used for local development
# URL: https://github.com/kramfs/tf-minikube-cluster

## TERRAFORM DEFINITION ##
terraform {
  required_providers {
    ## Ref: https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs
    ## Ref: https://github.com/scott-the-programmer/terraform-provider-minikube
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "~>0.3" # Good practice to pin to a specific provider version or lineage
    }
  }

  ## STATE BACKEND
  # HCP: Hashicorp Cloud
  #cloud {
  #  organization = "kramfs-org"
  #  workspaces {
  #    name = "tf-cli-test"
  #  }
  #}

}

## PROVIDER ##
provider "minikube" {
  # Commenting the following will default to using the current stable version
  # Support callers that pass either a plain string ("v1.28.3") or an object
  # with a `.default` key (some higher-level modules do this).
  # Compute a concrete value in `local.kubernetes_version` (null when unset).
  kubernetes_version = local.kubernetes_version
}

resource "minikube_cluster" "docker" {
  driver             = var.driver
  cluster_name       = var.cluster_name
  kubernetes_version = local.kubernetes_version
  # Prefer new numeric variables if set (>0), otherwise fall back to legacy string vars.
  cpus              = var.cpus_num > 0 ? tostring(var.cpus_num) : var.cpus
  memory            = var.memory_mb > 0 ? format("%dmb", var.memory_mb) : var.memory
  nodes             = var.nodes_num > 0 ? tostring(var.nodes_num) : var.nodes
  container_runtime = var.container_runtime
  addons            = var.addons
  wait              = var.wait
}

locals {
  # kubernetes_version may be either a string or an object with `.default`.
  # Use can(...) to test access safely and fall back to using the string value.
  kubernetes_version = can(var.kubernetes_version.default) ? var.kubernetes_version.default : (
    (var.kubernetes_version != "" && var.kubernetes_version != null) ? var.kubernetes_version : null
  )
}