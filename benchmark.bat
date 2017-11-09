@echo off
if "%1" == "" goto :help
if "%2" == "" goto :help

:: Baseline
call git checkout origin/parallel
call :benchmark %1 %2 logs\seq

:: Parallel task per cell
call git checkout origin/fbie/parallel
call :benchmark %1 %2 logs\cells

:: Lifted cell arrays
call git checkout origin/fbie/cell-array-transformation-dynamic
call :benchmark %1 %2 logs\arrays

exit /b

:help
echo Usage:
echo   benchmark.bat path\to\sheets iterations
echo.
echo path\to\sheets - Path to a folder that contains XML spreadsheets.
echo iterations     - Number of iterations to repeat.
echo.

:: Done
exit /b

:benchmark
setlocal
set files=%1
set n=%2
set log=%3
mkdir %log%

:: Log build events
echo Building...
call build -c >  %log%\build.log 2>&1
call build -r >> %log%\build.log 2>&1

echo Benchmarking...
:: Benchmark Funcalc for each sheet.
for /r %files% %%I in (*.xml) do (
    call funcalc -r full %n% "%%I" 1> "%log%\%%~nxI.out" 2> "%log%\%%~nxI.err"
)

echo Done!
endlocal
exit /b
