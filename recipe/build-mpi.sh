#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.PAR ./Makefile.inc

if [[ "$(uname)" == "Darwin" ]]; then
  export SONAME="-Wl,-install_name,@rpath/"
else
  export SONAME="-Wl,-soname,"
fi

export CC=mpicc
export FC=mpifort

make all

cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib


otool -l ${PREFIX}/lib/libmumps*

