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

# Remove Terraform state files
info "Remove Terraform state files"
info "Deleting state file..."
rm -f *.tfstate *.tfstate.backup
rm -f *.hcl
# Delete the .terraform directory
info "Deleting generated terraform module..."
rm -rf .terraform
info "Delete the Kind cluster"
info "Get all running container IDs, stop and remove all..."
containers=$(docker ps -aq)

if [ -n "$containers" ]; then
	# Stop all running Docker containers
	docker stop $containers

	# Remove all Docker containers
	docker rm $containers
else
	info "No containers to stop or remove."
fi
# abort if exit code != 0
check_exit_code $?
info "Remove all network (very important) and prune Docker resource after delete kind cluster"
kind delete cluster -n kind-stakefish
docker network prune -f
docker system prune -f

# abort if exit code != 0
check_exit_code $?

info "BYE BYE!"
