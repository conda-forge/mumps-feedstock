@echo on
mkdir %PREFIX%\include
copy src\mumps_int_def32_h.in %PREFIX%\include\mumps_int_def.h
copy include\*.h %PREFIX%\include\

