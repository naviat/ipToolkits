# IP Toolkit

The IP Toolkit is a RESTful API service designed to provide various IP-related tools and utilities. This service is built to run efficiently in containerized environments, including Kubernetes, and offers a range of endpoints for different functionalities.

> <span style="color: red;">**IMPORTANT**</span>: Details for infrastructure in [INFRASTRUCTURE.md](./INFRASTRUCTURE.md).

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
- **CI Cache**: Improve the CI cache for npm and docker.

## Getting Started

- To get started with the IP Toolkit, clone this repository and follow the setup instructions provided in the [PREREQUISITES.md](./PREREQUISITES.md), [CICD.md](./CICD.md) and [README.md](./README.md) files. Ensure you have Terraform, helm, Docker and Kubernetes configured in your environment to deploy the service.
- To run `docker-compose`, see the [INFRASTRUCTURE.md](./INFRASTRUCTURE.md) for more details.

> <span style="color: red;">**IMPORTANT**</span>  I'm using Apple Silicon Macbook (M1 Pro), that why this project will have some tweak to run it in ARM chip. </span>

## Contribution

Contributions are welcome! If you have suggestions for new features, improvements, or find any issues, please open an issue or submit a pull request.

## License

This project is licensed under the Apache license. See the [LICENSE](./LICENSE) file for more details.
