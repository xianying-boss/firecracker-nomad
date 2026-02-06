.PHONY: all init firecracker nomad images jobs status clean help

all: init firecracker nomad images jobs
	@echo "All installation steps completed!"

help:
	@echo "Available targets:"
	@echo "  init        - Check prerequisites and setup permissions (Step 1)"
	@echo "  firecracker - Install Firecracker binary (Step 2)"
	@echo "  nomad       - Install and configure Nomad with Firecracker driver (Step 3)"
	@echo "  images      - Prepare kernel and images directory (Step 4)"
	@echo "  jobs        - Create sample Firecracker job (Step 5)"
	@echo "  all         - Run all steps (1-5)"
	@echo "  status      - Show monitoring commands"

init:
	sudo bash 01-init/run.sh

firecracker:
	sudo bash 02-firecracker/run.sh

nomad:
	sudo bash 03-nomad/run.sh

images:
	sudo bash 04-images/run.sh

jobs:
	sudo bash 05-jobs/run.sh

status:
	bash scripts/monitoring.sh

clean:
	@echo "Warning: This will not uninstall software, but will remove local build artifacts if any."
