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

# drop build-prefix rpath
if [[ "$(uname)" == "Darwin" ]]; then
  for f in lib/*${PKG_VERSION}.dylib; do
    ${INSTALL_NAME_TOOL} -delete_rpath ${BUILD_PREFIX}/lib ${f} || echo "delete_rpath failed"
  done
fi

cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib
