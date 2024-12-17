MVN := mvn
DOCKER := docker
TARGETS := clean compile test package install deploy

ARTIFACT_ID := $(shell $(MVN) help:evaluate -q -Dexpression=project.artifactId -DforceStdout 2>/dev/null)
VERSION := $(shell $(MVN) help:evaluate -q -Dexpression=project.version -DforceStdout 2>/dev/null)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
PATCH := $(word 3,$(subst ., ,$(VERSION)))

ifeq ($(DEBUG),true)
MVNFLAGS := -X
endif

ifeq ($(CI),true)
MVNFLAGS += --batch-mode
endif

ifeq ($(SKIP_TESTS),true)
MVNFLAGS += -Dmaven.test.skip=true
endif

.PHONY: $(TARGETS) version docker venv bump
build: clean package

$(TARGETS):
	$(MVN) $(MVNFLAGS) $@

version:
	$(MVN) $(MVNFLAGS) versions:set -DnewVersion=$(MAJOR).$(MINOR).$$((1+$(PATCH)))
	
docker: package
	docker build -t $(ARTIFACT_ID):$(VERSION) --build-arg ARTIFACT_ID=$(ARTIFACT_ID) --build-arg VERSION=$(VERSION) .

venv:
	( \
		python3 -m venv .venv; \
		. .venv/bin/activate; \
		pip3 install -r common-build-tools/requirements.txt; \
	)

bump: venv
	@( \
		. .venv/bin/activate; \
		./common-build-tools/scripts/bump-patch; \
	)
