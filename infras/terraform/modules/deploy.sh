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

# Create ArgoCD namespace
kubectl get namespace argocd || kubectl create namespace argocd

# Substitute variables in template
set -a
source .env
set +a
envsubst <config.yaml.tpl >values.yaml
envsubst <git-creds.yaml.tpl >git-creds.yaml

# Deploy with Helm
helm repo add argoproj https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argoproj/argo-cd -f values.yaml -n argocd

# Bootstrap app of apps
kubectl apply -f values/application-dev.yaml -n argocd
kubectl apply -f git-creds.yaml -n argocd
kubectl create secret docker-registry regcred \
	--docker-server=https://index.docker.io/v1/ \
	--docker-username=${DOCKERHUB_USER} \
	--docker-password=${DOCKERHUB_PAT} \
	--docker-email=haidv.ict@gmail.com \
	-n argocd

# DONE
echo "Provisioned!"
