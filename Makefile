MVN := mvn
TARGETS := clean compile test package install deploy

.PHONY: $(TARGETS)

build: clean compile

$(TARGETS):
	$(MVN) $@
