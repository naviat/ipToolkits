#!/bin/bash

# Set the script to exit immediately if any command exits with a non-zero status.
set -e

# Echo commands for debugging purposes
set -x

# Remove Terraform state files
rm -f *.tfstate *.tfstate.backup
rm -f *.hcl

# Delete the .terraform directory
rm -rf .terraform

# Delete the Kind cluster
# Get all running container IDs
containers=$(docker ps -aq)

if [ -n "$containers" ]; then
	# Stop all running Docker containers
	docker stop $containers

	# Remove all Docker containers
	docker rm $containers
else
	echo "No containers to stop or remove."
fi

docker network prune -f
docker system prune -f
kind delete cluster -n kind-stakefish

echo "Cleanup complete!"
