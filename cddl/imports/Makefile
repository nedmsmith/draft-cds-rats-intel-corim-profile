.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

#check:: import-ce import-corim 
check:: ce-autogen.cddl

# Get concise-evidence import file ce-autogen.cddl - contains corim.cddl
github := https://github.com/TrustedComputingGroup/
ce_rel_dl := concise-evidence/releases/download/
ce_tag := cddl-e812686 # Edit cddl-xxxxx to specify which release to import
ce_url := $(join $(github), $(join $(ce_rel_dl), $(ce_tag)))

ce-autogen.cddl: ; $(curl) -LO $(ce_url)/$@ ; grep -v '^@\.start\.@' $@ > $@.tmp ; mv $@.tmp $@

CLEANFILES += ce-autogen.cddl

clean: ; rm $(CLEANFILES)