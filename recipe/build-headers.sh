set -ex
mkdir -p $PREFIX/include
cp -v src/mumps_int_def32_h.in include/mumps_int_def.h
cp -av include/*.h $PREFIX/include/
