VERSION ?= 0.0.1
GOTEST=go test
GOCOVER=go tool cover

ARCHES=amd64 arm64
PLATFORMS=darwin linux windows

BUILDARCH?=$(shell uname -m)
BUILDPLATFORM?=$(shell uname -s)
ifeq ($(BUILDARCH),aarch64)
  BUILDARCH=arm64
endif
ifeq ($(BUILDARCH),x86_64)
  BUILDARCH=amd64
endif
ifeq ($(BUILDPLATFORM),Darwin)
  BUILDPLATFORM=darwin
endif
ifeq ($(BUILDPLATFORM),Linux)
  BUILDPLATFORM=linux
endif
ifeq ($(BUILDPLATFORM),Win)
  BUILDPLATFORM=windows
endif

# unless otherwise set, I am building for my own architecture, i.e. not cross-compiling
ARCH ?= $(BUILDARCH)
PLATFORM ?= $(BUILDPLATFORM)

# canonicalized names for target architecture
ifeq ($(ARCH),aarch64)
  override ARCH=arm64
endif
ifeq ($(ARCH),x86_64)
  override ARCH=amd64
endif
ifeq ($(PLATFORM),Darwin)
  override PLATFORM=darwin
endif
ifeq ($(PLATFORM),Linux)
  override PLATFORM=linux
endif
ifeq ($(PLATFORM),Win)
  override PLATFORM=windows
endif

DEFAULTIMAGE ?= ghcr.io/funkymcb/funky-darts-api:$(VERSION)

.PHONY: all

all: clean test cover build

test:
	$(GOTEST) -v -coverprofile=coverage.txt ./...

cover: test
	$(GOCOVER) -func=coverage.out
	$(GOCOVER) -html=coverage.out

build:
	CGO_ENABLED=0 GOOS=$(PLATFORM) GOARCH=$(ARCH) GO111MODULE=on\
		go build -a -installsuffix cgo -o ./out/api cmd/api/main.go

package: PLATFORM="linux" ARCH="amd64"
package: build
	DOCKER_BUILDKIT=1 docker build -t $(DEFAULTIMAGE) .

clean:
	rm -f ./coverage.out ./out/*
	docker rmi $(DEFAULTIMAGE)
