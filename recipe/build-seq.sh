#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.SEQ ./Makefile.inc

make all PLAT=_seq

mkdir -p "${PREFIX}/lib"
mkdir -p "${PREFIX}/include/mumps_seq"

cp -v lib/*.a ${PREFIX}/lib/
cp -v libseq/*.a ${PREFIX}/lib/
cp -v libseq/mpi.h ${PREFIX}/include/mumps_seq/
cp -v libseq/mpif.h ${PREFIX}/include/mumps_seq/


cd examples

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
