@ECHO OFF

REM The calling syntax for this script is
REM                  Compile_FASTforLabview 
REM

REM ----------------------------------------------------------------------------
REM                   set compiler internal variables 
REM ----------------------------------------------------------------------------
REM    You can run this bat file from the IVF compiler's command prompt (and not 
REM    do anything in this section). If you choose not to run from the IVF command
REM    prompt, you must call the compiler's script to set internal variables.
REM    TIP: Right click on the IVF Compiler's Command Prompt shortcut, click
REM    properties, and copy the target (without cmd.exe and/or its switches) here:

REM: PLEASE NOTE: newer versions of the IVF compiler are not yet supported.

IF "%INTEL_SHARED%"=="" CALL "C:\Program Files\Intel\Compiler\Fortran\10.1.024\IA32\Bin\IFORTVARS.bat"


REM ----------------------------------------------------------------------------
REM -------------------- LOCAL VARIABLES ---------------------------------------
REM ----------------------------------------------------------------------------

SET ROOT_NAME=..\FAST_RT_DLL

REM bjj: DO NOT USE /threads. It causes a memory leak when the DLL runs in LabVIEW.
SET CompOpts= /O2 /inline:speed /Qzero /Qsave /real_size:32 /assume:byterecl /libs:static /nothreads /vms /check:none
rem /nologo /Qopenmp_report:0 /Qpar_report:0 /Qvec_report:0 /warn:none   /libdir:nouser /c

rem SET LINKOPTS=/link /stack:64000000
SET LinkOpts=/DELAYLOAD:"imagehlp.dll" /DLL delayimp.lib

rem /INCREMENTAL /NOLOGO  /ASSEMBLYDEBUG:DISABLE /OPT:NOREF  


REM ----------------------------------------------------------------------------
REM ------------------------- LOCAL PATHS --------------------------------------
REM ----------------------------------------------------------------------------
REM -- USERS WILL NEED TO EDIT THESE PATHS TO POINT TO FOLDERS ON THEIR LOCAL --
REM -- MACHINES.  NOTE: do not use quotation marks around the path names!!!! ---
REM ----------------------------------------------------------------------------
REM NWTC_Lib_Loc is the location of the NWTC subroutine library files
REM AeroDyn_Loc  is the location of the AeroDyn source files
REM Wind_Loc     is the location of the AeroDyn wind inflow source files
REM FAST_LOC     is the location of the FAST source files
REM ----------------------------------------------------------------------------

rem SET NWTC_Lib_Loc=C:\Users\bjonkman\Data\DesignCodes\NWTC Library\source
rem SET AeroDyn_Loc=C:\Users\bjonkman\Data\DesignCodes\AeroDyn\Source
rem SET Wind_Loc=C:\Users\bjonkman\Data\DesignCodes\AeroDyn\Source\InflowWind\Source
rem SET FAST_Loc=C:\Users\bjonkman\Data\DesignCodes\FAST\Source

SET NWTC_Lib_Loc=D:\DATA\DesignCodes\miscellaneous\nwtc_subs\SVNtrunk\source
SET AeroDyn_Loc=D:\DATA\DesignCodes\simulators\AeroDyn\SVNdirectory\trunk\Source
SET Wind_Loc=D:\DATA\DesignCodes\simulators\InflowWind\SVNdirectory\trunk\Source
SET FAST_Loc=D:\DATA\DesignCodes\simulators\FAST\SVNdirectory\trunk\Source
SET Labview_Loc=D:\DATA\DesignCodes\simulators\FAST\SVNdirectory\trunk\Labview\Source


REM ----------------------------------------------------------------------------
REM -------------------- LIST OF ALL SOURCE FILES ------------------------------
REM ----------------------------------------------------------------------------

SET NWTC_Files=
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\SingPrec.f90"
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\SysIVF_Labview.f90" 
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\NWTC_IO.f90"
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\NWTC_Num.f90"
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\NWTC_Aero.f90"
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\ModMesh.f90"
SET NWTC_Files=%NWTC_Files%  "%NWTC_Lib_Loc%\NWTC_Library.f90"


SET Wind_Files=
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\SharedInflowDefs.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\HHWind.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\FFWind.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\HAWCWind.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\FDWind.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\CTWind.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\UserWind.f90"
SET Wind_Files=%Wind_Files%  "%Wind_Loc%\InflowWindMod.f90"


SET AeroDyn_Files=
SET AeroDyn_Files=%AeroDyn_Files%  "%AeroDyn_Loc%\SharedTypes.f90"
SET AeroDyn_Files=%AeroDyn_Files%  "%AeroDyn_Loc%\AeroMods.f90"
SET AeroDyn_Files=%AeroDyn_Files%  "%AeroDyn_Loc%\GenSubs.f90"
SET AeroDyn_Files=%AeroDyn_Files%  "%AeroDyn_Loc%\AeroSubs.f90"
SET AeroDyn_Files=%AeroDyn_Files%  "%AeroDyn_Loc%\AeroDyn.f90"


SET FAST_Files=
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\fftpack.f"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\FFTMod.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\HydroCalc.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\FAST_Mods.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\Noise.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\FAST_IO.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\FAST.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\FAST_Lin.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\FAST2ADAMS.f90"

SET FAST_Files=%FAST_Files%  "%FAST_LOC%\PitchCntrl_ACH.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\UserSubs.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\UserVSCont_KP.f90"

SET FAST_Files=%FAST_Files%  "%FAST_LOC%\AeroCalc.f90"
SET FAST_Files=%FAST_Files%  "%FAST_LOC%\SetVersion.f90"

SET FAST_Files=%FAST_Files%  "%Labview_Loc%\FAST_RT_DLL.f90"


:ivf
REM ----------------------------------------------------------------------------
REM ---------------- COMPILE WITH INTEL VISUAL FORTRAN -------------------------
REM ----------------------------------------------------------------------------

REM                           compile 

ECHO.
ECHO Compiling FAST, AeroDyn, InflowWind, and NWTC_Library routines to create %ROOT_NAME%.dll:

ifort /dll %CompOpts% /exe:%ROOT_NAME%.dll %NWTC_Files% %Wind_Files% %AeroDyn_Files% %FAST_Files% /link %LinkOpts% 


:end
REM ----------------------------------------------------------------------------
REM ------------------------- CLEAR MEMORY -------------------------------------
REM ------------- and delete all .mod and .obj files ---------------------------
REM ----------------------------------------------------------------------------
ECHO 

DEL *.mod
DEL *.obj

SET ROOT_NAME=

SET NWTC_Files=
SET Wind_Files=
SET AeroDyn_Files=
SET FAST_Files=
SET A2AD_Files=
SET Fixed_Files=

SET NWTC_Lib_Loc=
SET Wind_Loc=
SET AeroDyn_Loc=
SET A2AD_Loc=
SET FAST_Loc=
SET Labview_Loc=

SET COMPOPTS=
SET LINKOPTS=
