@echo off
if "%1" == "" goto :help
if "%2" == "" goto :help
if "%3" == "" goto :help

echo Started %time% %date%.

call git checkout origin/parallel-stable

:: Sequential
call :benchmark %1 %2  0 %3\seq -n

:: Sequential rewriting
call :benchmark %1 %2  0 %3\seq-array-seq -n -w

:: Parallel rewriting
call :benchmark %1 %2  0 %3\seq-array-par -n -w -p
call :benchmark %1 %2  2 %3\seq-array-par -n -w -p
call :benchmark %1 %2  4 %3\seq-array-par -n -w -p
call :benchmark %1 %2  8 %3\seq-array-par -n -w -p
call :benchmark %1 %2 16 %3\seq-array-par -n -w -p
call :benchmark %1 %2 32 %3\seq-array-par -n -w -p
call :benchmark %1 %2 48 %3\seq-array-par -n -w -p

echo Finished %time% %date%.

exit /b

:help
echo Script to run Puncalc benchmarks. It will automatically benchmark each sheet
echo  - sequentially, as a baseline;
echo  - sequentially with rewritten cell arrays; and
echo  - in parallel with rewritten cell arrays up to 48 cores.
echo.
echo Usage:
echo   benchmark.bat path\to\sheets iterations path\to\logs
echo.
echo path\to\sheets - Path to a folder that contains XML spreadsheets.
echo iterations     - Number of iterations to repeat.
echo path\to\logs   - Path to a folder where log files will be stored.
echo.

:: Done
exit /b

:benchmark
setlocal
set files=%1
set n=%2
set cores=%3
set log=%4
shift /4
set flags=%*
mkdir %log%\%cores%

:: Log build events
echo Building...
git show -q           >  %log%\git.log
call build -c         >  %log%\build.log 2>&1
call build -r %flags% >> %log%\build.log 2>&1

echo Running %n% iterations on %cores% cores, logging to %log%:

:: Benchmark Funcalc for each sheet.
for /r %files% %%I in (*.xml) do (
    echo Benchmarking %%I
    call funcalc -r roots %n% %cores% "%%I" 1> "%log%\%cores%\%%~nxI.out" 2> "%log%\%cores%\%%~nxI.err"
)

echo Done!
endlocal
exit /b
