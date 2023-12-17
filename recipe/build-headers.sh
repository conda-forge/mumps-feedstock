echo "build-headers pwd"
pwd
echo "build-headers ls include/"
ls include/
echo "build-headers ls ../include/"
ls ../include/
mkdir -p $PREFIX/include
cp -av include/*.h $PREFIX/include/
# To also copy generated headers, see https://github.com/conda-forge/mumps-feedstock/issues/100
cp -av ../include/*.h $PREFIX/include/
