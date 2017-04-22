#!/bin/bash

if [ `uname` == "Darwin" ]; then
  cp $RECIPE_DIR/Makefile.debian.SEQ_mac Makefile.inc
else
  cp $RECIPE_DIR/Makefile.debian.SEQ Makefile.inc
fi

make all
cp lib/*.so ${PREFIX}/lib
cp libseq/*.so ${PREFIX}/lib
cp libseq/*.h ${PREFIX}/include
cp include/*.h ${PREFIX}/include

cd examples
./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
