#!/bin/bash
set -ex

# 'parent' is the _actual_ recipe dir. Not sure why
export RECIPE_DIR="${RECIPE_DIR}/parent"
cp -v "${RECIPE_DIR}/Makefile.conda.PAR" Makefile.inc
cd examples

export CC=mpicc
export FC=mpifort

# Makefile links libblas in tests, but it's not actually used
export LIBBLAS=""

make clean
make all

mpiexec -n 2 ./ssimpletest < input_simpletest_real
mpiexec -n 2 ./dsimpletest < input_simpletest_real
mpiexec -n 2 ./csimpletest < input_simpletest_cmplx
mpiexec -n 2 ./zsimpletest < input_simpletest_cmplx
mpiexec -n 2 ./c_example
