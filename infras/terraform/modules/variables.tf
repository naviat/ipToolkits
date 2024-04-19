variable "ingress_controller_namespace" {
  type        = string
  description = "The ingress controllers namespace (it will be created if needed)."
  default     = "ingress"
}

variable "monitoring_namespace" {
  type        = string
  description = "The name of the monitoring namespace (it will be created if needed)."
  default     = "monitoring"
}

variable "kubernetes_config_file" {
  type        = string
  description = "The Kubernetes config-file to be used"
  default     = "~/.kube/config"
}

variable "with_logging" {
  type        = bool
  description = "Whether or not to provision logging"
  default     = true
}

# ArgoCD
variable "helm_create_namespace" {
  type        = bool
  default     = true
  description = "Create the namespace if it does not yet exist"
}

variable "helm_chart_name" {
  type        = string
  default     = "argo-cd"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "6.0.14"
  description = "Version of the ArgoCD Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "argocd"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
  description = "ArgoCD helm repository"
}

variable "helm_wait" {
  type        = bool
  default     = true
  description = "Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true."
}

variable "helm_timeout" {
  type        = number
  default     = 300
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds."
}

variable "helm_cleanup_on_fail" {
  type        = bool
  default     = false
  description = "Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false."
}

variable "helm_atomic" {
  type        = bool
  default     = false
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false."
}

variable "argocd_namespace" {
  type        = string
  default     = "argocd"
  description = "The K8s namespace in which the ingress-nginx has been created"
}

variable "parent_application_names" {
  description = "Argocd parent application name"
  default     = ["applications-dev"]
  type        = list(string)
}

variable "github_username" {
  description = "Your Github/Gitlab username to map with personal_token"
  type        = string
}

variable "github_token" {
  type        = string
  description = "Github Token for the installation process"
}

variable "repo_url" {
  description = "Your Github/Gitlab username to map with personal_token"
  default     = "https://github.com/naviat/ipToolkits-applications"
  type        = string
}

variable "argo_image_updater_secret_name" {
  description = "Argo Image Updater secret name"
  default     = "git-creds"
  type        = string
}

variable "parent_source_paths" {
  description = "Argocd parent source path"
  default     = ["environments/dev"]
  type        = list(string)
}

variable "parent_source_targetrevision" {
  description = "branch of repo"
  default     = "HEAD"
  type        = string
}

variable "parent_destination_servers" {
  description = "Cluster endpoint destination"
  default     = "https://kubernetes.default.svc"
  type        = string
}

variable "parent_application_projects" {
  description = "Cluster endpoints destination"
  default     = ["dev"]
  type        = list(string)
}

variable "github_secret" {
  description = "Github Secret for the installation process"
  type        = string
  sensitive   = true
}

variable "github_client_secret" {
  type        = string
  description = "Github client secret"
}

variable "github_client_id" {
  type        = string
  description = "Github client ID"
}

variable "ingress_class_name" {
  type        = string
  default     = "internal-ingress"
  description = "Name of ingress class to be used for creating argocd internal URL"
}

variable "url" {
  type        = string
  default     = "argocd.localhost"
  description = "ArgoCD internal URL"
}
