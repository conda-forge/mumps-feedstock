#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.PAR ./Makefile.inc

export CC=mpicc
export FC=mpifort

make all

cp lib/*.a ${PREFIX}/lib
cp include/*.h ${PREFIX}/include
