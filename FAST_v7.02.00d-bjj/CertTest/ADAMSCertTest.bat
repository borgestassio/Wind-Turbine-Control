@ECHO OFF
@ECHO.


REM  Set up environment variables.  You will probably have to change these.

@SET Compare=FC
@SET CRUNCH=Call Crunch

@SET ADAMS=Call ADAMS08
REM @SET ADAMS=Call ADAMS05
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

@IF EXIST ADAMSCertTest.out  DEL ADAMSCertTest.out

ECHO.                                               >> ADAMSCertTest.out
ECHO           ************************************* >> ADAMSCertTest.out
ECHO           **  ADAMS Acceptance Test Results  ** >> ADAMSCertTest.out
ECHO           ************************************* >> ADAMSCertTest.out

ECHO.                                                                             >> ADAMSCertTest.out
ECHO ############################################################################ >> ADAMSCertTest.out
ECHO # Inspect this file for any differences between your results and the saved # >> ADAMSCertTest.out
ECHO # results.  Any differing lines and the two lines surrounding them will be # >> ADAMSCertTest.out
ECHO # listed.  The only differences should be the time stamps at the start of  # >> ADAMSCertTest.out
ECHO # each file.                                                               # >> ADAMSCertTest.out
ECHO #                                                                          # >> ADAMSCertTest.out
ECHO # If you are running on something other than a PC, you may see differences # >> ADAMSCertTest.out
ECHO # in the last significant digit of many of the numbers.                    # >> ADAMSCertTest.out
ECHO ############################################################################ >> ADAMSCertTest.out

ECHO.                                            >> ADAMSCertTest.out
ECHO Date and time this acceptance test was run: >> ADAMSCertTest.out
%DateTime%                                       >> ADAMSCertTest.out
ECHO.                                            >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST01%

@SET TEST=01

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST01%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.azi TstFiles\Test%TEST%_ADAMS.azi >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST02%

@SET TEST=02

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST02%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST03%

@SET TEST=03

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST03%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.azi TstFiles\Test%TEST%_ADAMS.azi >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST04%

@SET TEST=04

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST04%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.pmf TstFiles\Test%TEST%_ADAMS.pmf >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST05%

@SET TEST=05

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST05%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST06%

@SET TEST=06

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST06%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST07%

@SET TEST=07

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST07%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.pmf TstFiles\Test%TEST%_ADAMS.pmf >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST08%

@SET TEST=08

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST08%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.azi TstFiles\Test%TEST%_ADAMS.azi >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST09%

@SET TEST=09

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST09%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST10%

@SET TEST=10

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST10%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST11%

@SET TEST=11

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST11%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST12%

@SET TEST=12

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST12%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST13%

@SET TEST=13

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST13%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.pmf TstFiles\Test%TEST%_ADAMS.pmf >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST14%

@SET TEST=14

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS_LIN

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS_LIN.out  GOTO ERROR


echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST14%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS_LIN.out TstFiles\Test%TEST%_ADAMS_LIN.out >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST15%

@SET TEST=15

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST15%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST16%

@SET TEST=16

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST16%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out


rem *******************************************************

@echo ADAMS %TEST17%

@SET TEST=17

rem Run ADAMS.

%ADAMS% Test%TEST%_ADAMS

REM:JASON--ADAMS2003 and ADAMS2005 have a bug in that it always returns an OS return code of 1; this will be fixed in a future release of ADAMS:IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.plt  GOTO ERROR

rem Crunch the ADAMS output.
%CRUNCH% Test%TEST%_ADAMS.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%_ADAMS.sts  GOTO ERROR

echo.                                                        >> ADAMSCertTest.out
echo %POUNDS%                                                >> ADAMSCertTest.out
echo.                                                        >> ADAMSCertTest.out
echo %TEST17%                                                >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.sts TstFiles\Test%TEST%_ADAMS.sts >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.pmf TstFiles\Test%TEST%_ADAMS.pmf >> ADAMSCertTest.out
echo %DASHES%                                                >> ADAMSCertTest.out
%Compare% Test%TEST%_ADAMS.opt TstFiles\Test%TEST%_ADAMS.opt >> ADAMSCertTest.out



rem ******************************************************
rem  Let's look at the comparisons.

%Editor% ADAMSCertTest.out
goto END

:ERROR
@echo ** An error has occurred in Test #%TEST% **
goto END

:END

@SET CRUNCH=
@SET Compare=
@SET DASHES=
@SET DateTime=
@SET Editor=
@SET ADAMS=
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
