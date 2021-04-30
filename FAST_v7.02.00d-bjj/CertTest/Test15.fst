--------------------------------------------------------------------------------
------- FAST INPUT FILE --------------------------------------------------------
FAST certification Test #15: FAST model of a SWRT 3-bladed upwind turbine.  Note- SWRT rotates in CCW direction- some inputs will be mirror image of the actual turbine.
Model properties from "SWRTv1p2.adm" and SWRT "AdamsWT_MakeBladeDat_v12.xls".  JEM Jan., 2004.  Updated by J. Jonkman, NREL, Feb, 2004.  Compatible with FAST v7.02.00.
---------------------- SIMULATION CONTROL --------------------------------------
False       Echo        - Echo input data to "echo.out" (flag)
   3        ADAMSPrep   - ADAMS preprocessor mode {1: Run FAST, 2: use FAST as a preprocessor to create an ADAMS model, 3: do both} (switch)
   1        AnalMode    - Analysis mode {1: Run a time-marching simulation, 2: create a periodic linearized model} (switch)
   3        NumBl       - Number of blades (-)
  20.0      TMax        - Total run time (s)
   0.001    DT          - Integration time step (s)
---------------------- TURBINE CONTROL -----------------------------------------
   0        YCMode      - Yaw control mode {0: none, 1: user-defined from routine UserYawCont, 2: user-defined from Simulink/Labview} (switch)
9999.9      TYCOn       - Time to enable active yaw control (s) [unused when YCMode=0]
   0        PCMode      - Pitch control mode {0: none, 1: user-defined from routine PitchCntrl, 2: user-defined from Simulink/Labview} (switch)
9999.9      TPCOn       - Time to enable active pitch control (s) [unused when PCMode=0]
   2        VSContrl    - Variable-speed control mode {0: none, 1: simple VS, 2: user-defined from routine UserVSCont, 3: user-defined from Simulink/Labview} (switch)
9999.9      VS_RtGnSp   - Rated generator speed for simple variable-speed generator control (HSS side) (rpm) [used only when VSContrl=1]
9999.9      VS_RtTq     - Rated generator torque/constant generator torque in Region 3 for simple variable-speed generator control (HSS side) (N-m) [used only when VSContrl=1]
9999.9      VS_Rgn2K    - Generator torque constant in Region 2 for simple variable-speed generator control (HSS side) (N-m/rpm^2) [used only when VSContrl=1]
9999.9      VS_SlPc     - Rated generator slip percentage in Region 2 1/2 for simple variable-speed generator control (%) [used only when VSContrl=1]
   1        GenModel    - Generator model {1: simple, 2: Thevenin, 3: user-defined from routine UserGen} (switch) [used only when VSContrl=0]
True        GenTiStr    - Method to start the generator {T: timed using TimGenOn, F: generator speed using SpdGenOn} (flag)
True        GenTiStp    - Method to stop the generator {T: timed using TimGenOf, F: when generator power = 0} (flag)
9999.9      SpdGenOn    - Generator speed to turn on the generator for a startup (HSS speed) (rpm) [used only when GenTiStr=False]
   0.0      TimGenOn    - Time to turn on the generator for a startup (s) [used only when GenTiStr=True]
9999.9      TimGenOf    - Time to turn off the generator (s) [used only when GenTiStp=True]
   1        HSSBrMode   - HSS brake model {1: simple, 2: user-defined from routine UserHSSBr, 3: user-defined from Labview} (switch)
