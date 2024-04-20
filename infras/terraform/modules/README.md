<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.12.1 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | >= 0.0.16 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.29.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.13.1 |
| <a name="provider_kind"></a> [kind](#provider\_kind) | 0.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.container_monitoring](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.logging](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.monitoring](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kind_cluster.this](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [null_resource.wait_for_ingress](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_image_updater_secret_name"></a> [argo\_image\_updater\_secret\_name](#input\_argo\_image\_updater\_secret\_name) | Argo Image Updater secret name | `string` | `"git-creds"` | no |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | The K8s namespace in which the ingress-nginx has been created | `string` | `"argocd"` | no |
| <a name="input_github_client_id"></a> [github\_client\_id](#input\_github\_client\_id) | Github client ID | `string` | n/a | yes |
| <a name="input_github_client_secret"></a> [github\_client\_secret](#input\_github\_client\_secret) | Github client secret | `string` | n/a | yes |
| <a name="input_github_secret"></a> [github\_secret](#input\_github\_secret) | Github Secret for the installation process | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github Token for the installation process | `string` | n/a | yes |
| <a name="input_github_username"></a> [github\_username](#input\_github\_username) | Your Github/Gitlab username to map with personal\_token | `string` | n/a | yes |
| <a name="input_helm_atomic"></a> [helm\_atomic](#input\_helm\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false. | `bool` | `false` | no |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Helm chart name to be installed | `string` | `"argo-cd"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the ArgoCD Helm chart | `string` | `"6.0.14"` | no |
| <a name="input_helm_cleanup_on_fail"></a> [helm\_cleanup\_on\_fail](#input\_helm\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false. | `bool` | `false` | no |
| <a name="input_helm_create_namespace"></a> [helm\_create\_namespace](#input\_helm\_create\_namespace) | Create the namespace if it does not yet exist | `bool` | `true` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | Helm release name | `string` | `"argocd"` | no |
| <a name="input_helm_repo_url"></a> [helm\_repo\_url](#input\_helm\_repo\_url) | ArgoCD helm repository | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_helm_timeout"></a> [helm\_timeout](#input\_helm\_timeout) | Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to 300 seconds. | `number` | `300` | no |
| <a name="input_helm_wait"></a> [helm\_wait](#input\_helm\_wait) | Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to true. | `bool` | `true` | no |
| <a name="input_ingress_class_name"></a> [ingress\_class\_name](#input\_ingress\_class\_name) | Name of ingress class to be used for creating argocd internal URL | `string` | `"internal-ingress"` | no |
| <a name="input_ingress_controller_namespace"></a> [ingress\_controller\_namespace](#input\_ingress\_controller\_namespace) | The ingress controllers namespace (it will be created if needed). | `string` | `"ingress"` | no |
| <a name="input_kubernetes_config_file"></a> [kubernetes\_config\_file](#input\_kubernetes\_config\_file) | The Kubernetes config-file to be used | `string` | `"~/.kube/config"` | no |
| <a name="input_monitoring_namespace"></a> [monitoring\_namespace](#input\_monitoring\_namespace) | The name of the monitoring namespace (it will be created if needed). | `string` | `"monitoring"` | no |
| <a name="input_parent_application_names"></a> [parent\_application\_names](#input\_parent\_application\_names) | Argocd parent application name | `list(string)` | <pre>[<br>  "applications-dev"<br>]</pre> | no |
| <a name="input_parent_application_projects"></a> [parent\_application\_projects](#input\_parent\_application\_projects) | Cluster endpoints destination | `list(string)` | <pre>[<br>  "dev"<br>]</pre> | no |
| <a name="input_parent_destination_servers"></a> [parent\_destination\_servers](#input\_parent\_destination\_servers) | Cluster endpoint destination | `string` | `"https://kubernetes.default.svc"` | no |
| <a name="input_parent_source_paths"></a> [parent\_source\_paths](#input\_parent\_source\_paths) | Argocd parent source path | `list(string)` | <pre>[<br>  "environments/dev"<br>]</pre> | no |
| <a name="input_parent_source_targetrevision"></a> [parent\_source\_targetrevision](#input\_parent\_source\_targetrevision) | branch of repo | `string` | `"HEAD"` | no |
| <a name="input_repo_url"></a> [repo\_url](#input\_repo\_url) | Your Github/Gitlab username to map with personal\_token | `string` | `"https://github.com/naviat/ipToolkits-applications"` | no |
| <a name="input_url"></a> [url](#input\_url) | ArgoCD internal URL | `string` | `"argocd.localhost"` | no |
| <a name="input_with_logging"></a> [with\_logging](#input\_with\_logging) | Whether or not to provision logging | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->