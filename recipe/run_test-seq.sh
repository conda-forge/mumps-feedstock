#!/bin/bash
set -ex

# 'parent' is the _actual_ recipe dir. Not sure why
export RECIPE_DIR="${RECIPE_DIR}/parent"
cp -v "${RECIPE_DIR}/Makefile.conda.SEQ" Makefile.inc
cd examples

# Makefile links libblas in tests, but it's not actually used
export LIBBLAS=""

make clean
make all

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
