@ECHO OFF
@ECHO.


REM  Set up environment variables.  You will probably have to change these.

@SET Compare=FC
@SET CRUNCH=Call Crunch
rem @SET CRUNCH=Call C:\Users\bjonkman\Data\DesignCodes\Crunch\Crunch.exe

@SET MATLAB=matlab
@SET MBC_SOURCE=C:\Users\bjonkman\Documents\DATA\Downloads\MBC\Source
rem @SET MBC_SOURCE=C:\Users\bjonkman\Data\DesignCodes\MBC\Source

@SET FAST=..\FAST.exe
rem @SET FAST=..\compiling\FAST_gwin32.exe
rem @SET FAST=..\compiling\FAST_iwin32.exe
rem @SET FAST=..\FAST_Debug.exe
@SET DateTime=DateTime.exe
@SET Editor=NotePad.EXE


REM  FAST test sequence definition:

@SET  TEST01=Test #01: AWT-27CR2 with many DOFs with fixed yaw error and steady wind.  AA plots.
@SET  TEST02=Test #02: AWT-27CR2 with many DOFs with startup and shutdown and steady wind.  Time plots.
@SET  TEST03=Test #03: AWT-27CR2 with many DOFs with free yaw and steady wind.  AA plots.
@SET  TEST04=Test #04: AWT-27CR2 with many DOFs with free yaw and FF turbulence.  PMF plots.
@SET  TEST05=Test #05: AWT-27CR2 with many DOFs with startup and shutdown and FF turbulence.  Time plots.
@SET  TEST06=Test #06: AOC 15/50 with many DOFs with gen start loss of grid and tip-brake shutdown.  Time plots.
@SET  TEST07=Test #07: AOC 15/50 with many DOFs with free yaw and FF turbulence.  PMF plots.
@SET  TEST08=Test #08: AOC 15/50 with many DOFs with fixed yaw error and steady wind.  AA plots.
@SET  TEST09=Test #09: UAE Phase VI (downwind) with many DOFs with yaw ramp and a steady wind.  Time plots.
@SET  TEST10=Test #10: UAE Phase VI (upwind) with no DOFs in a ramped wind.  Time plots.
@SET  TEST11=Test #11: WindPACT 1.5 MW Baseline with many DOFs undergoing a pitch failure.  Time plots.
@SET  TEST12=Test #12: WindPACT 1.5 MW Baseline with many DOFs with VS and VP and ECD wind.  Time plots.
@SET  TEST13=Test #13: WindPACT 1.5 MW Baseline with many DOFs with VS and VP and FF turbulence.  PMF plots.
@SET  TEST14=Test #14: WindPACT 1.5 MW Baseline with many DOFs and system linearization.  Column chart.
@SET  TEST15=Test #15: SWRT with many DOFs with free yaw tail-furl and VS and EOG wind.  Time plots.
@SET  TEST16=Test #16: SWRT with many DOFs with free yaw tail-furl and VS and EDC wind.  Time plots.
@SET  TEST17=Test #17: SWRT with many DOFs with free yaw tail-furl and VS and FF turbulence.  PMF plots.

@SET  DASHES=---------------------------------------------------------------------------------------------
@SET  POUNDS=#############################################################################################

@IF EXIST CertTest.out  DEL CertTest.out

ECHO.                                               >> CertTest.out
ECHO           ************************************ >> CertTest.out
ECHO           **  FAST Acceptance Test Results  ** >> CertTest.out
ECHO           ************************************ >> CertTest.out

ECHO.                                                                             >> CertTest.out
ECHO ############################################################################ >> CertTest.out
ECHO # Inspect this file for any differences between your results and the saved # >> CertTest.out
ECHO # results.  Any differing lines and the two lines surrounding them will be # >> CertTest.out
ECHO # listed.  The only differences should be the time stamps at the start of  # >> CertTest.out
ECHO # each file.                                                               # >> CertTest.out
ECHO #                                                                          # >> CertTest.out
ECHO # If you are running on something other than a PC, you may see differences # >> CertTest.out
ECHO # in the last significant digit of many of the numbers.                    # >> CertTest.out
ECHO ############################################################################ >> CertTest.out

ECHO.                                            >> CertTest.out
ECHO Date and time this acceptance test was run: >> CertTest.out
%DateTime%                                       >> CertTest.out
ECHO.                                            >> CertTest.out


rem *******************************************************

@echo FAST %TEST01%

@SET TEST=01

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST01%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.azi TstFiles\Test%TEST%.azi >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST02%

@SET TEST=02

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out   GOTO ERROR
@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST02%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST03%

@SET TEST=03

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST03%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.azi TstFiles\Test%TEST%.azi >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST04%

@SET TEST=04

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST04%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST05%

@SET TEST=05

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST05%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST06%

@SET TEST=06

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST06%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST07%

@SET TEST=07

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST07%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST08%

@SET TEST=08

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST08%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.azi TstFiles\Test%TEST%.azi >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST09%

@SET TEST=09

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST09%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST10%

@SET TEST=10

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST10%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST11%

@SET TEST=11

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST11%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST12%

@SET TEST=12

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST12%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST13%

@SET TEST=13

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST13%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST14%

@SET TEST=14

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.lin  GOTO ERROR

rem Perform an eigenanalysis in MATLAB:
echo. Running Matlab to calculate eigenvalues. If an error occurs, close Matlab to continue CertTest....
%MATLAB% /wait /r addpath('%MBC_SOURCE%');Test%TEST% /logfile Test%TEST%.eig

@rem echo. Call to Matlab completed.

IF ERRORLEVEL 1  GOTO MATLABERROR

@IF NOT EXIST Test%TEST%.eig  GOTO MATLABERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST14%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.eig TstFiles\Test%TEST%.eig >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out


rem *******************************************************

:MATLABERROR
@echo FAST %TEST15%

@SET TEST=15

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST15%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST16%

@SET TEST=16

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST16%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST17%

@SET TEST=17

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST17%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.fsm TstFiles\Test%TEST%.fsm >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out



rem ******************************************************
rem  Let's look at the comparisons.

rem %MATLAB% /r PlotCertTestResults('.','.\TstFiles');exit;


%Editor% CertTest.out
goto END

:ERROR
@echo ** An error has occurred in Test #%TEST% **

:END

@SET CRUNCH=
@SET MATLAB=
@SET MBC_SOURCE=
@SET Compare=
@SET DASHES=
@SET DateTime=
@SET Editor=
@SET FAST=
@SET POUNDS=
@SET TEST=
@SET TEST01=
@SET TEST02=
@SET TEST03=
@SET TEST04=
@SET TEST05=
@SET TEST06=
@SET TEST07=
@SET TEST08=
@SET TEST09=
@SET TEST10=
@SET TEST11=
@SET TEST12=
@SET TEST13=
@SET TEST14=
@SET TEST15=
@SET TEST16=
@SET TEST17=

type Bell.txt
@echo Processing complete.