9999.9      THSSBrDp    - Time to initiate deployment of the HSS brake (s)
9999.9      TiDynBrk    - Time to initiate deployment of the dynamic generator brake [CURRENTLY IGNORED] (s)
9999.9      TTpBrDp(1)  - Time to initiate deployment of tip brake 1 (s)
9999.9      TTpBrDp(2)  - Time to initiate deployment of tip brake 2 (s)
9999.9      TTpBrDp(3)  - Time to initiate deployment of tip brake 3 (s) [unused for 2 blades]
9999.9      TBDepISp(1) - Deployment-initiation speed for the tip brake on blade 1 (rpm)
9999.9      TBDepISp(2) - Deployment-initiation speed for the tip brake on blade 2 (rpm)
9999.9      TBDepISp(3) - Deployment-initiation speed for the tip brake on blade 3 (rpm) [unused for 2 blades]
9999.9      TYawManS    - Time to start override yaw maneuver and end standard yaw control (s)
9999.9      TYawManE    - Time at which override yaw maneuver reaches final yaw angle (s)
   0.0      NacYawF     - Final yaw angle for yaw maneuvers (degrees)
9999.9      TPitManS(1) - Time to start override pitch maneuver for blade 1 and end standard pitch control (s)
9999.9      TPitManS(2) - Time to start override pitch maneuver for blade 2 and end standard pitch control (s)
9999.9      TPitManS(3) - Time to start override pitch maneuver for blade 3 and end standard pitch control (s) [unused for 2 blades]
9999.9      TPitManE(1) - Time at which override pitch maneuver for blade 1 reaches final pitch (s)
9999.9      TPitManE(2) - Time at which override pitch maneuver for blade 2 reaches final pitch (s)
9999.9      TPitManE(3) - Time at which override pitch maneuver for blade 3 reaches final pitch (s) [unused for 2 blades]
  11.44     BlPitch(1)  - Blade 1 initial pitch (degrees)
  11.44     BlPitch(2)  - Blade 2 initial pitch (degrees)
  11.44     BlPitch(3)  - Blade 3 initial pitch (degrees) [unused for 2 blades]
  11.44     BlPitchF(1) - Blade 1 final pitch for pitch maneuvers (degrees)
  11.44     BlPitchF(2) - Blade 2 final pitch for pitch maneuvers (degrees)
  11.44     BlPitchF(3) - Blade 3 final pitch for pitch maneuvers (degrees) [unused for 2 blades]
---------------------- ENVIRONMENTAL CONDITIONS --------------------------------
   9.81     Gravity     - Gravitational acceleration (m/s^2)
---------------------- FEATURE FLAGS -------------------------------------------
True        FlapDOF1    - First flapwise blade mode DOF (flag)
True        FlapDOF2    - Second flapwise blade mode DOF (flag)
True        EdgeDOF     - First edgewise blade mode DOF (flag)
False       TeetDOF     - Rotor-teeter DOF (flag) [unused for 3 blades]
False       DrTrDOF     - Drivetrain rotational-flexibility DOF (flag)
True        GenDOF      - Generator DOF (flag)
True        YawDOF      - Yaw DOF (flag)
False       TwFADOF1    - First fore-aft tower bending-mode DOF (flag)
False       TwFADOF2    - Second fore-aft tower bending-mode DOF (flag)
False       TwSSDOF1    - First side-to-side tower bending-mode DOF (flag)
False       TwSSDOF2    - Second side-to-side tower bending-mode DOF (flag)
True        CompAero    - Compute aerodynamic forces (flag)
False       CompNoise   - Compute aerodynamic noise (flag)
---------------------- INITIAL CONDITIONS --------------------------------------
   0.0      OoPDefl     - Initial out-of-plane blade-tip displacement (meters)
   0.0      IPDefl      - Initial in-plane blade-tip deflection (meters)
   0.0      TeetDefl    - Initial or fixed teeter angle (degrees) [unused for 3 blades]
   0.0      Azimuth     - Initial azimuth angle for blade 1 (degrees)
 188.0      RotSpeed    - Initial or fixed rotor speed (rpm)
   0.0      NacYaw      - Initial or fixed nacelle-yaw angle (degrees)
   0.0      TTDspFA     - Initial fore-aft tower-top displacement (meters)
   0.0      TTDspSS     - Initial side-to-side tower-top displacement (meters)
