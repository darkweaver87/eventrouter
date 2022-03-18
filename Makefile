# Copyright 2017 Heptio Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

TARGET = eventrouter
GOTARGET = github.com/openshift/$(TARGET)
BUILDMNT = /go/src/$(GOTARGET)
REGISTRY ?= gcr.io/traefiklabs/openshift
VERSION ?= v0.2.3
IMAGE = $(REGISTRY)/$(BIN)
BUILD_IMAGE ?= gcr.io/heptio-images/golang:1.9-alpine3.6
DOCKER ?= docker
DIR := ${CURDIR}

ifneq ($(VERBOSE),)
VERBOSE_FLAG = -v
endif
TESTARGS ?= $(VERBOSE_FLAG) -timeout 60s
TEST_PKGS ?= $(GOTARGET)/sinks/...
TEST = go test $(TEST_PKGS) $(TESTARGS)

all: container

container:
	$(DOCKER) buildx build --push --platform=linux/amd64,linux/arm64 -t $(REGISTRY)/$(TARGET):latest -t $(REGISTRY)/$(TARGET):$(VERSION) .

test:
	$(DOCKER_BUILD) '$(TEST)'

.PHONY: all local container

clean:
	rm -f $(TARGET)
	$(DOCKER) rmi $(REGISTRY)/$(TARGET):latest
	$(DOCKER) rmi $(REGISTRY)/$(TARGET):$(VERSION)
