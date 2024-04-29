#!/bin/bash
set -ex

cp "${RECIPE_DIR}/parent/Makefile.conda.SEQ" Makefile.inc
cd examples

export LIBEXT_SHARED=${SHLIB_EXT}
export PLAT="_seq"

make clean
make all

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
