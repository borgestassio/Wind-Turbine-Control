#================================================================================#
# This makefile created by B. Jonkman on 19-Feb-2013,                            #
# adapted from Crunch (M. Buhl on 25-Jan-2013).                                  #
# (c) 2013 National Renewable Energy Laboratory                                  #
#                                                                                #
# This makefile has been tested on Windows 7 with gfortran.                      #
# This makefile works with mingw32-make.exe.                                     #
#                                                                                #
# It was designed to be used with:                                               #
#     FAST                    (v7.02.00d-bjj, 20-Feb-2013)                       #
#     AeroDyn                 (v13.00.02a-bjj, 20-Feb-2013)                      #
#     InflowWind              (v1.01.00b-bjj, 10-Aug-2012)                       #
#     NWTC Subroutine Library (v1.07.00b-mlb, 10-Jan-2013)                       #
#                                                                                #
# Older versions of the source code may not work with this makefile.             #
#================================================================================#

   # 32-bit or 64-bit?
BITS = 32
#BITS = 64


   # Location of source files for FAST, AeroDyn, InflowWind, and the NWTC Library.
   # You will probably need to change these for your system.


ifeq ($(OS),Windows_NT)
   NWTC_LIB_DIR= C:/Users/bjonkman/Documents/DATA/DesignCodes/miscellaneous/nwtc_subs/SVNdirectory/trunk/source
   AERODYN_DIR = C:/Users/bjonkman/Documents/DATA/DesignCodes/simulators/AeroDyn/SVNdirectory/trunk/Source
   WIND_DIR    = C:/Users/bjonkman/Documents/DATA/DesignCodes/simulators/InflowWind/SVNdirectory/trunk/Source
   FAST_DIR    = C:/Users/bjonkman/Documents/DATA/DesignCodes/simulators/FAST/SVNdirectory/trunk/Source
else
   NWTC_LIB_DIR = $(HOME)/PC/CAEtools/Miscellaneous/NWTC_Library/trunk/source
   AERODYN_DIR  = $(HOME)/PC/CAEtools/simulators/AeroDyn/SVNdirectory/trunk/Source
   WIND_DIR     = $(HOME)/PC/CAEtools/simulators/InflowWind/SVNdirectory/trunk/Source
   FAST_DIR     = $(HOME)/PC/CAEtools/simulators/FAST/SVNdirectory/trunk/Source

endif


   # Name of compiler to use and flags to use.
FC      = gfortran
FFLAGS  = -O2 -m$(BITS) -fbacktrace -finit-local-zero -fno-automatic -ffree-line-length-none
LDFLAGS = -O2 -m$(BITS) -fbacktrace

# other useful gfortran options:
#  -fdefault-real-8 -fcheck=bounds -std=f2003 -O0 -v


   # Precision.

# Use "SingPrec" for single precision and "DoubPrec" for double precision. You may also need to change an option switch to make constants DP.
PREC = SingPrec


   # Destination and RootName for executable

OUTPUT_NAME = FAST
DEST_DIR    = .

   #==========================================================#
   # You should not need to change anything beyond this point #
   #==========================================================#

   # System-specific settings.

ifeq ($(OS),Windows_NT)
      # Windows
   DEL_CMD   = del
   EXE_EXT   = _gwin$(BITS).exe
   INTER_DIR = Obj_win$(BITS)
   MD_CMD    = @mkdir
   OBJ_EXT   = .obj
   PATH_SEP  = \\
   SYS_FILE  = SysGnuWin
else
      # Linux
   DEL_CMD   = rm -f
   EXE_EXT   = _glin$(BITS)
   INTER_DIR = Obj_lin$(BITS)
   MD_CMD    = @mkdir -p
   OBJ_EXT   = .o
   PATH_SEP  = /
   SYS_FILE  = SysGnuLinux
endif


   # Source files (by module)

LIB_SOURCES =           \
	$(PREC).f90          \
	$(SYS_FILE).f90      \
	NWTC_IO.f90          \
	NWTC_Num.f90         \
	ModMesh.f90          \
	NWTC_Aero.f90        \
	NWTC_Library.f90

WIND_SOURCES =          \
	SharedInflowDefs.f90 \
	HHWind.f90           \
	FFWind.f90           \
	HAWCWind.f90         \
	FDWind.f90           \
	CTWind.f90           \
	UserWind.f90         \
	InflowWindMod.f90

AERODYN_SOURCES =       \
	SharedTypes.f90      \
	AeroMods.f90         \
	GenSubs.f90          \
	AeroSubs.f90         \
	AeroDyn.f90

HYDRODYN_SOURCES =      \
	FFTMod.f90           \
	HydroCalc.f90

FAST_SOURCES =          \
	FAST_Mods.f90        \
	Noise.f90            \
	FAST_IO.f90          \
	FAST.f90             \
	FAST_Lin.f90         \
	FAST2ADAMS.f90       \
	PitchCntrl_ACH.f90   \
	UserSubs.f90         \
	UserVSCont_KP.f90    \
	AeroCalc.f90         \
	SetVersion.f90       \
	FAST_Prog.f90        \

#FOR DLL, SUBSTITUTE THESE FILES:
#	PitchCntrl_ACH.f90   \
#	UserSubs.f90         \
#	UserVSCont_KP.f90    \
#FOR THESE FILES:
#	BladedDLLInterface.f90            \
#	UserSubs_forBladedDLL.f90         \
#	UserVSCont_KP_forBladedDLL.f90    \
#END SUBSTITUTION


