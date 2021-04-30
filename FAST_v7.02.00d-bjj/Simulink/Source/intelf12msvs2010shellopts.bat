@echo off
rem INTELF12MSVS2010SHELLOPTS.BAT
rem
rem    Compile and link options used for building MEX-files using the
rem    Intel? Fortran Compiler 12.0 with the Microsoft? Visual Studio?
rem    2010 Shell (Integrated) SP1 linker.
rem
rem StorageVersion: 1.0
rem FortrankeyFileName: INTELF12MSVS2010OPTS.BAT
rem FortrankeyName: Intel Visual Fortran
rem FortrankeyManufacturer: Intel
rem FortrankeyVersion: 12.0
rem FortrankeyLanguage: Fortran
rem
rem    $Revision: 1.1.6.2 $  $Date: 2011/06/15 04:19:14 $
rem    $Revision: B. Jonkman, NREL $Date: 2012/11/14
rem
rem ********************************************************************
rem General parameters
rem ********************************************************************
set MATLAB=%MATLAB%
set IFORT_COMPILER12=%IFORT_COMPILER12%
rem set IFORT_COMPILER12=C:\Program Files (x86)\Intel\Composer XE 2011 SP1
set IFORT_COMPILER_REDIST=%IFORT_COMPILER12%\redist\ia32

set VSINSTALLDIR=%VSSHELL2010INSTALLDIR%
rem set VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0

set VCINSTALLDIR=%VSINSTALLDIR%\Intel Fortran\Microsoft Files\VC

rem ORIGINAL VALUES in MICROSOFT BATCH FILE:
rem set PATH=%IFORT_COMPILER12%\Bin\ia32;%VCINSTALLDIR%\BIN\;%VSINSTALLDIR%\VC\bin;%LINKERDIR%\bin;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\Common7\Tools;%VSINSTALLDIR%\Common7\Tools\bin;%VCINSTALLDIR%\VCPackages;%MATLAB_BIN%;%PATH%
rem set INCLUDE=%IFORT_COMPILER12%\compiler\Include;%VCINSTALLDIR%\ATLMFC\INCLUDE;%VCINSTALLDIR%\INCLUDE;%LINKERDIR%\include;%INCLUDE%
rem set LIB=%IFORT_COMPILER12%\compiler\Lib\ia32;%VCINSTALLDIR%\ATLMFC\LIB;%VCINSTALLDIR%\LIB;%LINKERDIR%\lib;%VSINSTALLDIR%\SDK\v2.0\lib;%MATLAB%\extern\lib\win32;%LIB%

rem BONNIE'S VALUES:
SET PATH=%IFORT_COMPILER12%\bin\ia32;%IFORT_COMPILER_REDIST%\compiler;%VSINSTALLDIR%\Common7\IDE;%VSINSTALLDIR%\BIN;%VSINSTALLDIR%\Common7\Tools;%VSINSTALLDIR%\Common7\Tools\bin;%VCINSTALLDIR%\bin;%IFORT_COMPILER_REDIST%\mkl;%IFORT_COMPILER_REDIST%\compiler;%MATLAB_BIN%;%PATH%;%IFORT_COMPILER_REDIST%\mpirt; 
SET INCLUDE=%IFORT_COMPILER12%\compiler\include;%IFORT_COMPILER12%\compiler\include\ia32;%VCINSTALLDIR%\atlmfc\include;%VCINSTALLDIR%\include;%VSINSTALLDIR%\include;%IFORT_COMPILER12%\mkl\include;%INCLUDE%
SET LIB=%IFORT_COMPILER12%\compiler\lib;%IFORT_COMPILER12%\compiler\lib\ia32;%VCINSTALLDIR%\atlmfc\lib;%VCINSTALLDIR%\lib;%VCINSTALLDIR%\PlatformSDK\lib;%IFORT_COMPILER12%\mkl\lib\ia32;%IFORT_COMPILER12%\compiler\lib\ia32;%MATLAB%\extern\lib\win32;%LIB%;


set MW_TARGET_ARCH=win32


rem ********************************************************************
rem Compiler parameters
rem ********************************************************************
set COMPILER=ifort
REM set COMPFLAGS=/fpp 
set COMPFLAGS=/assume:byterecl /traceback /Qsave /Qzero /real_size:64 /Qprec "/I%MATLAB%/extern/include" -c -nologo -DMATLAB_MEX_FILE /fp:source
set OPTIMFLAGS=/O2 /DNDEBUG
set DEBUGFLAGS=/Z7
set NAME_OBJECT=/Fo

rem ********************************************************************
rem Linker parameters
rem ********************************************************************
set LIBLOC=%MATLAB%\extern\lib\win32\microsoft
set LINKER=link
set LINKFLAGS=/dll /export:MEXFUNCTION /LIBPATH:"%LIBLOC%" libmx.lib libmex.lib libmat.lib /implib:"%LIB_NAME%.x" /MAP:"%OUTDIR%%MEX_NAME%%MEX_EXT%.map" /NOLOGO  /manifest /INCREMENTAL:NO
set LINKOPTIMFLAGS=
set LINKDEBUGFLAGS=/debug /PDB:"%OUTDIR%%MEX_NAME%%MEX_EXT%.pdb"
set LINK_FILE=
set LINK_LIB=
set NAME_OUTPUT=/out:"%OUTDIR%%MEX_NAME%%MEX_EXT%"
set RSP_FILE_INDICATOR=@

rem ********************************************************************
rem Resource compiler parameters
rem ********************************************************************
set RC_COMPILER=rc /fo "%OUTDIR%mexversion.res"
set RC_LINKER=

set POSTLINK_CMDS=del "%LIB_NAME%.x" "%LIB_NAME%.exp"
set POSTLINK_CMDS1=mt -outputresource:"%OUTDIR%%MEX_NAME%%MEX_EXT%";2 -manifest "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest"
set POSTLINK_CMDS2=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.manifest" 
set POSTLINK_CMDS3=del "%OUTDIR%%MEX_NAME%%MEX_EXT%.map"
