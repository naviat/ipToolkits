resource "kind_cluster" "this" {
  name            = "stakefish"
  kubeconfig_path = pathexpand(var.kubernetes_config_file)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    node {
      role = "worker"
      container_path {
        host_path      = "./shared-storage"
        container_path = "/var/local-path-provisioner"
      }
    }

    node {
      role = "worker"
      container_path {
        host_path      = "./shared-storage"
        container_path = "/var/local-path-provisioner"
      }
    }

    node {
      role = "worker"
      container_path {
        host_path      = "./shared-storage"
        container_path = "/var/local-path-provisioner"
      }
    }

    networking {
      api_server_address = "127.0.0.1"
      api_server_port    = 6443
    }
  }
}