---------------------- TURBINE CONFIGURATION -----------------------------------
   2.90     TipRad      - The distance from the rotor apex to the blade tip (meters)
   0.303    HubRad      - The distance from the rotor apex to the blade root (meters)
   1        PSpnElN     - Number of the innermost blade element which is still part of the pitchable portion of the blade for partial-span pitch control [1 to BldNodes] [CURRENTLY IGNORED] (-)
   0.0      UndSling    - Undersling length [distance from teeter pin to the rotor apex] (meters) [unused for 3 blades]
   0.1536   HubCM       - Distance from rotor apex to hub mass [positive downwind] (meters)
  -0.7456   OverHang    - Distance from yaw axis to rotor apex [3 blades] or teeter pin [2 blades] (meters)
  -0.2307   NacCMxn     - Downwind distance from the tower-top to the nacelle CM (meters)
   0.0910   NacCMyn     - Lateral  distance from the tower-top to the nacelle CM (meters)
   0.5475   NacCMzn     - Vertical distance from the tower-top to the nacelle CM (meters)
  34.0      TowerHt     - Height of tower above ground level [onshore] or MSL [offshore] (meters)
   0.515112 Twr2Shft    - Vertical distance from the tower-top to the rotor shaft (meters)
   0.0      TwrRBHt     - Tower rigid base height (meters)
  -8.0      ShftTilt    - Rotor shaft tilt angle (degrees).  Negative for an upwind rotor.
   0.0      Delta3      - Delta-3 angle for teetering rotors (degrees) [unused for 3 blades]
   0.0      PreCone(1)  - Blade 1 cone angle (degrees)
   0.0      PreCone(2)  - Blade 2 cone angle (degrees)
   0.0      PreCone(3)  - Blade 3 cone angle (degrees) [unused for 2 blades]
   0.0      AzimB1Up    - Azimuth value to use for I/O when blade 1 points up (degrees)
---------------------- MASS AND INERTIA ----------------------------------------
   0.0      YawBrMass   - Yaw bearing mass (kg)
 260.5      NacMass     - Nacelle mass (kg)
 113.0      HubMass     - Hub mass (kg)
   0.0      TipMass(1)  - Tip-brake mass, blade 1 (kg)
   0.0      TipMass(2)  - Tip-brake mass, blade 2 (kg)
   0.0      TipMass(3)  - Tip-brake mass, blade 3 (kg) [unused for 2 blades]
  39.81     NacYIner    - Nacelle inertia about yaw axis (kg m^2)
   0.5      GenIner     - Generator inertia about HSS (kg m^2)
   7.71     HubIner     - Hub inertia about rotor axis [3 blades] or teeter axis [2 blades] (kg m^2)
---------------------- DRIVETRAIN ----------------------------------------------
 100.0      GBoxEff     - Gearbox efficiency (%)
  83.0      GenEff      - Generator efficiency [ignored by the Thevenin and user-defined generator models] (%)
   1.0      GBRatio     - Gearbox ratio (-)
