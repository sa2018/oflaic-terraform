.DEFAULT_GOAL := help
.PHONY : docs

SHELL := /usr/bin/env bash
PATH := $(PWD)/bin:$(PATH)

MAKEFILE_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ("$(AWS_PROFILE)","")
$(error Please set environment variable AWS_PROFILE.)
endif


#################
##  Pre Ops    ##
#################
pre-plan: tf-fmt tf-validate tf-lint tf-security ## pre-plan operations
pre-apply: tf-compliance ## pre-apply operations
pre-commit: pre-plan tf-docs tf-format ## pre-commit operations

#################
##  Workspace  ##
#################

shell:
	@docker build - < $(PWD)/Dockerfile -t terraform-assignment >/dev/null
	@docker run --rm -e AWS_PROFILE=$(AWS_PROFILE) -v $(HOME)/.aws/credentials:/root/.aws/credentials -v $(PWD):/opt/workspace/ -it terraform-assignment bash

#################
##  Terraform  ##
#################

tf-security: _terraform_init ## tfsec runner
	@tfsec $(PWD)/src/ --concise-output --no-colour -e AWS002 && echo "TFSec : [OK]"

tf-format:_terraform_init  ## terraform fmt
	@terraform fmt -no-color -recursive $(PWD)/src/

tf-validate: _terraform_init ## terraform validate
	@cd $(PWD)/src && terraform validate ./  -no-color >/dev/null && echo "Validate : [OK]"

tf-compliance: _terraform_init ## terraform-compliance tests/compliance for the plan..out
	@terraform-compliance --features $(PWD)/tests/compliance/ --planfile $(PWD)/src/plan.out  -t /usr/local/bin/terraform && echo "Compliance : [OK]"

tf-lint: _terraform_init ## tflint
	@tflint -c $(PWD)/.tflint.hcl $(PWD)/src/ --no-color --format default && echo "TFLint : [OK]"

tf-fmt: _terraform_init ## terraform fmt -check
	@terraform fmt --check -recursive -diff $(PWD)/src/ && echo "Lint : [OK]"

tf-init: ## init terraform
	@echo "[INIT_FRESH] Initializing terraform"
	@cd $(PWD)/src/ && terraform init > /dev/null && echo "[INIT_FRESH] Complete"

tf-docs: _terraform_init ## generate terraform docs
	$(PWD)/bin/update-docs.sh

tf-plan: clean-plans pre-plan ## terraform plan with output file
	@cd $(PWD)/src/ && terraform plan -out plan.out

tf-apply:  _check-sure  pre-apply ## terraform apply from planned file
	@cd $(PWD)/src/ && terraform apply plan.out

tf-destroy:  _check-sure ## terraform destroy
	@cd $(PWD)/src/ && terraform destroy

#################
## Internal    ##
#################

_check-sure:
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

_terraform_init:
	@test -d $(PWD)/src/.terraform  || (echo "[TFINIT] terraform has not been initialized yet" && exit 1) && exit 0

#################
##  Clean      ##
#################

clean: clean-plans clean-error-state clean-state clean-terraform  ## clean all
	@echo "[CLEAN] Complete"

clean-plans: ## cleans plan files
	@echo "[CLEAN] Plan outputs"
	@rm -rf $(PWD)/src/plan.out  src/plan.out.json

clean-error-state: ## cleans state error file
	@echo "[CLEAN] State errors"
	@rm -rf $(PWD)/src/errored.tfstate

clean-state: ## cleans state file and backups
	@echo "[CLEAN] tfstate and backup"
	@rm -rf $(PWD)/src/terraform.tfstate src/terraform.tfstate.backup

clean-terraform: ## cleans .terraform workspace
	@echo "[CLEAN] .terraform"
	@rm -rf $(PWD)/src/.terraform

#################
##    Help     ##
#################

help: ## Available commands
	@printf "\033[32mMakefile : \033[0m\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\t\033[36m%-30s\033[0m %s\n", $$1, $$2}'
