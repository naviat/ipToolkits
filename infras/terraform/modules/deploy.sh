#!/bin/bash

# Define functions to log with different color backgrounds
log() { echo -e "\033[30;47m ${1} \033[0m ${@:2}"; }          # $1 background white
info() { echo -e "\033[48;5;28m ${1} \033[0m ${@:2}"; }       # $1 background green
warn() { echo -e "\033[48;5;202m ${1} \033[0m ${@:2}" >&2; }  # $1 background orange
error() { echo -e "\033[48;5;196m ${1} \033[0m ${@:2}" >&2; } # $1 background red

log START $(date "+%Y-%d-%m %H:%M:%S")
START=$SECONDS

# https://www.cyberciti.biz/faq/linux-bash-exit-status-set-exit-statusin-bash/
# exit code `0` : Success
# exit code `1` : Operation not permitted
check_exit_code() {
	[[ $1 == 0 ]] && return
	error ABORT exit code $1 returned
	info DURATION $(($SECONDS - $START)) seconds
	exit 0
}

# very very useful for saving THOUSANDS of megabytes on your computer
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Init terraform provider
info "Terraform init"
terraform init -upgrade
# abort if exit code != 0
check_exit_code $?

# Plan change
info "Terraform plan"
terraform plan -out=terraform.plan
# abort if exit code != 0
check_exit_code $?

# Apply change
info "Terraform apply"
terraform apply --auto-approve terraform.plan
# abort if exit code != 0
check_exit_code $?

# Create ArgoCD namespace
info "Creating ArgoCD namespace"
if kubectl get namespace argocd >/dev/null 2>&1; then
	info "Namespace 'argocd' already exists."
else
	kubectl create namespace argocd >/dev/null 2>&1 && info "Namespace created" || warn "Failed to create namespace 'argocd'"
fi

# Substitute variables in template
info "Substitute variables in template"
set -a
source .env
set +a
envsubst <config.yaml.tpl >values.yaml
envsubst <git-creds.yaml.tpl >git-creds.yaml
# abort if exit code != 0
check_exit_code $?
info "All manifests and values created!"

# Deploy with Helm
info "Deploy with ArgoCD Helm"
helm repo add argoproj https://argoproj.github.io/argo-helm
helm repo update >/dev/null 2>&1 && info "Helm repository has been updated successfully." || warn "Failed to update Helm repository."
helm upgrade --install argocd argoproj/argo-cd -f values.yaml -n argocd
# abort if exit code != 0
check_exit_code $?
info "ArgoCD created!"

# Bootstrap app of apps
info "Bootstrap ArgoCD App of Apps and DockerHub credentials"
kubectl apply -f values/application-dev.yaml -n argocd
kubectl apply -f git-creds.yaml -n argocd
# Check if the 'regcred' secret exists
if ! kubectl get secret regcred -n argocd >/dev/null 2>&1; then
	info "Creating docker secrets..."
	kubectl get secret regcred || kubectl create secret docker-registry regcred \
		--docker-server=https://index.docker.io/v1/ \
		--docker-username=${DOCKERHUB_USER} \
		--docker-password=${DOCKERHUB_PAT} \
		--docker-email=${DOCKER_MAIL} \
		-n argocd
else
	info "'regcred' secret already exists."
fi
# abort if exit code != 0
check_exit_code $?

# DONE
info PROVISIONED!!!

info "Run this command to show password for admin user in ArgoCD: 'kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 --decode; echo'"
