#####################################################################
############## OTHER APPROACH FOR MULTI ENVIRONMENT #################
########################   WORK IN PROGRESS  ########################
# resource "helm_release" "argocd" {
#   chart            = var.helm_chart_name
#   create_namespace = var.helm_create_namespace
#   namespace        = var.argocd_namespace
#   name             = var.helm_release_name
#   version          = var.helm_chart_version
#   repository       = var.helm_repo_url
#   wait             = var.helm_wait
#   timeout          = var.helm_timeout
#   cleanup_on_fail  = var.helm_cleanup_on_fail
#   atomic           = var.helm_atomic
#   verify           = false
#   skip_crds        = true
#   values           = [local_sensitive_file.rendered_yaml.content]
#   depends_on       = [data.external.kind_check, null_resource.wait_for_ingress]
# }

# locals {
#   init_conf = {
#     for index, name in var.parent_application_names : "applications[${index}]" => {
#       name                          = tostring(name)
#       namespace                     = tostring(var.argocd_namespace)
#       project                       = tostring(var.parent_application_projects[index])
#       repoURL                       = tostring(var.repo_url)
#       targetRevision                = tostring(var.parent_source_targetrevision)
#       path                          = tostring(var.parent_source_paths[index])
#       destination_server            = tostring(var.parent_destination_servers)
#       destination_namespace         = tostring("")
#       syncPolicy_automated_prune    = tostring("true")
#       syncPolicy_automated_selfHeal = tostring("true")
#     }
#   }
# }

# resource "helm_release" "argo_apps" {
#   depends_on    = [helm_release.argocd, kubernetes_manifest.argo_projects]
#   name          = "argocd-apps"
#   repository    = var.helm_repo_url
#   chart         = "argocd-apps"
#   version       = "1.6.1"
#   namespace     = var.argocd_namespace
#   recreate_pods = true
#   timeout       = 1200

#   dynamic "set" {
#     for_each = flatten([
#       for app, cfg in local.init_conf : [
#         for key, value in cfg : {
#           name  = "applications[${app}].${key}"
#           value = tostring(value)
#         }
#       ]
#     ])

#     content {
#       name  = set.value.name
#       value = set.value.value
#     }
#   }
# }



# resource "kubernetes_secret" "git-creds" {
#   metadata {
#     name      = var.argo_image_updater_secret_name
#     namespace = var.argocd_namespace
#   }

#   data = {
#     username = var.github_username
#     password = var.github_token
#   }

#   type = "Opaque"
#   depends_on = [
#     helm_release.argocd
#   ]
# }

# resource "local_sensitive_file" "rendered_yaml" {
#   content = templatefile("${path.module}/config.yaml.tpl", {
#     github_client_id     = var.github_client_id,
#     github_client_secret = var.github_client_secret,
#     github_token         = var.github_token,
#     github_username      = var.github_username,
#     url                  = var.url,
#     github_secret        = var.github_secret
#   })
#   filename = "${path.module}/rendered_config.yaml"
# }

# # Issue: Unable to create CRD using argocd helm
# # Solution: Pre-create CRD using Kubernetes manifest.
# resource "null_resource" "apply_crd" {
#   depends_on = [data.external.kind_check]
#   triggers = {
#     key = uuid()
#   }

#   provisioner "local-exec" {
#     command = "kubectl apply -f ${path.module}/values/argocd-crd.yaml"
#   }
# }

# resource "kubernetes_manifest" "argo_projects" {
#   depends_on = [null_resource.apply_crd]

#   for_each = toset(var.parent_application_projects)

#   manifest = {
#     apiVersion = "argoproj.io/v1alpha1"
#     kind       = "AppProject"
#     metadata = {
#       name      = each.value
#       namespace = var.argocd_namespace
#     }
#     spec = {
#       clusterResourceWhitelist = [{
#         group = "*"
#         kind  = "*"
#       }]
#       sourceRepos = ["*"]
#       destinations = [{
#         server    = "*"
#         namespace = "*"
#         name      = "*"
#       }]
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "argocd-server-http" {
#   metadata {
#     name      = "${var.argocd_namespace}-server-http"
#     namespace = var.argocd_namespace
#   }
#   spec {
#     ingress_class_name = var.ingress_class_name
#     rule {
#       host = var.url
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "${var.argocd_namespace}-server"
#               port {
#                 name = "http"
#               }
#             }
#           }
#         }
#       }
#     }
#   }
#   depends_on = [
#     helm_release.argocd
#   ]
# }
