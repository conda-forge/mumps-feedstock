#!/bin/bash
set -e

cp "${RECIPE_DIR}/Makefile.conda.PAR" Makefile.inc
cp -r "${RECIPE_DIR}/tests" .
cd tests

export CC=mpicc
export FC=mpifort

make all

MPIEXEC="${RECIPE_DIR}/mpiexec.sh"
mpiexec() { $MPIEXEC $@; }

mpiexec -n 2 ./ssimpletest < input_simpletest_real
mpiexec -n 2 ./dsimpletest < input_simpletest_real
mpiexec -n 2 ./csimpletest < input_simpletest_cmplx
mpiexec -n 2 ./zsimpletest < input_simpletest_cmplx
mpiexec -n 2 ./c_example
