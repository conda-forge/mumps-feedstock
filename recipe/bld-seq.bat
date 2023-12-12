setlocal EnableDelayedExpansion

set src=%cd%

cd work
copy %RECIPE_DIR%\CMakeLists.txt %src%\CMakeLists.txt
:: select 64b
copy %src%\src\mumps_int_def64_h.in %src%\src\mumps_int_def.h

mkdir build
cd build

:: Configure using the CMakeFiles
cmake -G "NMake Makefiles" ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_BUILD_TYPE:STRING=Release ^
      ..
if errorlevel 1 exit 1
cmake --build . --config Release --target install
if errorlevel 1 exit 1
%src%\build\c_example < %src%\examples\input_simpletest_real
if errorlevel 1 exit 1
%src%\build\ssimpletest < %src%\examples\input_simpletest_real
if errorlevel 1 exit 1
%src%\build\dsimpletest < %src%\examples\input_simpletest_real
if errorlevel 1 exit 1
%src%\build\csimpletest < %src%\examples\input_simpletest_cmplx
if errorlevel 1 exit 1
%src%\build\zsimpletest < %src%\examples\input_simpletest_cmplx
if errorlevel 1 exit 1
