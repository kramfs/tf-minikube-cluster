# Description
This mini-project provides a powerful yet easy-to-use development environment for Kubernetes on your local env. This can be imported as a Terraform/OpenTofu module to easily bring up a minikube cluster.

* Leverages Terraform and the [Minikube provider](https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs) for seamless cluster management.
* Modular and customizable: Built with Minikube and Docker, but configurable to fit your preferences.

# Usage
To use as a module, add this in your Terraform declaration:

```
module "minikube_cluster" {
  source              = "github.com/kramfs/tf-minikube-cluster"
  cluster_name        = "minikube"
  driver              = "docker"                  # Options: docker, podman, kvm2, qemu, hyperkit, hyperv, ssh
  kubernetes_version  = "v1.28.3"                # See options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
  # Prefer numeric values when calling the module from typed Terraform code:
  cpus_num            = 2
  memory_mb           = 4096
  container_runtime   = "containerd"              # Default: containerd. Options: docker, containerd, cri-o
  nodes_num           = 1
}
```

Alternatively, add the values to your `main.auto.tfvars`

# Migration notes

If you maintain callers of this module, note that numeric wrapper variables were added to make typed Terraform callers simpler:

- New numeric wrappers (optional): `cpus_num` (number), `memory_mb` (number), `nodes_num` (number). Each defaults to `0` which means "unset".
- Backward compatibility: if the numeric wrapper is set (>0) it takes precedence; otherwise the existing string variables (`cpus`, `memory`, `nodes`) are used.

Legacy example (map-based caller)
```
minikube = {
  cluster_name       = "minikube"
  driver             = "docker"
  kubernetes_version = "v1.28.3"
  memory             = "4096mb"
  nodes              = "1"
}
```

Typed/modern example (prefer these when writing Terraform modules)
```
module "minikube_cluster" {
  source     = "github.com/kramfs/tf-minikube-cluster"
  cluster_name = "minikube"
  driver       = "docker"
  kubernetes_version = "v1.28.3"
  cpus_num     = 2
  memory_mb    = 4096
  nodes_num    = 1
}
```

If you want help migrating callers or adding conversion wrappers in higher-level modules, I can prepare a short patch.

```
minikube = {
  cluster_name       = "minikube"
  driver             = "docker" # Options: docker, podman, kvm2, qemu, hyperkit, hyperv, ssh
  kubernetes_version = "v1.28.3"  # See available options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
  container_runtime  = "containerd" # Options: docker, containerd, cri-o
  nodes              = "1"
}
```

and use it like this:
```
variable "minikube" {}

module "minikube_cluster" {
  source              = "github.com/kramfs/tf-minikube-cluster"
  cluster_name        = lookup(var.minikube, "cluster_name", "minikube")
  driver              = lookup(var.minikube, "driver", "docker")                 # # Options: docker, podman, kvm2, qemu, hyperkit, hyperv, ssh
  # kubernetes_version may be either a string ("v1.28.3") or an object with a `.default` key
  # if the caller uses a var wrapper. This module accepts both shapes.
  kubernetes_version  = lookup(var.minikube, "kubernetes_version", null)
  container_runtime   = lookup(var.minikube, "container_runtime", "containerd")  # Default: containerd. Options: docker, containerd, cri-o
  # Prefer numeric wrappers when possible; fallback to legacy string values in the map.
  nodes               = lookup(var.minikube, "nodes", "1")
  # Example typed callers can set: cpus_num = 2, memory_mb = 4096, nodes_num = 1
}
```