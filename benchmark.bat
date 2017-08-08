mkdir logs\arrays
mkdir logs\cells
mkdir logs\seq

call git checkout origin/fbie/cell-array-transformation
call build -c
call build -r -n
for /f "usebackq delims=|" %f in (`dir /b /s ..\funcalc-euses ^| findstr /i "\.xml$"`) do call funcalc -r full 100 %f 1> logs\arrays\%~nxf.out 2> logs\arrays\%~nxf.err

call git checkout origin/fbie/parallel-full-recalc
call build -c
call build -r -n
for /f "usebackq delims=|" %f in (`dir /b /s ..\funcalc-euses ^| findstr /i "\.xml$"`) do call funcalc -r full 100 %f 1> logs\cells\%~nxf.out 2> logs\cells\%~nxf.err

call git checkout origin/parallel
call build -c
call build -r -n
for /f "usebackq delims=|" %f in (`dir /b /s ..\funcalc-euses ^| findstr /i "\.xml$"`) do call funcalc -r full 100 %f 1> logs\seq\%~nxf.out 2> logs\seq\%~nxf.err
