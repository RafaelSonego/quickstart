PROVIDERS = rancher-common aws azure do gcp hcloud linode scw
CLOUD_PROVIDERS = aws azure do gcp hcloud linode scw

upgrade-targets = $(addprefix upgrade-, $(PROVIDERS))
docs-targets = $(addprefix docs-, $(PROVIDERS))
tfvars-targets = $(addprefix tfvars-, $(PROVIDERS))
fmt-targets = $(addprefix fmt-, $(PROVIDERS))
validate-targets = $(addprefix validate-, $(PROVIDERS))
plan-targets = $(addprefix plan-, $(CLOUD_PROVIDERS))

upgrade: $(upgrade-targets)
$(upgrade-targets): upgrade-%: %
	cd $< && terraform init -upgrade

docs: $(docs-targets)
$(docs-targets): docs-%: %
	cd $< && terraform-docs -c ../.terraform-docs-readme.yml .

tfvars: $(tfvars-targets)
$(tfvars-targets): tfvars-%: %
	cd $< && terraform-docs -c ../.terraform-docs-tfvars.yml .

fmt: $(fmt-targets)
$(fmt-targets): fmt-%: %
	cd $< && terraform fmt

validate: $(validate-targets)
$(validate-targets): validate-%: %
	cd $< && terraform validate

plan: $(plan-targets)
$(plan-targets): plan-%: %
	cd $< && terraform plan

.PHONY: test
test:
	cd test/ && go test -v -timeout 45m

.PHONY: clean
clean:
	rm */terraform.tfstate.backup
