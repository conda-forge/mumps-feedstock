#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.SEQ ./Makefile.inc


if [[ "$target_platform" == linux-* || "$target_platform" == "osx-arm64" || "$target_platform" == "osx-64" ]]
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

if [[ "$(uname)" == "Darwin" ]]; then
  export SONAME="-install_name,@rpath/"
  export LDFLAGS="${LDFLAGS} -headerpad_max_install_names"
else
  export SONAME="-soname"
fi

export LIBEXT_SHARED=${SHLIB_EXT}

make allshared PLAT=_seq

mkdir -p "${PREFIX}/lib"
mkdir -p "${PREFIX}/include/mumps_seq"

ls lib
cd lib
# resolve -lmpiseq to libmpiseq_seq.dylib
test -f libmpiseq_seq${SHLIB_EXT}
ln -s libmpiseq_seq${SHLIB_EXT} libmpiseq${SHLIB_EXT}
test -f libmpiseq${SHLIB_EXT}
cd ..

cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib/
cp -av libseq/*${SHLIB_EXT} ${PREFIX}/lib/
cp -av libseq/mpi*.h ${PREFIX}/include/mumps_seq/

python3 $RECIPE_DIR/make_pkg_config.py

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  cd examples

  ./ssimpletest < input_simpletest_real
  ./dsimpletest < input_simpletest_real
  ./csimpletest < input_simpletest_cmplx
  ./zsimpletest < input_simpletest_cmplx
  ./c_example
fi
