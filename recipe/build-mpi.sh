#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.PAR ./Makefile.inc

if [[ "$target_platform" == linux-* || "$target_platform" == "osx-arm64"  ]]
 then
   # Workaround for https://github.com/conda-forge/scalapack-feedstock/pull/30#issuecomment-1061196317
   # As of March 2022, on macOS (Intel) gfortran 9 is still used
   export FFLAGS="${FFLAGS} -fallow-argument-mismatch"
   export OMPI_FCFLAGS=${FFLAGS}
 fi

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
