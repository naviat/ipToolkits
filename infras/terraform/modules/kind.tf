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
        <<-EOF
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        EOF
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
      extra_mounts {
        host_path      = "${path.module}/shared-storage"
        container_path = "/var/local-path-provisioner"
      }
    }

    node {
      role = "worker"
      extra_mounts {
        host_path      = "${path.module}/shared-storage"
        container_path = "/var/local-path-provisioner"
      }
    }

    node {
      role = "worker"
      extra_mounts {
        host_path      = "${path.module}/shared-storage"
        container_path = "/var/local-path-provisioner"
      }
    }

    networking {
      api_server_address = "127.0.0.1"
      api_server_port    = 6443
    }
  }
}
