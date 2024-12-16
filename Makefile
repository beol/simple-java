MVN := mvn
DOCKER := docker
TARGETS := clean compile test package install deploy

ARTIFACT_ID := $(shell $(MVN) help:evaluate -q -Dexpression=project.artifactId -DforceStdout 2>/dev/null)
VERSION := $(shell $(MVN) help:evaluate -q -Dexpression=project.version -DforceStdout 2>/dev/null)


.PHONY: $(TARGETS) docker

build: clean compile

$(TARGETS):
	$(MVN) $@

target/$(ARTIFACT_ID)-$(VERSION).jar: package

docker: target/$(ARTIFACT_ID)-$(VERSION).jar
	docker build -t $(ARTIFACT_ID):$(VERSION) --build-arg ARTIFACT_ID=$(ARTIFACT_ID) --build-arg VERSION=$(VERSION) .