vpath %.f90 $(NWTC_LIB_DIR) $(AERODYN_DIR) $(WIND_DIR) $(FAST_DIR)
vpath %.f   $(FAST_DIR)
vpath %.mod $(INTER_DIR)
vpath %.obj $(INTER_DIR)

LIB_OBJS      = $(LIB_SOURCES:.f90=.obj)
WIND_OBJS     = $(WIND_SOURCES:.f90=.obj)
AERODYN_OBJS  = $(AERODYN_SOURCES:.f90=.obj)
HYDRODYN_OBJS = $(HYDRODYN_SOURCES:.f90=.obj) fftpack.obj
FAST_OBJS     = $(FAST_SOURCES:.f90=.obj)
ALL_OBJS      = $(LIB_OBJS) $(WIND_OBJS) $(AERODYN_OBJS) $(HYDRODYN_OBJS) $(FAST_OBJS)

   # Rule to do everything.

all:     default
default:  $(INTER_DIR) $(DEST_DIR)/$(OUTPUT_NAME)$(EXE_EXT)

   # General rules for compliling the files.

%.obj: %.f90
	$(FC)  $(FFLAGS) -c $< -o $(INTER_DIR)/$@ -J $(INTER_DIR)

fftpack.obj: fftpack.f
	$(F77) $(FFLAGS) -c $< -o $(INTER_DIR)/$@ -J $(INTER_DIR)

   #  Dependency rules.
ModMesh.obj:             $(PREC).obj
$(SYS_FILE).obj:         $(PREC).obj
NWTC_IO.obj:             $(SYS_FILE).obj
NWTC_Num.obj:            NWTC_IO.obj
NWTC_Aero.obj:           NWTC_IO.obj       NWTC_Num.obj
NWTC_Library.obj:        NWTC_Aero.obj     ModMesh.obj

HHWind.obj:              NWTC_Library.obj  SharedInflowDefs.obj
FFWind.obj:              NWTC_Library.obj  SharedInflowDefs.obj
HAWCWind.obj:            NWTC_Library.obj  SharedInflowDefs.obj
FDWind.obj:              NWTC_Library.obj  SharedInflowDefs.obj
CTWind.obj:              NWTC_Library.obj  SharedInflowDefs.obj
UserWind.obj:            NWTC_Library.obj  SharedInflowDefs.obj
InflowWindMod.obj:       NWTC_Library.obj  SharedInflowDefs.obj  HHWind.obj  FFWind.obj  HAWCWind.obj  FDWind.obj  CTWind.obj  UserWind.obj

AeroMods.obj:            NWTC_Library.obj
GenSubs.obj:             NWTC_Library.obj  AeroMods.obj
AeroSubs.obj:            NWTC_Library.obj  AeroMods.obj
AeroDyn.obj:             NWTC_Library.obj  AeroMods.obj  SharedTypes.obj  AeroSubs.obj  GenSubs.obj  InflowWindMod.obj

fftpack.obj:             NWTC_Library.obj
HydroCalc.obj:           NWTC_Library.obj  FFTMod.obj

FAST_Mods.obj:           NWTC_Library.obj  AeroDyn.obj
Noise.obj:               NWTC_Library.obj  FAST_Mods.obj  AeroDyn.obj  InflowWindMod.obj
FAST_IO.obj:             NWTC_Library.obj  FAST_Mods.obj  AeroDyn.obj  InflowWindMod.obj  HydroCalc.obj  Noise.obj
FAST.obj:                NWTC_Library.obj  FAST_Mods.obj  AeroDyn.obj  InflowWindMod.obj  HydroCalc.obj  FAST_IO.obj
FAST_Lin.obj:            NWTC_Library.obj  FAST_Mods.obj  AeroDyn.obj  InflowWindMod.obj  FAST.obj
FAST2ADAMS.obj:          NWTC_Library.obj  FAST_Mods.obj  AeroDyn.obj  InflowWindMod.obj
PitchCntrl_ACH.obj:      NWTC_Library.obj
UserSubs.obj:            NWTC_Library.obj
UserVSCont_KP.obj:       NWTC_Library.obj
AeroCalc.obj:            NWTC_Library.obj  Noise.obj
SetVersion.obj:          NWTC_Library.obj  HydroCalc.obj
FAST_Prog.obj:           NWTC_Library.obj  FAST_Mods.obj  FAST_IO.obj  FAST.obj  FAST2ADAMS.obj  FAST_Lin.obj  HydroCalc.obj  Noise.obj

BladedDLLInterface.obj:               NWTC_Library.obj  FAST_Mods.obj
UserSubs_forBladedDLL.obj:            NWTC_Library.obj
UserVSCont_KP_forBladedDLL.obj:       NWTC_Library.obj


#$(OUTPUT_NAME)$(EXE_EXT): Fast_Prog.obj

   # Make sure the destination directory for the intermediate files exist.

$(INTER_DIR):
	$(MD_CMD) $(INTER_DIR)


   # For linking FAST.

$(DEST_DIR)/$(OUTPUT_NAME)$(EXE_EXT): $(ALL_OBJS) | $(INTER_DIR)
	$(FC) $(LDFLAGS) -I $(INTER_DIR) -o $(DEST_DIR)/$(OUTPUT_NAME)$(EXE_EXT) \
	$(foreach src, $(ALL_OBJS), $(addprefix $(INTER_DIR)/,$(src)))

   # Cleanup afterwards.

clean:
	$(DEL_CMD) $(INTER_DIR)$(PATH_SEP)*.mod $(INTER_DIR)$(PATH_SEP)*.obj

