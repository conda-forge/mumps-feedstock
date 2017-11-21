setlocal EnableDelayedExpansion

xcopy ..\CMakeLists.txt .

:: Make a build folder and change to it.
mkdir build
cd build

:: Configure using the CMakeFiles
cmake -G "MinGW Makefiles" ^
      -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      ..
if errorlevel 1 exit 1

:: Build!
mingw32-make
if errorlevel 1 exit 1

:: Install!
mingw32-make install
if errorlevel 1 exit 1