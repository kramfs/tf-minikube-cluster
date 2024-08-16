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
  kubernetes_version = var.kubernetes_version
}

resource "minikube_cluster" "docker" {
  driver            = var.driver
  cluster_name      = var.cluster_name
  kubernetes_version  = contains([var.kubernetes_version], "default") ? var.kubernetes_version.default : null
  cpus              = var.cpus
  memory            = var.memory
  nodes             = var.nodes
  container_runtime = var.container_runtime
  addons            = var.addons
  wait              = var.wait
}