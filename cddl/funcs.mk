# $1: label
# $2: cddl fragments without start.cddl files
define cddl_autogen_template
check-$(1): $(1)-autogen.cddl

# Generate rfc9581 cddl into autoconfig - uncomment when debugged
#%.cddl: %.cddlx ; echo cddlc ; cddlc -2tcddl $$< > $$@

$(1)-autogen.cddl: $(2)
	echo ">>> generating" $(1)"-autogen.cddl"
	for f in $$^ ; do ( grep -v '^;' $$$$f ; echo ) ; done > $$@

.PHONY: check-$(1)
CLEANFILES += $(1)-autogen.cddl
endef # cddl_autogen_template

# $1: label
# $2: cddl fragments
# $3: diag test files
# $4: start string
define cddl_check_template

check-$(1): $(1)-autogen.cddl
	echo ">>> Checking cddl schema for:" $$< 
	$$(cddl) $$< g 1 | $$(diag2diag) -e

.PHONY: check-$(1)

$(1)-autogen.cddl: $(2)
	echo ">>> Creating autogen file : " $$@
	for f in $$^ ; do ( grep -v '^;' $$$$f ; echo ) ; done > $$@x
	$(cddlc) -2tcddl $$@x --start=$(4) > $$@ ; rm $$@x

CLEANFILES += $(1)-autogen.cddl
CLEANFILES += $(1)-autogen.cddlx

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

# $(1) - export label
# $(2) - cddl fragments 
# $(3) - export directory
# $(4) - import dependencies
define cddl_exp_template

check-$(1): $(3)$(1).cddl
	echo ">>> Creating exportable cddl file" $(3)$(1)".cddl from:" $(2) ;

.PHONY: check-$(1)

$(3)$(1).cddl: $(2)
	echo -e "; This cddl file depends on these cddl files: "$(4)"\n" > $$@
	echo ">>> writing exports " $(1) " to " $$@
	@for f in $$^ ; do \
		( grep -v '^;' $$$$f ; echo ) ; \
	done >> $$@

CLEANFILES += $(3)$(1).cddl

endef # cddl_exp_template
