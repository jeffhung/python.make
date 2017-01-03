# Copyright (c) 2015, Jeff Hung
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ----------------------------------------------------------------------------
# See: https://github.com/jeffhung/python.make
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Configurations
# ----------------------------------------------------------------------------

PYTHON_RUNTIME_DIR  ?= $(abspath runtime)
PYTHON_CACHE_DIR    ?= $(abspath .cache)

VIRTUALENV_VERSION  ?= 1.11.4
VIRTUALENV_URL      ?= https://pypi.python.org/packages/source/v/virtualenv/virtualenv-$(VIRTUALENV_VERSION).tar.gz

VIRTUALENV_RUN_BY   ?= python
VIRTUALENV_OPTS     ?=

PYTHON_PIP_CACHE_OPT += $(if $(shell [ `pip --version | cut -d\  -f2 | cut -d. -f1` -ge 8 ] && echo true),--cache-dir,--download-cache) $(PYTHON_CACHE_DIR)/pip


# ----------------------------------------------------------------------------
# Make targets of python.make
# ----------------------------------------------------------------------------

.PHONY: python-help
python-help:
	@echo "Usage: make [ TARGET ... ]";
	@echo "";
	@echo "These python-* make targets help you manage a python development environment";
	@echo "in local via virtualenv(1) and pip(1) inside it.";
	@echo "";
	@echo "  python-help       - show this help message";
	@echo "  python-runtime    - bootstrap a virtualenv runtime environment";
	@echo "  python-destroy    - destroy the virtualenv runtime environment";
	@echo "  python-pip        - run pip(1) command inside the virtualenv runtime";
	@echo "  python-shell      - enter python shell inside the virtualenv runtime";
	@echo "  python-exec       - run shell commands inside the virtualenv runtime";
	@echo "  python-%          - install the pip module which called %";
	@echo "  python-freeze     - save installed pip modules in requirements.txt";
	@echo "  python-module M   - generate boilerplate files for new module M";
	@echo "";
	@echo "The virtualenv (v$(VIRTUALENV_VERSION)) runtime environment is located at this path:";
	@echo "  $(PYTHON_RUNTIME_DIR)";

.PHONY: python-destroy
python-destroy:
	rm -rf $(PYTHON_RUNTIME_DIR);
#	rm -rf $(PYTHON_CACHE_DIR);

.PHONY: python-shell
python-shell: python-runtime
	. $(PYTHON_RUNTIME_DIR)/bin/activate; python;

.PHONY: python-runtime
python-runtime: $(PYTHON_RUNTIME_DIR)/bin/python

$(PYTHON_RUNTIME_DIR)/bin/python: $(PYTHON_CACHE_DIR)/virtualenv/virtualenv.py
	mkdir -p $(PYTHON_RUNTIME_DIR);
	$(VIRTUALENV_RUN_BY) $(PYTHON_CACHE_DIR)/virtualenv/virtualenv.py $(VIRTUALENV_OPTS) $(PYTHON_RUNTIME_DIR);

$(PYTHON_CACHE_DIR)/virtualenv/virtualenv.py: $(PYTHON_CACHE_DIR)/virtualenv-$(VIRTUALENV_VERSION).tar.gz
	mkdir -p $(PYTHON_CACHE_DIR)/virtualenv;
	# TODO: Replaces tar(1) with the built-in tarfile module of python.
	tar -zmx -C $(PYTHON_CACHE_DIR)/virtualenv --strip-components 1 -f $<;

$(PYTHON_CACHE_DIR)/virtualenv-$(VIRTUALENV_VERSION).tar.gz:
	# TODO: Replaces curl(1) with the built-in urllib2 module of python.
	mkdir -p $(PYTHON_CACHE_DIR);
	cd $(PYTHON_CACHE_DIR); curl --remote-name $(VIRTUALENV_URL);

# Eliminate the error message: "make: *** No rule to make target `..'.  Stop."
# Only when the first goal is python-pip or python-exec.
# TODO: Maybe we can apply to all python-* goals.
# XXX: if the goal is an existing file, will show the message: "make: `existing.json' is up to date."
ifneq (,$(filter $(firstword $(MAKECMDGOALS)),python-pip python-exec python-module))
%::
	@:;
endif

# XXX: Need to use `make python-exec -- --version` to specify options to python programs.
.PHONY: python-exec
python-exec: COMMAND := $(filter-out python-exec,$(MAKECMDGOALS))
python-exec:
	. $(PYTHON_RUNTIME_DIR)/bin/activate; $(COMMAND);

.PHONY: python-pip
python-pip: ARGS := $(filter-out python-pip,$(MAKECMDGOALS))
python-pip:
	. $(PYTHON_RUNTIME_DIR)/bin/activate; pip $(ARGS);

