#!/bin/bash
set -ex

cd examples

# examples link mpiseq directly
LIBS="-lmpiseq_seq"

for p in s d c z; do
  # Check .pc file
  mumps="${p}mumps_seq"
  pkg-config --exists --print-errors --debug ${mumps}
  pkg-config --validate --print-errors --debug ${mumps}
  $FC ${FFLAGS} ${LDFLAGS} ${LIBS} $(pkg-config --cflags ${mumps}) $(pkg-config --libs ${mumps}) ${p}simpletest.F -o ${p}simpletest
done
$CC ${CFLAGS} ${LDFLAGS} ${LIBS} $(pkg-config --cflags dmumps_seq) $(pkg-config --libs dmumps_seq) c_example.c -o c_example

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
