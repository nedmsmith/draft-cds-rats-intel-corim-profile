.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

check:: import-ce import-corim

IDATE := 2025-01-07

$(eval $(call cddl_imports_template,ce,$(IDATE)))
$(eval $(call cddl_imports_template,corim,$(IDATE)))
