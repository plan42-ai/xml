BASE_VERSION := 1.25.5

ifdef GITHUB_RUN_NUMBER
    ifeq ($(GITHUB_RUN_ATTEMPT), 1)
    	TAG_VERSION := $(GITHUB_RUN_NUMBER)
	else
        TAG_VERSION := $(GITHUB_RUN_NUMBER).$(GITHUB_RUN_ATTEMPT)
    endif
else
	TAG_VERSION := $(USER).test-$(shell TZ=America/Los_Angeles date '+%Y-%m-%d.%s')
endif

VERSION := $(BASE_VERSION)-$(TAG_VERSION)

.PHONY: build
build:
	go build ./...

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: test
test:
	go test -v ./...

.PHONY: tag
tag:
	git tag v$(VERSION)
	git push origin v$(VERSION)