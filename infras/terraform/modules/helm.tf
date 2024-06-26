provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kubernetes_config_file)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kubernetes_config_file)
}

resource "helm_release" "ingress_controller" {
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.4.2"

  namespace        = var.ingress_controller_namespace
  create_namespace = true

  values = [
    file("values/ingress_controller.values.yaml")
  ]

  depends_on = [kind_cluster.this]
}

resource "null_resource" "wait_for_ingress" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "....Waiting for the nginx ingress controller..."
      kubectl wait --namespace ${helm_release.ingress_controller.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
    EOF
  }

  depends_on = [helm_release.ingress_controller]
}

resource "helm_release" "monitoring" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "45.4.0"

  namespace        = var.monitoring_namespace
  create_namespace = true

  values = [
    file("values/monitoring.values.yaml")
  ]

  depends_on = [null_resource.wait_for_ingress]
}

resource "helm_release" "container_monitoring" {
  name       = "container-monitoring"
  repository = "https://ckotzbauer.github.io/helm-charts"
  chart      = "cadvisor"
  version    = "2.3.2"

  namespace        = var.monitoring_namespace
  create_namespace = true

  values = [
    file("values/container_monitoring.values.yaml")
  ]

  depends_on = [helm_release.monitoring]
}

resource "helm_release" "logging" {
  count = var.with_logging ? 1 : 0

  name       = "logging"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.9.9"

  namespace        = var.monitoring_namespace
  create_namespace = true

  values = [
    file("values/logging.values.yaml")
  ]

  depends_on = [null_resource.wait_for_ingress]
}
