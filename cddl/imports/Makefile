.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

#check:: import-ce import-corim 
check:: ce-autogen.cddl

# Get concise-evidence import file ce-autogen.cddl - contains corim.cddl
github := https://github.com/TrustedComputingGroup/
ce_rel_dl := concise-evidence/releases/download/
ce_tag := cddl-nmsmith-release-test-1
ce_url := $(join $(github), $(join $(ce_rel_dl), $(ce_tag)))

ce-autogen.cddl: ; $(curl) -LO $(ce_url)/$@ ; cp $@ $@x ; $(cddlc) -2tcddl $@x > $@

CLEANFILES += ce-autogen.cddl
CLEANFILES += ce-autogen.cddlx

clean: ; rm $(CLEANFILES)