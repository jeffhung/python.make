#!/bin/bash

test_pip_search_ralc_not_target() {
	workdir=`mktemp -d tmp.${FUNCNAME[0]}.XX`;  # $workdir will be available globally
	cp ../python.make $workdir/;
	echo "include python.make" > $workdir/GNUmakefile;
	pushd $workdir;

	make python-runtime
	make python-pip search ralc
	assertTrue "ralc file shall not be created" "[ ! -f ralc ]";

	popd
	rm -rf $workdir;
}

test_pip_search_ralc_is_target() {
	workdir=`mktemp -d tmp.${FUNCNAME[0]}.XX`;  # $workdir will be available globally
	cp ../python.make $workdir/;
	echo "
ralc:
	touch \$@

include python.make
" > $workdir/GNUmakefile;
	pushd $workdir;

	make python-runtime
	make python-pip search ralc
	assertTrue "ralc file shall not be created" "[ ! -f ralc ]";

	popd
	rm -rf $workdir;
}

test_pip_search_ralc_is_file() {
	workdir=`mktemp -d tmp.${FUNCNAME[0]}.XX`;  # $workdir will be available globally
	cp ../python.make $workdir/;
	echo "include python.make" > $workdir/GNUmakefile;
	touch $workdir/ralc
	pushd $workdir;

	make python-runtime
	make python-pip search ralc
	assertTrue "ralc file shall not be removed" "[ -f ralc ]";

	popd
	rm -rf $workdir;
}

# Load shUnit2.
. ./shunit2/shunit2

