# Terraform in local kind-cluster

This document to show up the way we use terraform to provision kind-cluster in local machine. It provides a local kind-cluster with pre-configured ArgoCD, logging, monitoring (**seperate helm chart, suppose to use Grafana LGTM stack quickly, but it will complicate the project**).

## Dependencies

- Terraform
- kubectl
- kind
- helm

## Installation
