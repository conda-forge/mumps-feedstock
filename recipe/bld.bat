setlocal EnableDelayedExpansion

cd work
mkdir build
cd build

:: Configure using the CMakeFiles
cmake -G "MinGW Makefiles" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%\mingw-w64" ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      -DCMAKE_SH="CMAKE_SH-NOTFOUND" ^
      ..
if errorlevel 1 exit 1

:: Build!
mingw32-make
if errorlevel 1 exit 1

:: Install!
mingw32-make install
if errorlevel 1 exit 1