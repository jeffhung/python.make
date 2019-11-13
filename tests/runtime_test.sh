#!/bin/sh

test_make_python_runtime() {
	workdir=`mktemp -d tmp.XXX`;
	cp ../python.make $workdir/
	pushd $workdir

	make -f python.make python-runtime
	assertTrue "runtime folder not created" "[ -d runtime ]";

	popd #$workdir
	rm -rf $workdir
}


# Load shUnit2.
. ./shunit2/shunit2