False       GBRevers    - Gearbox reversal {T: if rotor and generator rotate in opposite directions} (flag)
9999.9      HSSBrTqF    - Fully deployed HSS-brake torque (N-m)
9999.9      HSSBrDT     - Time for HSS-brake to reach full deployment once initiated (sec) [used only when HSSBrMode=1]
"unused"    DynBrkFi    - File containing a mech-gen-torque vs HSS-speed curve for a dynamic brake [CURRENTLY IGNORED] (quoted string)
9999.9      DTTorSpr    - Drivetrain torsional spring (N-m/rad)
9999.9      DTTorDmp    - Drivetrain torsional damper (N-m/(rad/s))
---------------------- SIMPLE INDUCTION GENERATOR ------------------------------
9999.9      SIG_SlPc    - Rated generator slip percentage (%) [used only when VSContrl=0 and GenModel=1]
9999.9      SIG_SySp    - Synchronous (zero-torque) generator speed (rpm) [used only when VSContrl=0 and GenModel=1]
9999.9      SIG_RtTq    - Rated torque (N-m) [used only when VSContrl=0 and GenModel=1]
9999.9      SIG_PORt    - Pull-out ratio (Tpullout/Trated) (-) [used only when VSContrl=0 and GenModel=1]
---------------------- THEVENIN-EQUIVALENT INDUCTION GENERATOR -----------------
9999.9      TEC_Freq    - Line frequency [50 or 60] (Hz) [used only when VSContrl=0 and GenModel=2]
9998        TEC_NPol    - Number of poles [even integer > 0] (-) [used only when VSContrl=0 and GenModel=2]
9999.9      TEC_SRes    - Stator resistance (ohms) [used only when VSContrl=0 and GenModel=2]
9999.9      TEC_RRes    - Rotor resistance (ohms) [used only when VSContrl=0 and GenModel=2]
9999.9      TEC_VLL     - Line-to-line RMS voltage (volts) [used only when VSContrl=0 and GenModel=2]
9999.9      TEC_SLR     - Stator leakage reactance (ohms) [used only when VSContrl=0 and GenModel=2]
9999.9      TEC_RLR     - Rotor leakage reactance (ohms) [used only when VSContrl=0 and GenModel=2]
9999.9      TEC_MR      - Magnetizing reactance (ohms) [used only when VSContrl=0 and GenModel=2]
---------------------- PLATFORM ------------------------------------------------
   0        PtfmModel   - Platform model {0: none, 1: onshore, 2: fixed bottom offshore, 3: floating offshore} (switch)
"unused"    PtfmFile    - Name of file containing platform properties (quoted string) [unused when PtfmModel=0]
---------------------- TOWER ---------------------------------------------------
  10        TwrNodes    - Number of tower nodes used for analysis (-)
"SWRT_Tower.dat"        TwrFile - Name of file containing tower properties (quoted string)
---------------------- NACELLE-YAW ---------------------------------------------
   0.0      YawSpr      - Nacelle-yaw spring constant (N-m/rad)
   0.0      YawDamp     - Nacelle-yaw damping constant (N-m/(rad/s))
   0.0      YawNeut     - Neutral yaw position--yaw spring force is zero at this yaw (degrees)
---------------------- FURLING -------------------------------------------------
True        Furling     - Read in additional model properties for furling turbine (flag)
"SWRT_Furl.dat"         FurlFile    - Name of file containing furling properties (quoted string) [unused when Furling=False]
---------------------- ROTOR-TEETER --------------------------------------------
   0        TeetMod     - Rotor-teeter spring/damper model {0: none, 1: standard, 2: user-defined from routine UserTeet} (switch) [unused for 3 blades]
   0.0      TeetDmpP    - Rotor-teeter damper position (degrees) [used only for 2 blades and when TeetMod=1]
   0.0      TeetDmp     - Rotor-teeter damping constant (N-m/(rad/s)) [used only for 2 blades and when TeetMod=1]
   0.0      TeetCDmp    - Rotor-teeter rate-independent Coulomb-damping moment (N-m) [used only for 2 blades and when TeetMod=1]
   0.0      TeetSStP    - Rotor-teeter soft-stop position (degrees) [used only for 2 blades and when TeetMod=1]
   0.0      TeetHStP    - Rotor-teeter hard-stop position (degrees) [used only for 2 blades and when TeetMod=1]
   0.0      TeetSSSp    - Rotor-teeter soft-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]
   0.0      TeetHSSp    - Rotor-teeter hard-stop linear-spring constant (N-m/rad) [used only for 2 blades and when TeetMod=1]
---------------------- TIP-BRAKE -----------------------------------------------
   0.0      TBDrConN    - Tip-brake drag constant during normal operation, Cd*Area (m^2)
   0.0      TBDrConD    - Tip-brake drag constant during fully-deployed operation, Cd*Area (m^2)
   0.0      TpBrDT      - Time for tip-brake to reach full deployment once released (sec)
