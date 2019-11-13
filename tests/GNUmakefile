
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
test: prepare-shunit2
	./runtime_test.sh

# ---------------------------------------------------------------------------

SHUNIT2_VERSION = 2.1.7
SHUNIT2_URL     = https://github.com/kward/shunit2/archive/v$(SHUNIT2_VERSION).zip

.PHONY: prepare-shunit2
prepare-shunit2: shunit2

shunit2: shunit2-$(SHUNIT2_VERSION)
	ln -sf shunit2-$(SHUNIT2_VERSION) shunit2;

shunit2-$(SHUNIT2_VERSION): shunit2-$(SHUNIT2_VERSION).zip
	unzip -q shunit2-$(SHUNIT2_VERSION).zip;

shunit2-$(SHUNIT2_VERSION).zip:
	wget --content-disposition $(SHUNIT2_URL)  # will download shunit2-$(SHUNIT2_VERSION).zip
#	tar -xf $(TOP_3RDPARTY_DIR)/shunit2-2.1.5.tgz;
#	( cd shunit2-*; patch -p0 < $(TOP_3RDPARTY_DIR)/shunit2-xml.patch; )

