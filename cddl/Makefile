.DEFAULT_GOAL := check

SHELL := /bin/bash

CORIM_DIR := ../draft-ietf-rats-corim/cddl/
CE_DIR := ../concise-evidence/
CE_CORIM_DIR := $(CE_DIR)draft-ietf-rats-corim/cddl/
CDDL_DIR := ./

include tools.mk

%.cbor: %.diag
	$(diag2cbor) $< > $@


check:: check-irim check-irim-examples
check:: check-corim check-corim-examples
check:: check-ice check-ice-examples
check:: check-ispdm check-ispdm-examples
check:: check-profile

# $1: label
# $2: cddl fragments
define cddl_autogen_template
check-profile: $(1)-autogen.cddl

$(1)-autogen.cddl: $(2)
	for f in $$^ ; do ( grep -v '^;' $$$$f ; echo ) ; done > $$@

CLEANFILES += $(1)-autogen.cddl
endef # cddl_autogen_template

# $1: label
# $2: cddl fragments
# $3: diag test files
define cddl_check_template

check-$(1): $(1)-autogen.cddl
	$$(cddl) $$< g 1 | $$(diag2diag) -e

.PHONY: check-$(1)

$(1)-autogen.cddl: $(2)
	for f in $$^ ; do ( grep -v '^;' $$$$f ; echo ) ; done > $$@

CLEANFILES += $(1)-autogen.cddl

check-$(1)-examples: $(1)-autogen.cddl $(3:.diag=.cbor)
	@for f in $(3:.diag=.cbor); do \
		echo ">> validating $$$$f against $$<" ; \
		$$(cddl) $$< validate $$$$f &>/dev/null || exit 1 ; \
		echo ">> saving prettified CBOR to $$$${f%.cbor}.pretty" ; \
		$$(cbor2pretty) $$$$f > $$$${f%.cbor}.pretty ; \
	done

.PHONY: check-$(1)-examples

CLEANFILES += $(3:.diag=.cbor)
CLEANFILES += $(3:.diag=.pretty)

endef # cddl_check_template

# Import profile frags - no dependencies
include $(CDDL_DIR)profile-frags.mk
PROFILE_DEPS := $(addprefix $(CDDL_DIR), $(PROFILE_FRAGS))

# Make corim dependencies

include $(CORIM_DIR)corim-frags.mk
CORIM_DEPS := $(addprefix $(CORIM_DIR), $(CORIM_FRAGS))

$(CORIM_DEPS): ; $(MAKE) -C $(CORIM_DIR)

include $(CE_DIR)ce-frags.mk
CE_DEPS := $(addprefix $(CE_DIR), $(CE_FRAGS))

$(CE_DEPS): ; $(MAKE) -C $(CE_DIR)

# Make Intel RIM - CoMID only
IRIM_FRAGS := $(CE_DIR)comid-x-start.cddl
IRIM_FRAGS += $(PROFILE_DEPS)
IRIM_FRAGS += $(CE_DEPS)
IRIM_FRAGS += $(CORIM_DEPS)

IRIM_EXAMPLES := $(wildcard examples/irim-*.diag)

$(eval $(call cddl_check_template,irim,$(IRIM_FRAGS),$(IRIM_EXAMPLES)))

# Make Intel CoRIM
CORIM_FRAGS := corim-start.cddl
CORIM_FRAGS += $(PROFILE_DEPS)
CORIM_FRAGS += $(CE_DEPS)
CORIM_FRAGS += $(CORIM_DEPS)

CORIM_EXAMPLES := $(wildcard examples/corim-*.diag)

$(eval $(call cddl_check_template,corim,$(CORIM_FRAGS),$(CORIM_EXAMPLES)))

# Make Intel Concise Evidence
ICE_FRAGS := $(CE_DIR)ce-start.cddl
ICE_FRAGS += $(PROFILE_DEPS)
ICE_FRAGS += $(CE_DEPS)
ICE_FRAGS += $(CORIM_DEPS)

ICE_EXAMPLES := $(wildcard examples/ice-*.diag)

$(eval $(call cddl_check_template,ice,$(ICE_FRAGS),$(ICE_EXAMPLES)))

# Make Intel SPDM Evidence
ISPDM_FRAGS := $(CE_DIR)spdm-start.cddl
ISPDM_FRAGS += $(PROFILE_DEPS)
ISPDM_FRAGS += $(CE_DEPS)
ISPDM_FRAGS += $(CORIM_DEPS)

ISPDM_EXAMPLES := $(wildcard examples/ispdm-*.diag)

$(eval $(call cddl_check_template,ispdm,$(ISPDM_FRAGS),$(ISPDM_EXAMPLES)))

$(eval $(call cddl_autogen_template,profile,$(PROFILE_FRAGS)))

clean: ; rm -f $(CLEANFILES)

clean-extra: clean ; $(MAKE) -C $(CE_DIR) clean ; $(MAKE) -C $(CE_CORIM_DIR) clean ; $(MAKE) -C $(CORIM_DIR) clean

# Extract the CBOR tags defined by CoRIM/CoMID (i.e., those in the 5xx space)
cbor-tags.txt: $(wildcard *.cddl) ; grep -h '#6\.5' *cddl | sort -u -t'=' -k2 > $@

debug: ; echo irim ; echo $(IRIM_FRAGS) ; echo ce-frags ; echo $(CE_FRAGS) ; echo ce-deps ; echo $(CE_DEPS)