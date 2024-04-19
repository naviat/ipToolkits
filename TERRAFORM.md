# Terraform in local kind-cluster

This document to show up the way we use terraform to provision kind-cluster in local machine. It provides a local kind-cluster with pre-configured ArgoCD, logging, monitoring (**seperate helm chart, suppose to use Grafana LGTM stack but it will complicate the project, then just install Grafana, Loki, Prometheus**).

> You can view terrafomr in detail at [terraform docs for this repository.](./infras/terraform/modules/README.md)

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
    cd infras/terraform/modules
    ./deploy.sh
    ```

1. Cleanup after finish

    ```shell
    cd infras/terraform/modules
    ./teardown.sh
    ```

After that, you can access to ArgoCD with: `https://argocd.localhost` and to Grafana with: `https://monitoring.localhost`
