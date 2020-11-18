#!/bin/bash
set -ex

cp $RECIPE_DIR/Makefile.conda.SEQ ./Makefile.inc

if [[ "$(uname)" == "Darwin" ]]; then
  export SONAME="-Wl,-install_name,@rpath/"
else
  export SONAME="-Wl,-soname,"
fi

make all PLAT=_seq

# drop build-prefix rpath
if [[ "$(uname)" == "Darwin" ]]; then
  for f in lib/*${PKG_VERSION}.dylib libseq/*${PKG_VERSION}.dylib; do
    ${INSTALL_NAME_TOOL} -delete_rpath ${BUILD_PREFIX}/lib ${f} || echo "delete_rpath failed"
  done
fi

mkdir -p "${PREFIX}/lib"
mkdir -p "${PREFIX}/include/mumps_seq"

cd lib
# resolve -lmpiseq and -lmpiseq_seq to libmpiseq_seq-5.1.2.dylib
ln -s libmpiseq_seq-${PKG_VERSION}${SHLIB_EXT} libmpiseq${SHLIB_EXT}
ln -s libmpiseq_seq-${PKG_VERSION}${SHLIB_EXT} libmpiseq_seq${SHLIB_EXT}
test -f libmpiseq${SHLIB_EXT}
cd ..

cp -av lib/*${SHLIB_EXT} ${PREFIX}/lib/
cp -av libseq/*${SHLIB_EXT} ${PREFIX}/lib/
cp -av libseq/mpi*.h ${PREFIX}/include/mumps_seq/

cd examples

./ssimpletest < input_simpletest_real
./dsimpletest < input_simpletest_real
./csimpletest < input_simpletest_cmplx
./zsimpletest < input_simpletest_cmplx
./c_example
