setlocal EnableDelayedExpansion

set src=%cd%

cd work
copy %RECIPE_DIR%\CMakeLists.txt %src%\CMakeLists.txt

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

%src%\build\ssimpletest < %src%\examples\input_simpletest_real
if errorlevel 1 exit 1
%src%\build\dsimpletest < %src%\examples\input_simpletest_real
if errorlevel 1 exit 1
%src%\build\csimpletest < %src%\examples\input_simpletest_cmplx
if errorlevel 1 exit 1
%src%\build\zsimpletest < %src%\examples\input_simpletest_cmplx
if errorlevel 1 exit 1
