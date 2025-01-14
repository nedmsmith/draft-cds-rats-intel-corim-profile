.DEFAULT_GOAL := check

SHELL := /bin/bash

CDDL_DIR := ./
IMPORTS_DIR := $(CDDL_DIR)imports/
EXPORTS_DIR := $(CDDL_DIR)#exports/

include tools.mk
include funcs.mk

%.cbor: %.diag
	$(diag2cbor) $< > $@

check:: check-imports
check:: check-irim check-irim-examples
check:: check-corim check-corim-examples
check:: check-ice check-ice-examples
check:: check-ispdm check-ispdm-examples
check:: check-profile
check:: exp-intel-profile-export

# Import profile frags - no dependencies
include $(CDDL_DIR)profile-frags.mk
PROFILE_DEPS := $(addprefix $(CDDL_DIR), $(PROFILE_FRAGS))

#
# manually link corim import file to imports/corim-import.cddl
#
CORIM_IMPORT := $(addprefix $(IMPORTS_DIR), corim-import.cddl )

#
# manually link concise-evidence import file to imports/ce-import.cddl
#
CE_IMPORT := $(addprefix $(IMPORTS_DIR), ce-import.cddl )

# Make Intel RIM - CoMID only
IRIM_FRAGS := comid-x-start.cddl
IRIM_FRAGS += $(PROFILE_DEPS)
IRIM_FRAGS += $(CE_IMPORT)
IRIM_FRAGS += $(CORIM_IMPORT)

IRIM_EXAMPLES := $(wildcard examples/irim-*.diag)

$(eval $(call cddl_check_template,irim,$(IRIM_FRAGS),$(IRIM_EXAMPLES)))

# Make Intel CoRIM
CORIM_FRAGS := corim-start.cddl
CORIM_FRAGS += $(PROFILE_DEPS)
CORIM_FRAGS += $(CE_IMPORT)
CORIM_FRAGS += $(CORIM_IMPORT)

CORIM_EXAMPLES := $(wildcard examples/corim-*.diag)

$(eval $(call cddl_check_template,corim,$(CORIM_FRAGS),$(CORIM_EXAMPLES)))

# Make Intel Concise Evidence
ICE_FRAGS := ce-start.cddl
ICE_FRAGS += $(PROFILE_DEPS)
ICE_FRAGS += $(CE_IMPORT)
ICE_FRAGS += $(CORIM_IMPORT)

ICE_EXAMPLES := $(wildcard examples/ice-*.diag)

$(eval $(call cddl_check_template,ice,$(ICE_FRAGS),$(ICE_EXAMPLES)))

# Make Intel SPDM Evidence
ISPDM_FRAGS := spdm-start.cddl
ISPDM_FRAGS += $(PROFILE_DEPS)
ISPDM_FRAGS += $(CE_IMPORT)
ISPDM_FRAGS += $(CORIM_IMPORT)

ISPDM_EXAMPLES := $(wildcard examples/ispdm-*.diag)

$(eval $(call cddl_check_template,ispdm,$(ISPDM_FRAGS),$(ISPDM_EXAMPLES)))

# Make the profile autogen file
$(eval $(call cddl_autogen_template,profile,$(PROFILE_FRAGS)))

# Make exports file
$(eval $(call cddl_exp_template,intel-profile-export,$(PROFILE_DEPS),$(EXPORTS_DIR)))

check-imports: #$(IMPORT_DEPS)
	$(MAKE) -C $(IMPORTS_DIR)

clean: ; rm -f $(CLEANFILES)

# Extract the CBOR tags defined by CoRIM/CoMID (i.e., those in the 5xx space)
cbor-tags.txt: $(wildcard *.cddl) ; grep -h '#6\.5' *cddl | sort -u -t'=' -k2 > $@

debug: ; echo irim ; echo $(IRIM_FRAGS)

code-pts: $(wildcard *.cddl) ; grep -v '^;' *.cddl | grep -E -h -o ': \-[0-9]{1,3}|= \-[0-9]{1,3}' | uniq | sort -u -t':' -t'='