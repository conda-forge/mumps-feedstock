#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.SEQ ./Makefile.inc

make all

mkdir -p "${PREFIX}/lib"
mkdir -p "${PREFIX}/include/mumps_seq"

for f in lib/*.a; do
  # add _seq suffix to libs
  cp -v $f ${PREFIX}/${f/.a/_seq.a}
done
cp -v libseq/*.a ${PREFIX}/lib/
cp -v libseq/mpi.h ${PREFIX}/include/mumps_seq/
cp -v libseq/mpif.h ${PREFIX}/include/mumps_seq/


cd examples

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
