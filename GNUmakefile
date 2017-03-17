# ----------------------------------------------------------------------------
# Configurations
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Main targets
# ----------------------------------------------------------------------------

.PHONY: all
all:

ifneq (,$(wildcard python.make))
include python.make
else
ifeq (,$(findstring python,$(MAKECMDGOALS)))
$(info Please run `make python` to bootstrap python.make.)
endif
.PHONY: python
python:
	wget --content-disposition https://bit.ly/python-make
endif

