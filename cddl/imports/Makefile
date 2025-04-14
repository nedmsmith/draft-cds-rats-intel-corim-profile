.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

CORIM := corim-autogen
CEAUTO := ce-autogen
COEV := coev

check:: get-$(CORIM)
check:: get-$(CEAUTO)
check:: get-$(COEV)

# Get corim-autogen.cddl
REPO := https://github.com/ietf-rats-wg/
DL := draft-ietf-rats-corim/releases/download/
TAG := cddl-8c267cd
$(eval $(call get_cddl_release,$(CORIM),$(REPO),$(DL),$(TAG)))
CLEANFILES += $(CORIM).cddl

# Get ce-autogen.cddl - contains corim.cddl
REPO := https://github.com/TrustedComputingGroup/
DL := concise-evidence/releases/download/
TAG := cddl-9a7d5cb
$(eval $(call get_cddl_release,$(CEAUTO),$(REPO),$(DL),$(TAG)))
CLEANFILES += $(CEAUTO).cddl

# Get coev.cddl
REPO := https://github.com/TrustedComputingGroup/
DL := concise-evidence/releases/download/
TAG := cddl-9a7d5cb
$(eval $(call get_cddl_release,$(COEV),$(REPO),$(DL),$(TAG)))

CLEANFILES += $(COEV).cddl

clean: ; rm $(CLEANFILES)