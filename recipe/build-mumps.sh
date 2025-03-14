#!/bin/bash
set -ex


if [[ "${mpi}" == "nompi" ]]; then
  SEQ="1"
  MAKEFILE_INC=$RECIPE_DIR/Makefile.conda.SEQ
  export PLAT="_seq"
else
  SEQ=""
  MAKEFILE_INC=$RECIPE_DIR/Makefile.conda.PAR
  export PLAT=""
fi

cp -v $MAKEFILE_INC ./Makefile.inc


if [[ "$target_platform" == linux-* || "$target_platform" == osx-* ]]
then
  # Workaround for https://github.com/conda-forge/scalapack-feedstock/pull/30#issuecomment-1061196317
  export FFLAGS="${FFLAGS} -fallow-argument-mismatch"
  export OMPI_FCFLAGS=${FFLAGS}
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # This is only used by open-mpi's mpicc
  # ignored in other cases
  export OMPI_CC=$CC
  export OMPI_CXX=$CXX
  export OMPI_FC=$FC
  export OPAL_PREFIX=$PREFIX
fi

if [[ -z "$SEQ" ]]; then
  export CC=mpicc
  export FC=mpifort
fi

if [[ "$target_platform" == osx-* ]]; then
  export SONAME="-install_name"

  # MPI_IN_PLACE seems to cause crashes on mac,
  # especially with openmpi but now mpich as well
  export FFLAGS="${FFLAGS} -DAVOID_MPI_IN_PLACE"
  export LDFLAGS="${LDFLAGS} -headerpad_max_install_names"
  function set_soname () {
    install_name_tool -id "@rpath/$(basename $1)" "$1"
  }
else
  export SONAME="-soname"
  function set_soname () {
    patchelf --set-soname "$(basename $1)" "$1"
  }
fi

# Makefile doesn't accept LDFLAGS in linking libmpi_seq, libpord, pass via SHARED_OPT
export SHARED_OPT="${LDFLAGS} -shared"

make allshared -j "${CPU_COUNT:-1}"

mkdir -p "${PREFIX}/lib"

ls lib

# make sure SONAME is right, which it isn't
for dylib in lib/*${SHLIB_EXT}; do
  echo $dylib
  set_soname "$dylib"
done

if [[ "$SEQ" == "1" ]]; then
  cd lib
  # resolve -lmpiseq to libmpiseq_seq.dylib
  test -f libmpiseq_seq${SHLIB_EXT}
  ln -s libmpiseq_seq${SHLIB_EXT} libmpiseq${SHLIB_EXT}
  test -f libmpiseq${SHLIB_EXT}
  cd ..
  mkdir -p "${PREFIX}/include/mumps_seq"
  cp -av libseq/mpi*.h ${PREFIX}/include/mumps_seq/
fi
cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib/

python3 $RECIPE_DIR/make_pkg_config.py
