#!/bin/bash
set -ex

cd examples

# examples link mpiseq directly
LIBS="-lmpiseq_seq"

for p in s d c z; do
  # Check .pc file
  mumps="${p}mumps_seq"
  pkg-config --exists --print-errors ${mumps}
  pkg-config --validate --print-errors ${mumps}
  $FC ${FFLAGS} ${LDFLAGS} $(pkg-config --cflags ${mumps}) ${p}simpletest.F -o ${p}simpletest ${LIBS}  $(pkg-config --libs ${mumps})
done
$CC ${CFLAGS} ${LDFLAGS} $(pkg-config --cflags dmumps_seq) c_example.c -o c_example ${LIBS}  $(pkg-config --libs dmumps_seq) 

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
