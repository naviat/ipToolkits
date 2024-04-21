# IP Toolkit

![CI](https://github.com/naviat/ipToolkits/actions/workflows/ci.yml/badge.svg)
![TF Docs](https://github.com/naviat/ipToolkits/actions/workflows/terraform-docs-ci.yml/badge.svg)

The IP Toolkit is a RESTful API service designed to provide various IP-related tools and utilities. This service is built to run efficiently in containerized environments, including Kubernetes, and offers a range of endpoints for different functionalities.

> [!IMPORTANT]
> Be sure to read [our documentation][documentation::web]. It guides the initial setup of your mail server. After setup `/etc/hosts` to use `.localhost` domain, you can access using `https://iptoolkits.localhost/docs/`. [More detail in TERRAFORM.md](./TERRAFORM.md#installation)

> [!IMPORTANT]
> Details for infrastructure in [INFRASTRUCTURE.md](./INFRASTRUCTURE.md).

> [!IMPORTANT]
> [19 Apr 2024] You cannot see the updated docker image in the [ipToolkits-applications](https://github.com/naviat/ipToolkits-applications/blob/main/apps/iptoolkits/.argocd-source-iptoolkits-dev.yaml) repository, as my DockerHub account is free and I have exceeded the pull rate limit.

## Features

- **Version and Environment Info**: A root endpoint (`/`) that returns the current version of the API, the current timestamp, and a boolean indicating if the service is running in a Kubernetes environment.
- **IPv4 Address Lookup**: An endpoint to look up IPv4 addresses and return information about them.
- **IPv4 Address Validation**: An endpoint to validate IPv4 addresses.
- **Query History Retrieval**: An endpoint to retrieve the history of queries made to the service.

## TODO

- **MongoDB Cluster in Kubernetes**: Transition the MongoDB database to a *clustered environment within Kubernetes, enabled SSL connection* to enhance scalability, security and reliability.
- **Expand Test Coverage**: Develop and implement additional test cases to cover all endpoints and possible scenarios, ensuring robustness and reliability.
- **Automatic Database Backup**: Implement an automatic backup solution for the MongoDB database to prevent data loss and ensure data integrity.
- **Frontend Interface**: Develop a frontend interface to provide an easier and more intuitive way for users to interact with the IP Toolkit services.
- **Cleanup history API**: [Optional] Reject requests to `/v1/tools/lookup` API endpoint rejects requests for the same domain within 10 minutes.
- **Tracing**: Enabling tracing with OpenTelemetry and integrating it with Grafana Beyla.
- **CI Cache** [DONE]: Improve the CI cache for npm and docker.
- **SSO** for all platforms.
- **Terratest**: update terratest for current terraform, also expand current terraform code to use Terragrunt if moving to any cloud provider with multiple services.
- **Autoscaling**: apply autoscaling using KEDA along with ClusterScaler/Karpenter.
- **Alerting**: integrate with Grafana OnCall to establish a 3-level support system.

## Getting Started

- To get started with the IP Toolkit, clone this repository and follow the setup instructions provided in the [PREREQUISITES.md](./PREREQUISITES.md), [CICD.md](./CICD.md) and [README.md](./README.md) files. Ensure you have Terraform, helm, Docker and Kubernetes configured in your environment to deploy the service.
- To run `docker-compose`, see the [INFRASTRUCTURE.md](./INFRASTRUCTURE.md) for more details.

> [!IMPORTANT]
> I'm using an Apple Silicon Macbook (M1 Pro), that why this project will have some tweak to run it in ARM chip. </span>

## Contribution

Contributions are welcome! If you have suggestions for new features, or improvements, or find any issues, please open an issue or submit a pull request.

## License

This project is licensed under the Apache license. See the [LICENSE](./LICENSE) file for more details.
