#!/bin/bash
set -ex

export CC=mpicc
export FC=mpifort

set -ex

cd examples

for p in s d c z; do
  # Check .pc file
  mumps="${p}mumps"
  pkg-config --exists --print-errors ${mumps}
  pkg-config --validate --print-errors ${mumps}
  $FC ${FFLAGS} $(pkg-config --cflags ${mumps}) ${p}simpletest.F -o ${p}simpletest ${LDFLAGS} $(pkg-config --libs ${mumps})
done
$CC ${CFLAGS} $(pkg-config --cflags dmumps) c_example.c -o c_example ${LDFLAGS} $(pkg-config --libs dmumps) 

mpiexec -n 2 ./ssimpletest < input_simpletest_real
mpiexec -n 2 ./dsimpletest < input_simpletest_real
mpiexec -n 2 ./csimpletest < input_simpletest_cmplx
mpiexec -n 2 ./zsimpletest < input_simpletest_cmplx
mpiexec -n 2 ./c_example