python-%: $(PYTHON_RUNTIME_DIR)/bin/python
	. $(PYTHON_RUNTIME_DIR)/bin/activate; \
	pip install $(PYTHON_PIP_CACHE_OPT) $(patsubst python-%,%,$@);

.PHONY: python-freeze
python-freeze:
	. $(PYTHON_RUNTIME_DIR)/bin/activate; pip freeze > requirements.txt;

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
python-module:        author        ?= $(if $(shell which git 2> /dev/null),$(shell git config user.name))
python-module:        email         ?= $(if $(shell which git 2> /dev/null),$(shell git config user.email))
python-module:        url           ?= $(if $(shell which git 2> /dev/null),https://github.com/$(shell git config github.user)/python-$(name))
python-module:        summary       ?= The python module $(name)
python-module:        description   ?=
python-module:        license       ?=
python-module:        copyright     ?= Copyright (c) $(shell date +%Y), $(author)
python-module: export INIT_PY       := $(PYTHON_MODULE_INIT_PY)
python-module: export SETUP_PY      := $(PYTHON_MODULE_SETUP_PY)
python-module: export MANIFEST_IN   := $(PYTHON_MODULE_MANIFEST_IN)
python-module: python-freeze
	$(MAKE) -f $(firstword $(MAKEFILE_LIST)) python-lice;
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
	. $(PYTHON_RUNTIME_DIR)/bin/activate; lice -o "$(author)" -p $(name) $(license) > LICENSE;
endif


# ----------------------------------------------------------------------------
# Packaging RPM from PyPI
# ----------------------------------------------------------------------------

# See: http://stackoverflow.com/a/3710342
first-letter = $(strip $(foreach a,a b c d e f g h i j k l m n o p q r s t u v w x y z,$(if $(1:$a%=),,$a)))

# See: http://stackoverflow.com/a/665045
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

PYPI_FILES_DIR ?= files
PYPI_WGET_OPTS ?= --no-check-certificate

## For example:
## $ make pypi-to-rpm PYPI_PKG_NAME=livereload PYPI_PKG_VERSION=2.4.1
##
## You will need to preinstall rpm-build, python-setuptools, and any BuildRequired packages.
##
.PHONY: pypi-to-rpm
pypi-to-rpm: export RPM_DISTS_DIR := $(PYPI_FILES_DIR)
pypi-to-rpm: export RPM_NAME      := python-$(subst _,-,$(call lc,$(PYPI_PKG_NAME)))
pypi-to-rpm: export RPM_VERSION   := $(PYPI_PKG_VERSION)
pypi-to-rpm: export RPM_PACKER    :=
pypi-to-rpm: export RPM_SOURCE0   := $(PYPI_FILES_DIR)/$(PYPI_PKG_NAME)-$(PYPI_PKG_VERSION).tar.gz
pypi-to-rpm: export RPM_BUILD_DIR := /tmp/rpm-make
pypi-to-rpm: rpm.make
	$(if $(PYPI_PKG_NAME),,   $(error "Missing PYPI_PKG_NAME"))
	$(if $(PYPI_PKG_VERSION),,$(error "Missing PYPI_PKG_VERSION"))
	# Download source tarball from PyPI
	$(MAKE) -f $(firstword $(MAKEFILE_LIST)) $(PYPI_FILES_DIR)/$(PYPI_PKG_NAME)-$(PYPI_PKG_VERSION).tar.gz
	# Build the RPM
	$(MAKE) -f rpm.make rpm-pack;

rpm.make:
	curl -L -o rpm.make https://bit.ly/rpm-make;

$(PYPI_FILES_DIR)/$(PYPI_PKG_NAME)-$(PYPI_PKG_VERSION).tar.gz:
	$(if $(PYPI_FILES_DIR),,  $(error "Missing PYPI_FILES_DIR"))
	$(if $(PYPI_PKG_NAME),,   $(error "Missing PYPI_PKG_NAME"))
	$(if $(PYPI_PKG_VERSION),,$(error "Missing PYPI_PKG_VERSION"))
	# Download source tarball from PyPI
	mkdir -p $(PYPI_FILES_DIR);
	PYPI_PKG_URL=`wget $(PYPI_WGET_OPTS) -O- https://pypi.python.org/simple/$(PYPI_PKG_NAME)/ \
	| sed -e 's,</h1>,\n,' | grep '^<a href=' \
	| grep $(PYPI_PKG_NAME)-$(PYPI_PKG_VERSION).tar.gz \
	| sed -e 's,^[^"]*",,' -e 's,".*$$,,' -e 's,^,https://pypi.python.org/packages/source/,'`; \
	wget $(PYPI_WGET_OPTS) -P $(PYPI_FILES_DIR) "$$PYPI_PKG_URL";

