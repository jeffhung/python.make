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
ifneq (,$(filter $(firstword $(MAKECMDGOALS)),python-pip python-run python-module))
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

.PHONY: python-freeze
python-freeze:
	. $(RUNTIME_DIR)/bin/activate; pip freeze > requirements.txt;

define PYTHON_MODULE_INIT_PY
# -*- coding: utf-8

"""
$(description)
"""

__version__     = '$(version)'
__author__      = '$(author)'
__email__       = '$(email)'
__license__     = '$(license)'
__copyright__   = '$(copyright)'

if __name__ == '__main__':
    pass

endef

define PYTHON_MODULE_SETUP_PY
# -*- coding: utf-8

from setuptools import setup, find_packages
from pip.req import parse_requirements

import $(name)

setup(
    name='$(name)',
    version=$(name).__version__,
    author=$(name).__author__,
    author_email=$(name).__email__,
    url='$(url)',
    description='$(summary)',
    long_description=$(name).__doc__,
    packages=find_packages(),
    install_requires=[str(r.req) for r in parse_requirements('requirements.txt')]
    classifiers=[
        'Development Status :: 1 - Planning',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: Implementation :: PyPy',
        'Topic :: Documentation',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ]
)

endef

define PYTHON_MODULE_MANIFEST_IN
include requirements.txt

endef

# XXX  This will forbid installing the 'module' package.
#      Please use `make python-pip install module` instead.
# XXX  When creating the script files, here we use >> instead of > to prevent
#      accidentally overriding existing content, if there's any.
# XXX  See http://stackoverflow.com/a/649462 for multiline variables in make.
# TODO Use user.name and user.email settings in git config for default values.
# XXX  Currently lice will be included in requirements.txt. We should install
#      python-lice in another place to avoid polluting current virtualenv
#      environment.
# TODO Add license header in generated script files.
.PHONY: python-module
python-module:        ARGS          := $(filter-out python-module,$(MAKECMDGOALS))
python-module:        name          := $(firstword $(ARGS))
python-module:        version       ?= 0.0.1
python-module:        author        ?= $(shell git config user.name)
python-module:        email         ?= $(shell git config user.email)
python-module:        url           ?= https://github.com/$(shell git config github.user)/python-$(name)
python-module:        summary       ?= The python module $(name)
python-module:        description   ?=
python-module:        license       ?=
python-module:        copyright     ?= Copyright (c) $(shell date +%Y), $(author)
python-module: export INIT_PY       := $(PYTHON_MODULE_INIT_PY)
python-module: export SETUP_PY      := $(PYTHON_MODULE_SETUP_PY)
python-module: export MANIFEST_IN   := $(PYTHON_MODULE_MANIFEST_IN)
python-module: python-freeze
	$(MAKE) python-lice;
	@echo "Making new python module '$(ARGS)'...";
	mkdir -p $(name);
	@echo "Generate $(name)/__init__.py";
	@echo "$$INIT_PY"       >> $(name)/__init__.py;
	@echo "Generate setup.py";
	@echo "$$SETUP_PY"      >> setup.py;
	@echo "Generate MANIFEST.in";
	@echo "$$MANIFEST_IN"   >> MANIFEST.in;
ifneq ($(license),)
	@echo "Generate LICENSE";
	. $(RUNTIME_DIR)/bin/activate; lice -o "$(author)" -p $(name) $(license) > LICENSE;
endif

