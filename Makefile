MVN := mvn
DOCKER := docker
TARGETS := clean compile test package install deploy

ARTIFACT_ID := $(shell $(MVN) help:evaluate -q -Dexpression=project.artifactId -DforceStdout 2>/dev/null)
VERSION := $(shell $(MVN) help:evaluate -q -Dexpression=project.version -DforceStdout 2>/dev/null)

ifeq ($(DEBUG),true)
MVNFLAGS := -X
endif

ifeq ($(CI),true)
MVNFLAGS += --batch-mode
endif

ifeq ($(SKIP_TESTS),true)
MVNFLAGS += -Dmaven.test.skip=true
endif

.PHONY: $(TARGETS) docker
build: clean compile

$(TARGETS):
	$(MVN) $(MVNFLAGS) $@

docker: package
	docker build -t $(ARTIFACT_ID):$(VERSION) --build-arg ARTIFACT_ID=$(ARTIFACT_ID) --build-arg VERSION=$(VERSION) .

