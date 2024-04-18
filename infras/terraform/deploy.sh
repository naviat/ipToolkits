#!/bin/sh

# Set the script to exit immediately if any command exits with a non-zero status.
set -e

# Echo commands for debugging purposes
set -x

# Init terraform provider
terraform init

# Plan change
terraform plan

# Apply change
terraform apply --auto-approve

echo "Provisioned!"
