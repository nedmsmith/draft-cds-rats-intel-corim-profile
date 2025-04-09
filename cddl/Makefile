.DEFAULT_GOAL := check

SHELL := /bin/bash

CDDL_DIR := ./
IMPORTS_DIR := $(CDDL_DIR)imports/
EXPORTS_DIR := $(CDDL_DIR)

include tools.mk
include funcs.mk

%.cbor: %.diag
	$(diag2cbor) $< > $@

check:: check-irim check-irim-examples
check:: check-corim check-corim-examples
check:: check-ice check-ice-examples
check:: check-ispdm check-ispdm-examples
check:: check-profile
check:: export-intel-profile

# Get profile frags - no dependencies
include $(CDDL_DIR)profile-frags.mk
PROFILE_DEPS := $(addprefix $(CDDL_DIR), $(PROFILE_FRAGS))

# Get imports frags - no dependencies
include $(IMPORTS_DIR)import-frags.mk
IMPORT_DEPS := $(addprefix $(IMPORTS_DIR), $(IMPORT_FRAGS))

# Make Intel RIM (irim) - CoMID only
IRIM_START := "concise-mid-tag"
IRIM_FRAGS += $(PROFILE_DEPS)
IRIM_FRAGS += $(IMPORT_DEPS)

IRIM_EXAMPLES := $(wildcard examples/irim-*.diag)

$(eval $(call cddl_check_template,irim,$(IRIM_FRAGS),$(IRIM_EXAMPLES),$(IRIM_START)))

# Make Intel CoRIM (corim)
CORIM_START := "corim"
CORIM_FRAGS += $(PROFILE_DEPS)
CORIM_FRAGS += $(IMPORT_DEPS)

CORIM_EXAMPLES := $(wildcard examples/corim-*.diag)

$(eval $(call cddl_check_template,corim,$(CORIM_FRAGS),$(CORIM_EXAMPLES),$(CORIM_START)))

# Make Intel Concise Evidence (ice)
ICE_START := "concise-evidence"
ICE_FRAGS += $(PROFILE_DEPS)
ICE_FRAGS += $(IMPORT_DEPS)

ICE_EXAMPLES := $(wildcard examples/ice-*.diag)

$(eval $(call cddl_check_template,ice,$(ICE_FRAGS),$(ICE_EXAMPLES),$(ICE_START)))

# Make Intel SPDM Evidence (ispdm)
ISPDM_START := "spdm-toc"
ISPDM_FRAGS += $(PROFILE_DEPS)
ISPDM_FRAGS += $(IMPORT_DEPS)

ISPDM_EXAMPLES := $(wildcard examples/ispdm-*.diag)

$(eval $(call cddl_check_template,ispdm,$(ISPDM_FRAGS),$(ISPDM_EXAMPLES),$(ISPDM_START)))

# Make the profile autogen file
$(eval $(call cddl_autogen_template,profile,$(PROFILE_FRAGS)))

# Make exports file
$(eval $(call cddl_exp_template,intel-profile,$(PROFILE_DEPS),$(EXPORTS_DIR)))

$(IMPORT_DEPS): check-imports

check-imports:
	$(MAKE) -C $(IMPORTS_DIR)

clean: ; rm -f $(CLEANFILES) ; $(MAKE) -C $(IMPORTS_DIR) clean

# Extract the CBOR tags defined by CoRIM/CoMID (i.e., those in the 5xx space)
cbor-tags.txt: $(wildcard *.cddl) ; grep -h '#6\.5' *cddl | sort -u -t'=' -k2 > $@

debug: ; echo irim ; echo $(IRIM_FRAGS)

code-pts: $(wildcard *.cddl) ; grep -v '^;' *.cddl | grep -E -h -o ': \-[0-9]{1,3}|= \-[0-9]{1,3}' | uniq | sort -u -t':' -t'='