variable "driver" {
  description = "Minikube driver to use"
  type        = string
  default     = "docker"
}

variable "cluster_name" {
  description = "Minikube cluster_name"
  type        = string
  default     = "minikube"
}

variable "cpus" {
  description = "Minikube number of CPUs to use"
  type        = string
  default     = "2"
}

variable "memory" {
  description = "Minikube amoubnt of memory to allocate"
  type        = string
  default     = "4096mb"
}

variable "nodes" {
  description = "Minikube number of cluster nodes to create"
  type        = string
  default     = "1"
}

variable "container_runtime" {
  description = "The container runtime to be used"
  type        = string
  default     = "docker"  # Options: docker, containerd, cri-o
}

variable "addons" {
  description = "Minikube addons to enable"
  ## See available addons using "minikube --profile <profile-name> addons list"
  default = [
    "default-storageclass",
    "storage-provisioner",
    "metrics-server"
  ]
}

variable "wait" {
  # Ref: https://registry.terraform.io/providers/scott-the-programmer/minikube/latest/docs/resources/cluster#wait
  default = ["all"]
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  #default     = "v1.30.2" # See available options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
}