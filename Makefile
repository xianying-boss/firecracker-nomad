.PHONY: all init build-image apply deploy-jobs status help

all: init build-image apply deploy-jobs
	@echo "All steps completed!"

help:
	@echo "Available targets:"
	@echo "  init         - Initialize and check prerequisites"
	@echo "  build-image  - Install Firecracker and Nomad binaries"
	@echo "  apply        - Start Nomad and prepare images"
	@echo "  deploy-jobs  - Deploy sample Firecracker job"
	@echo "  status       - Show monitoring commands"

init:
	sudo bash init/setup.sh

build-image:
	sudo bash nomad-cluster-disk-image/setup/install-firecracker.sh
	sudo bash nomad-cluster-disk-image/setup/install-nomad.sh

apply:
	sudo bash nomad-cluster/run-nomad.sh
	sudo bash nomad-cluster/prepare-images.sh

deploy-jobs:
	sudo bash nomad/deploy-sample-job.sh

status:
	bash scripts/status.sh
