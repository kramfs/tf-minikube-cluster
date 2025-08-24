# Example: migration wrapper that converts a map-style `var.minikube` into typed module args
# Place this in a higher-level module that currently uses a map and wants to call the new typed interface.

variable "minikube" {
  type = map(any)
  default = {}
}

# Convert optional numeric-like values: prefer numeric keys if present, otherwise convert legacy strings
locals {
  cpus_num  = contains(keys(var.minikube), "cpus_num") && var.minikube["cpus_num"] != 0 ? var.minikube["cpus_num"] : (
    contains(keys(var.minikube), "cpus") ? tonumber(var.minikube["cpus"]) : 0
  )

  memory_mb = contains(keys(var.minikube), "memory_mb") && var.minikube["memory_mb"] != 0 ? var.minikube["memory_mb"] : (
    contains(keys(var.minikube), "memory") ? tonumber(regex_replace(var.minikube["memory"], "[^0-9]", "")) : 0
  )

  nodes_num = contains(keys(var.minikube), "nodes_num") && var.minikube["nodes_num"] != 0 ? var.minikube["nodes_num"] : (
    contains(keys(var.minikube), "nodes") ? tonumber(var.minikube["nodes"]) : 0
  )
}

module "minikube_cluster" {
  source = "./.."

  cluster_name = lookup(var.minikube, "cluster_name", "minikube")
  driver       = lookup(var.minikube, "driver", "docker")
  kubernetes_version = lookup(var.minikube, "kubernetes_version", null)
  container_runtime   = lookup(var.minikube, "container_runtime", "containerd")

  # Pass numeric wrappers when available
  cpus_num  = local.cpus_num
  memory_mb = local.memory_mb
  nodes_num = local.nodes_num
}
