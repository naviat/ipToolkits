# Terraform in local kind-cluster

This document to show up the way we use terraform to provision kind-cluster in local machine. It provides a local kind-cluster with pre-configured ArgoCD, logging, monitoring (**seperate helm chart, suppose to use Grafana LGTM stack but it will complicate the project, then just install Grafana, Loki, Prometheus**).

## Dependencies

- Terraform
- kubectl
- kind
- helm

## Installation

1. Update `/etc/hosts` to localhost domain we will use

    ```shell
    echo "127.0.0.1 monitoring.localhost argocd.localhost" | sudo tee -a /etc/hosts > /dev/null
    ```

1. Provision terraform

    ```shell
    cd infras/terraform
    ./deploy.sh
    ```

1. Cleanup after finish

    ```shell
    cd infras/terraform
    ./cleanup.sh
    ```
