terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.0.16"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29.0"
    }
  }

  required_version = ">= 1.3.7"
}
