#!/bin/bash

cp $RECIPE_DIR/Makefile.conda.SEQ ./Makefile.inc

make all

cp lib/*.a ${PREFIX}/lib
cp include/*.h ${PREFIX}/include

cd examples

mpi ./ssimpletest < input_simpletest_real
mpi ./dsimpletest < input_simpletest_real
mpi ./csimpletest < input_simpletest_cmplx
mpi ./zsimpletest < input_simpletest_cmplx
mpi ./c_example
