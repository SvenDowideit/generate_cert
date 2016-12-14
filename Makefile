VERSION := $(shell cat VERSION)
GITSHA1 := $(shell git rev-parse --short HEAD)
GOARCH := amd64
GOFLAGS := -ldflags "-X main.Version=$(VERSION) -X main.GitSHA=$(GITSHA1) -s"
PREFIX := generate_cert
DOCKER_IMAGE := generate_cert-golang
DOCKER_CONTAINER := generate_cert-cli-build
DOCKER_SRC_PATH := /go/src/github.com/SvenDowideit/generate_cert

default: dockerbuild
	@true # stop from matching "%" later


# Build binaries in Docker container. The `|| true` hack is a temporary fix for
# https://github.com/dotcloud/docker/issues/3986
dockerbuild: clean
	docker build -t "$(DOCKER_IMAGE)" .
	docker run --name "$(DOCKER_CONTAINER)" "$(DOCKER_IMAGE)" 
	docker cp "$(DOCKER_CONTAINER)":"$(DOCKER_SRC_PATH)"/$(PREFIX)-$(VERSION)-darwin-$(GOARCH) . || true
	docker cp "$(DOCKER_CONTAINER)":"$(DOCKER_SRC_PATH)"/$(PREFIX)-$(VERSION)-linux-$(GOARCH) . || true
	docker cp "$(DOCKER_CONTAINER)":"$(DOCKER_SRC_PATH)"/$(PREFIX)-$(VERSION)-windows-$(GOARCH).exe . || true
	docker rm "$(DOCKER_CONTAINER)"


# Remove built binaries and Docker container. Silent errors if container not found.
clean:
	rm -f $(PREFIX)-*
	docker rm "$(DOCKER_CONTAINER)" 2>/dev/null || true


release: all
	echo "release $(VERSION)"
	github-release release -u SvenDowideit -r generate_cert -t $(VERSION) --draft
	github-release upload -u SvenDowideit -r generate_cert -t $(VERSION) -f $(PREFIX)-$(VERSION)-darwin-$(GOARCH) -n $(PREFIX)-$(VERSION)-darwin-$(GOARCH)
	github-release upload -u SvenDowideit -r generate_cert -t $(VERSION) -f $(PREFIX)-$(VERSION)-linux-$(GOARCH) -n $(PREFIX)-$(VERSION)-linux-$(GOARCH)
	github-release upload -u SvenDowideit -r generate_cert -t $(VERSION) -f $(PREFIX)-$(VERSION)-windows-$(GOARCH).exe -n $(PREFIX)-$(VERSION)-windows-$(GOARCH).exe

all: darwin linux windows
	@true # stop "all" from matching "%" later

# Native Go build per OS/ARCH combo.
%:
	CGO_ENABLED=0 GOOS=$@ GOARCH=$(GOARCH) go build $(GOFLAGS) -a -installsuffix cgo -o $(PREFIX)-$(VERSION)-$@-$(GOARCH)$(if $(filter windows, $@),.exe)


# This binary will be installed at $GOBIN or $GOPATH/bin. Requires proper
# $GOPATH setup AND the location of the source directory in $GOPATH.
goinstall:
	go install $(GOFLAGS)

buildregistry:
	docker build -t registry registry

runregistry:
	docker run --rm -it --net host -p 5000:5000 registry
