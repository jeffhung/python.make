# ----------------------------------------------------------------------------
# Configurations
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Main targets
# ----------------------------------------------------------------------------

.PHONY: all
all:

.PHONY: clean
clean:
	$(MAKE) -C tests clean

.PHONY: distclean
distclean: clean
	$(MAKE) -C tests distclean

.PHONY: test
test:
	$(MAKE) -C tests test

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

