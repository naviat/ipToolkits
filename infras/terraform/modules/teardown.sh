#!/bin/sh

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
kind delete cluster

echo "Cleanup complete!"
