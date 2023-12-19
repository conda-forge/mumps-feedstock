#!/bin/bash
set -e

cp "${RECIPE_DIR}/parent/Makefile.conda.PAR" Makefile.inc
cp -r "${RECIPE_DIR}/parent/tests-mpi" ./
cd tests-mpi

export CC=mpicc
export FC=mpifort

make all

mpiexec() {
    "${RECIPE_DIR}/parent/mpiexec.sh" "$@"
}

mpiexec -n 2 ./ssimpletest < input_simpletest_real
mpiexec -n 2 ./dsimpletest < input_simpletest_real
mpiexec -n 2 ./csimpletest < input_simpletest_cmplx
mpiexec -n 2 ./zsimpletest < input_simpletest_cmplx
mpiexec -n 2 ./c_example
