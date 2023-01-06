.PHONY: pr docs test init apply verify teardown destroy e2e

pr: e2e

docs:
	terraform-docs markdown table .

test: verify

init: get
	RUN_STAGE=init go test -v ./test/integration

apply: init
	RUN_STAGE=apply go test -v ./test/integration

verify: init
	RUN_STAGE=verify go test -v ./test/integration

teardown: init
	RUN_STAGE=teardown go test -v ./test/integration

destroy: teardown

e2e: get
	go test -v ./test/integration

get:
	go get ./...
