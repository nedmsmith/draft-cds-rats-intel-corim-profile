LIBDIR := lib
include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif

CDDL_DIR := cddl/

# Import Intel Profile frags - no dependencies
include $(CDDL_DIR)profile-frags.mk
PROFILE_DEPS := $(addprefix $(CDDL_DIR), $(PROFILE_FRAGS))

define cddl_targets

$(drafts_html): $(CDDL_DIR)$(1)-autogen.cddl
$(drafts_txt): $(CDDL_DIR)$(1)-autogen.cddl
$(drafts_xml): $(CDDL_DIR)$(1)-autogen.cddl

$(CDDL_DIR)$(1)-autogen.cddl: $(2) 
	$(MAKE) -C $(CDDL_DIR)

endef # cddl_targets

$(eval $(call cddl_targets,irim,$(PROFILE_DEPS)))
$(eval $(call cddl_targets,ice,$(PROFILE_DEPS)))
$(eval $(call cddl_targets,ispdm,$(PROFILE_DEPS)))
$(eval $(call cddl_targets,intel-profile,$(PROFILE_DEPS)))

check-all: check-cddl check-examples

check-cddl:
	$(MAKE) -C $(CDDL_DIR) check-irim check-ice check-ispdm
	
check-examples: check-cddl
	$(MAKE) -C $(CDDL_DIR) check-irim-examples check-ice-examples check-ispdm-examples

# Build Intel Profile cddl (intel-profile.cddl)
check-intel-profile:
	$(MAKE) -C $(CDDL_DIR) check-imports check-intel-profile

clean:: ; $(MAKE) -C $(CDDL_DIR) clean

debug:: ; echo $(drafts_xml) $(drafts_html) $(drafts_txt)
