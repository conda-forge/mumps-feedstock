#!/bin/bash
set -ex

cp "${RECIPE_DIR}/parent/Makefile.conda.PAR" Makefile.inc
cd examples

export LIBEXT_SHARED=${SHLIB_EXT}
export CC=mpicc
export FC=mpifort

make clean
make all

mpiexec() {
    "${RECIPE_DIR}/parent/mpiexec.sh" "$@"
}

mpiexec -n 2 ./ssimpletest < input_simpletest_real
mpiexec -n 2 ./dsimpletest < input_simpletest_real
mpiexec -n 2 ./csimpletest < input_simpletest_cmplx
mpiexec -n 2 ./zsimpletest < input_simpletest_cmplx
mpiexec -n 2 ./c_example
