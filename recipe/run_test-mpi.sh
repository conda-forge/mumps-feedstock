#!/bin/bash
set -ex

export CC=mpicc
export FC=mpifort

set -ex

cd examples

for p in s d c z; do
  # Check .pc file
  mumps="${p}mumps"
  pkg-config --exists --print-errors --debug ${mumps}
  pkg-config --validate --print-errors --debug ${mumps}
  $FC ${FFLAGS} ${LDFLAGS} $(pkg-config --cflags ${mumps}) $(pkg-config --libs ${mumps}) ${p}simpletest.F -o ${p}simpletest
done
$CC ${CFLAGS} ${LDFLAGS} $(pkg-config --cflags dmumps) $(pkg-config --libs dmumps) c_example.c -o c_example

mpiexec -n 2 ./ssimpletest < input_simpletest_real
mpiexec -n 2 ./dsimpletest < input_simpletest_real
mpiexec -n 2 ./csimpletest < input_simpletest_cmplx
mpiexec -n 2 ./zsimpletest < input_simpletest_cmplx
mpiexec -n 2 ./c_example
