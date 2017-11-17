#!/bin/bash

cp $RECIPE_DIR/Makefile.conda.SEQ ./Makefile.inc

make all

cp lib/*.a ${PREFIX}/lib
cp include/*.h ${PREFIX}/include

cd examples

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
