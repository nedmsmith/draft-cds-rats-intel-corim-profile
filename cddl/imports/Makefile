.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

check:: import-ce import-corim

CORIM_IDATE := 2025-03-31
CE_IDATE := 2025-01-07

$(eval $(call cddl_imports_template,ce,$(CE_IDATE)))
$(eval $(call cddl_imports_template,corim,$(CORIM_IDATE)))
