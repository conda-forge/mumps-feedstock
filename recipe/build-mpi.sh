#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.PAR ./Makefile.inc

if [[ "$(uname)" == "Darwin" ]]; then
  export SONAME="-Wl,-install_name,@rpath/"
  export LDFLAGS="${LDFLAGS} -headerpad_max_install_names"
else
  export SONAME="-Wl,-soname,"
fi

export CC=mpicc
export FC=mpifort

make all

cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib
