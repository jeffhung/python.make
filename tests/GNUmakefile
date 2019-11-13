
.PHONY: all
all: help

.PHONY: help
help:

.PHONY: clean
clean:
	rm -rf tmp.*;

.PHONY: distclean
distclean: clean
	rm -f  shunit2
	rm -rf shunit2-$(SHUNIT2_VERSION);
	rm -rf shunit2-$(SHUNIT2_VERSION).zip;

.PHONY: test
test: export PYTHON_CACHE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST)))).cache
test: prepare-shunit2
	LIB_DIR=shunit2/lib shunit2/test_runner -s /bin/bash

# ---------------------------------------------------------------------------

SHUNIT2_VERSION = 2.1.7
SHUNIT2_URL     = https://github.com/kward/shunit2/archive/v$(SHUNIT2_VERSION).zip

.PHONY: prepare-shunit2
prepare-shunit2: shunit2

shunit2:
	wget --content-disposition $(SHUNIT2_URL);  # will download shunit2-$(SHUNIT2_VERSION).zip
	unzip -q shunit2-$(SHUNIT2_VERSION).zip;
	ln -sf shunit2-$(SHUNIT2_VERSION) shunit2;