---------------------- BLADE ---------------------------------------------------
"SWRT_Blade.dat"        BldFile(1)  - Name of file containing properties for blade 1 (quoted string)
"SWRT_Blade.dat"        BldFile(2)  - Name of file containing properties for blade 2 (quoted string)
"SWRT_Blade.dat"        BldFile(3)  - Name of file containing properties for blade 3 (quoted string) [unused for 2 blades]
---------------------- AERODYN -------------------------------------------------
"Test15_AD.ipt"         ADFile      - Name of file containing AeroDyn input parameters (quoted string)
---------------------- NOISE ---------------------------------------------------
"unused"   NoiseFile   - Name of file containing aerodynamic noise input parameters (quoted string) [used only when CompNoise=True]
---------------------- ADAMS ---------------------------------------------------
"SWRT_ADAMS.dat"        ADAMSFile   - Name of file containing ADAMS-specific input parameters (quoted string) [unused when ADAMSPrep=1]
---------------------- LINEARIZATION CONTROL -----------------------------------
"SWRT_Linear.dat"       LinFile     - Name of file containing FAST linearization parameters (quoted string) [unused when AnalMode=1]
---------------------- OUTPUT --------------------------------------------------
True        SumPrint    - Print summary data to "<RootName>.fsm" (flag)
1           OutFileFmt  - Format for tabular (time-marching) output file(s) (1: text file [<RootName>.out], 2: binary file [<RootName>.outb], 3: both) (switch)
True        TabDelim    - Use tab delimiters in text tabular output file? (flag)
"ES10.3E2"  OutFmt      - Format used for text tabular output (except time).  Resulting field should be 10 characters. (quoted string)  [not checked for validity!]
   5.0      TStart      - Time to begin tabular output (s)
   8        DecFact     - Decimation factor for tabular output {1: output every time step} (-)
   1.0      SttsTime    - Amount of time between screen status messages (sec)
   0.0      NcIMUxn     - Downwind distance from the tower-top to the nacelle IMU (meters)
   0.0      NcIMUyn     - Lateral  distance from the tower-top to the nacelle IMU (meters)
   0.0      NcIMUzn     - Vertical distance from the tower-top to the nacelle IMU (meters)
   0.1      ShftGagL    - Distance from rotor apex [3 blades] or teeter pin [2 blades] to shaft strain gages [positive for upwind rotors] (meters)
   0        NTwGages    - Number of tower nodes that have strain gages for output [0 to 9] (-)
   0        TwrGagNd    - List of tower nodes that have strain gages [1 to TwrNodes] (-) [unused if NTwGages=0]
   0        NBlGages    - Number of blade nodes that have strain gages for output [0 to 9] (-)
   0        BldGagNd    - List of blade nodes that have strain gages [1 to BldNodes] (-) [unused if NBlGages=0]
            OutList     - The next line(s) contains a list of output parameters.  See OutList.xlsx for a listing of available output channels, (-)
"uWind, vWind, wWind"               - Downwind, crosswind, and vertical wind speeds
"TipClrnc1, TipClrnc2, TipClrnc3"   - Tip-to-tower clearances of each blade
"RotSpeed, TSR"                     - Rotor speed and blade tip speed ratio
"TailFurlP, TailFurlV, TailFurlA"   - Tail-furl position (angle), velocity, and acceleration
"NacYawP"                           - Nacelle yaw position (angle)
"RotThrust"                         - Rotor thrust
"CThrstAzm, CThrstRad"              - Center of thrust azimuth and radial location
"RotCq, RotCp, RotCt"               - Rotor torque, power, and thrust coefficients
"TFrlBrM"                           - Tail-furl bearing moment
"TFinAlpha, TFinCLift, TFinCDrag"   - Tail fin AoA and lift and drag coefficients
"TFinDnPrs, TFinCPFx, TFinCPFy"     - Tail fin dynamic pressure and tangential and normal forces
END of FAST input file (the word "END" must appear in the first 3 columns of this last line).
--------------------------------------------------------------------------------


