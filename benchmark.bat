mkdir logs\full\arrays
mkdir logs\full\cells
mkdir logs\full\seq

git checkout origin/fbie/cell-array-transformation
build -c
build -r -n
for /f "usebackq delims=|" %f in (`dir /b /s ..\funcalc-euses ^| findstr /i "\.xml$"`) do funcalc -r full 100 %f 1> logs\arrays\%~nxf.out 2> logs\arrays\%~nxf.err

git checkout origin/fbie/parallel-full-recalc
build -c
build -r -n
for /f "usebackq delims=|" %f in (`dir /b /s ..\funcalc-euses ^| findstr /i "\.xml$"`) do funcalc -r full 100 %f 1> logs\cells\%~nxf.out 2> logs\cells\%~nxf.err

git checkout origin/parallel
build -c
build -r -n
for /f "usebackq delims=|" %f in (`dir /b /s ..\funcalc-euses ^| findstr /i "\.xml$"`) do funcalc -r full 100 %f 1> logs\seq\%~nxf.out 2> logs\seq\%~nxf.err
