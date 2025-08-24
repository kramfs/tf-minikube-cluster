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

# New numeric wrapper: prefer this when calling the module from Terraform code.
# If set to >0 it will take precedence over `cpus` string.
variable "cpus_num" {
  description = "(optional) Numeric CPUs value. When >0 this wins over `cpus` string for callers using typed vars."
  type        = number
  default     = 0
}

variable "memory" {
  description = "Minikube amoubnt of memory to allocate"
  type        = string
  default     = "4096mb"
}

# New numeric wrapper: memory in megabytes. When >0 this takes precedence and will be formatted as "<N>mb".
variable "memory_mb" {
  description = "(optional) Memory in megabytes. When >0 this wins over `memory` string."
  type        = number
  default     = 0
}

variable "nodes" {
  description = "Minikube number of cluster nodes to create"
  type        = string
  default     = "1"
}

# New numeric wrapper for nodes
variable "nodes_num" {
  description = "(optional) Numeric nodes value. When >0 this wins over `nodes` string."
  type        = number
  default     = 0
}

variable "container_runtime" {
  description = "The container runtime to be used"
  type        = string
  default     = "docker" # Options: docker, containerd, cri-o
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

  validation {
    condition = (
      var.kubernetes_version == "" ||
      var.kubernetes_version == "latest" ||
      can(regex("^v[0-9].*", var.kubernetes_version)) ||
      can(regex("^[0-9].*", var.kubernetes_version))
    )
    error_message = "kubernetes_version must be empty, 'latest', start with 'v', or be a numeric-like string such as '1.33.4'"
  }
}

# When true and `kubernetes_version` is empty, the provider/minikube will attempt to use the latest
# upstream Kubernetes version. Keep default = false to avoid unexpected upgrades in CI or callers.
variable "use_latest_kubernetes" {
  description = "(optional) When true and no kubernetes_version is supplied, use the provider's/latest Kubernetes version."
  type        = bool
  default     = false
}