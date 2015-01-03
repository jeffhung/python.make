# ----------------------------------------------------------------------------
# Configurations
# ----------------------------------------------------------------------------

TOP_DIR             ?= $(abspath .)
RUNTIME_DIR         ?= $(TOP_DIR)/runtime
CACHE_DIR           ?= $(TOP_DIR)/.cache

VIRTUALENV_VERSION  ?= 1.11.4
VIRTUALENV_URL      ?= https://pypi.python.org/packages/source/v/virtualenv/virtualenv-$(VIRTUALENV_VERSION).tar.gz


# ----------------------------------------------------------------------------
# Basic targets
# ----------------------------------------------------------------------------

.PHONY: all
all: help

.PHONY: help
help:
	@echo "Usage: make [ TARGET ... ]";
	@echo "";
	@echo "TARGET:";
	@echo "";
	@echo "  help       - show this help message";
	@echo "  runtime    - create the runtime environment";
	@echo "  clean      - delete generated files";
	@echo "";
	@echo "Default TARGET is 'help'.";
	@echo "";

.PHONY: clean
clean:

.PHONY: distclean
distclean: clean
	rm -rf $(RUNTIME_DIR);
#	rm -rf $(CACHE_DIR);


# ----------------------------------------------------------------------------
# Main targets
# ----------------------------------------------------------------------------

.PHONY: runtime
runtime: python-runtime


# ----------------------------------------------------------------------------
# Special targets
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Targets for building Python Development Environment
# ----------------------------------------------------------------------------

.PHONY: python-shell
python-shell: python-runtime
	. $(RUNTIME_DIR)/bin/activate; python;

.PHONY: python-runtime
python-runtime: $(RUNTIME_DIR)/bin/python

$(RUNTIME_DIR)/bin/python: $(CACHE_DIR)/virtualenv/virtualenv.py
	# TODO: Replaces tar(1) with the built-in os.makedirs() function of python.
	mkdir -p $(RUNTIME_DIR);
	python $(CACHE_DIR)/virtualenv/virtualenv.py $(RUNTIME_DIR);

$(CACHE_DIR)/virtualenv/virtualenv.py: $(CACHE_DIR)/virtualenv-$(VIRTUALENV_VERSION).tar.gz
	mkdir -p $(CACHE_DIR)/virtualenv;
	# TODO: Replaces tar(1) with the built-in tarfile module of python.
	tar -zmx -C $(CACHE_DIR)/virtualenv --strip-components 1 -f $<;

$(CACHE_DIR)/virtualenv-$(VIRTUALENV_VERSION).tar.gz:
	# TODO: Replaces curl(1) with the built-in urllib2 module of python.
	mkdir -p $(CACHE_DIR);
	cd $(CACHE_DIR); curl --remote-name $(VIRTUALENV_URL);

# Eliminate the error message: "make: *** No rule to make target `..'.  Stop."
# Only when the first goal is python-pip or python-run.
# TODO: Maybe we can apply to all python-* goals.
# XXX: if the goal is an existing file, will show the message: "make: `existing.json' is up to date."
ifneq (,$(filter $(firstword $(MAKECMDGOALS)),python-pip python-run))
%::
	@:;
endif

# XXX: Need to use `make python-run -- --version` to specify options to python programs.
.PHONY: python-run
python-run: COMMAND := $(filter-out python-run,$(MAKECMDGOALS))
python-run:
	. $(RUNTIME_DIR)/bin/activate; $(COMMAND);

.PHONY: python-pip
python-pip: ARGS := $(filter-out python-pip,$(MAKECMDGOALS))
python-pip:
	. $(RUNTIME_DIR)/bin/activate; pip $(ARGS);

python-%: $(RUNTIME_DIR)/bin/python
	. $(RUNTIME_DIR)/bin/activate; \
	pip install --download-cache $(CACHE_DIR)/pip $(patsubst python-%,%,$@);


