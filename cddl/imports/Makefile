.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

#check:: import-ce import-corim 
check:: ce-autogen.cddl

#CORIM_IDATE := 2025-03-31
#CE_IDATE := 2025-01-07

#$(eval $(call cddl_imports_template,ce,$(CE_IDATE)))
#$(eval $(call cddl_imports_template,corim,$(CORIM_IDATE)))

# Get concise-evidence import file ce-autogen.cddl - contains corim.cddl
github := https://github.com/TrustedComputingGroup/
ce_rel_dl := concise-evidence/releases/download/
ce_tag := cddl-nmsmith-release-test-1
ce_url := $(join $(github), $(join $(ce_rel_dl), $(ce_tag)))

ce-autogen.cddl: ; $(curl) -LO $(ce_url)/$@ ; cp $@ $@x ; $(cddlc) -tcddl -2 $@x > $@

CLEANFILES += ce-autogen.cddl
CLEANFILES += ce-autogen.cddlx

clean: ; rm $(CLEANFILES)