#!/bin/bash
env | sort

cp $RECIPE_DIR/Makefile.conda.PAR ./Makefile.inc

if [ `uname` == "Darwin" ]; then
  sed -i'' -e 's/gcc/clang/g' ./Makefile.inc
  function mpi() {
    mpiexec -n 4 $@
  }
else
  function mpi() {
    # skip mpi on circle-ci due to output problems
    $@
  }
fi

make all

cp lib/*.a ${PREFIX}/lib
cp include/*.h ${PREFIX}/include

cd examples

mpi ./ssimpletest < input_simpletest_real
mpi ./dsimpletest < input_simpletest_real
mpi ./csimpletest < input_simpletest_cmplx
mpi ./zsimpletest < input_simpletest_cmplx
mpi ./c_example
