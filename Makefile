.PHONY: fmt validate test docs

fmt:
	terraform fmt -recursive

validate:
	terraform init -backend=false
	terraform validate

test:
	terraform test -verbose

docs:
	terraform-docs markdown table --output-file README.md --output-mode inject .
