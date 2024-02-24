# Description
This mini-project provides a powerful yet easy-to-use development environment for Kubernetes on your local machine:. This can be imported as a Terraform/OpenTofu module to easily bring up a minikube cluster.

* Leverages Terraform and the [Minikube provider](https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs) for seamless cluster management.
* Modular and customizable: Built with Minikube and Docker, but configurable to fit your preferences.

# Usage
To use as a module, add this in your Terraform declaration:

```
module "minikube_cluster" {
  source              = "github.com/kramfs/tf-minikube-cluster"
  cluster_name        = "minikube"
  driver              = "docker"                  # Options: docker, podman, kvm2, qemu, hyperkit, hyperv, ssh
  kubernetes_version  = v1.28.3                   # See options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
  container_runtime   = "containerd"              # Default: containerd. Options: docker, containerd, cri-o
  nodes               = "1"
}
```

Alternatively, add the values to your `main.auto.tfvars`

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
  kubernetes_version  = lookup(var.minikube, "kubernetes_version", null)         # See options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
  container_runtime   = lookup(var.minikube, "container_runtime", "containerd")  # Default: containerd. Options: docker, containerd, cri-o
  nodes               = lookup(var.minikube, "nodes", "1")
}
```