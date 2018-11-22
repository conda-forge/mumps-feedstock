#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.PAR ./Makefile.inc

if [[ "$(uname)" == "Darwin" ]]; then
  export soname=install_name
else
  export soname=soname
fi

export CC=mpicc
export FC=mpifort

make all

cp lib/*.a ${PREFIX}/lib
