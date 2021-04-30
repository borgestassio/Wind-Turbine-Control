!  FAST_RT_DLL.f90
! (c) 2009, 2012 National Renewable Energy Laboratory
!  Paul Fleming, National Wind Technology Center, September 2009, October 2012
!  Bonnie Jonkman, National Wind Technology Center, October 2012, January 2013
!
!  Modification of FAST for Labview RT
!  Also includes code from FAST_Simulink Adaptation
!====================================================================================

SUBROUTINE FAST_RT_DLL_INIT (FileName_RT_Byte, FLen)

  ! Expose subroutine FAST_RT_DLL_INIT to users of this DLL
  !
  !DEC$ ATTRIBUTES DLLEXPORT::FAST_RT_DLL_INIT

   USE                     NWTC_Library
   USE                     General, ONLY : PriFile, Cmpl4LV, SumPrint

   USE                     FAST_IO_Subs  ! FAST_Input(), FAST_Begin()
   USE                     FASTSubs      ! FAST_Initialize()
   USE                     SimCont
   
               ! This sub-routine is called by RT to initialize all internal variables

   IMPLICIT                NONE

   INTEGER, PARAMETER         :: MaxFileNameLen = 100
   INTEGER(B1Ki)              :: FileName_RT_Byte(MaxFileNameLen)   ! FileName_RT_Byte

   CHARACTER(MaxFileNameLen)  :: FileName_RT_Char        ! FileName_RT_Byte converted to ASCII characters
   INTEGER                    :: FLen                    ! trim length of FileName_RT_Byte
   INTEGER                    :: I                       ! temporary loop counter



      !Set compiler flag for Simulink

   Cmpl4LV   = .TRUE.


      ! Initialize the NWTC Library (set Pi constants)

   CALL NWTC_Init()

   CALL SetVersion()    ! Set the Program name
   CALL DispNVD()

      ! Set the name of the input file

   IF (FLen > MaxFileNameLen ) CALL ProgAbort('File name is too long in FAST_RT_DLL_INIT.')
   DO I=1,FLen
      FileName_RT_Char(I:I) = ACHAR(FileName_RT_Byte(I))
   END DO
   ! old method:
   !EQUIVALENCE(FileName_RT_Byte2,FileName_RT_Char)  !Make the character filename equivalent to incoming filename byte array

   !FileName_RT_Byte2(:) = FileName_RT_Byte(:)

      ! Set Step and ZTime, in case we're starting over:
      
   Step = 0
   ZTime = 0.0

      !Assign PriFile based on passed in string

   PriFile = FileName_RT_Char(1:FLen)
   

      ! Open and read input files, initialize global parameters.

   CALL FAST_Begin()


   CALL FAST_Input()


      ! Set up initial values for all degrees of freedom.

   CALL FAST_Initialize()


      !----------------------------------------------------------------------------------------------
      ! Print summary information to "*.fsm"?                                    [ see FASTProg.f90 ]
      !----------------------------------------------------------------------------------------------

   IF ( SumPrint )  CALL PrintSum()


      !----------------------------------------------------------------------------------------------
      ! Set up output file format.                                       [ see FAST.f90/TimeMarch() ]
      !----------------------------------------------------------------------------------------------

   CALL WrOutHdr()

      !----------------------------------------------------------------------------------------------
      ! Initialize the simulation status.                                [ see FAST.f90/TimeMarch() ]
      !----------------------------------------------------------------------------------------------

   CALL WrScr ( ' ' )
   CALL SimStatus()


END SUBROUTINE FAST_RT_DLL_INIT

!====================================================================================
SUBROUTINE FAST_RT_DLL_SIM (BlPitchCom_RT, YawPosCom_RT, YawRateCom_RT, ElecPwr_RT, GenTrq_RT, OutData_RT, Time_RT, HSSBrFrac_RT)


  ! Expose subroutine FAST_RT_DLL_SIM to users of this DLL
  !
  !DEC$ ATTRIBUTES DLLEXPORT::FAST_RT_DLL_SIM


   USE                             SimCont      !ZTime

   ! These are needed for FirstTime = .FALSE.
   USE                             DriveTrain   ! GenTrq and now also HSSBrFrac
   USE                             TurbCont     ! BlPitch
   USE                             TurbConf     ! NumBl
   USE                             Blades       ! TipNode
   USE                             Precision    ! ReKi
   USE                             Features     ! CompAero
   USE                             Output       ! for WrOutHdr

   USE                             FASTSubs     ! TimeMarch()
   USE                             General

   USE                             DOFs
   USE                             SimCont
   USE                             FAST_IO_Subs       ! WrOutHdr(),  SimStatus(), WrOutput()
   USE                             NOISE              ! PredictNoise(), WriteAveSpecOut()



   IMPLICIT                NONE


         !  This sub-routine implements n-iterations of time step and returns outputs to Labview RT

   ! Variables
   REAL(ReKi), INTENT(IN)       :: GenTrq_RT                          ! Mechanical generator torque.
   REAL(ReKi), INTENT(IN)       :: ElecPwr_RT                         ! Electrical power
   REAL(ReKi), INTENT(IN)       :: YawPosCom_RT                       ! Yaw position
   REAL(ReKi), INTENT(IN)       :: YawRateCom_RT                      ! Yaw rate
   REAL(ReKi), INTENT(IN)       :: BlPitchCom_RT  (*)
   REAL(ReKi), INTENT(OUT)      :: OutData_RT  (*)
   REAL(ReKi), INTENT(OUT)      :: Time_RT
   REAL(ReKi), INTENT(IN)       :: HSSBrFrac_RT                       ! Brake Fraction

   ! Local variables.

   REAL(ReKi), SAVE                :: TiLstPrn  = 0.0                           ! The time of the last print.


      ! Copy in inputs from RT

   BlPitchCom = BlPitchCom_RT(1:NumBl)
   YawPosCom = YawPosCom_RT
   YawRateCom = YawRateCom_RT
   ElecPwr = ElecPwr_RT
   GenTrq= GenTrq_RT
   HSSBrFrac = HSSBrFrac_RT


      ! Set the command pitch angles to the actual pitch angles since we have no
      ! built-in pitch actuator:

   BlPitch = BlPitchCom


      ! Run simulation
!-------------------------------------------------------------------------
! code copied from DO LOOP in TimeMarch()
!-------------------------------------------------------------------------

   ! Call predictor-corrector routine:

   CALL Solver()


   ! Make sure the rotor azimuth is not greater or equal to 360 degrees:

   IF ( ( Q(DOF_GeAz,IC(1)) + Q(DOF_DrTr,IC(1)) ) >= TwoPi )  THEN
      Q(DOF_GeAz,IC(1)) = Q(DOF_GeAz,IC(1)) - TwoPi
   ENDIF


   ! Advance time:

   Step  = Step + 1
   ZTime = Step*DT


   ! Compute all of the output channels and fill in the OutData() array:

   CALL CalcOuts()


   ! Check to see if we should output data this time step:

   IF ( ZTime >= TStart )  THEN
      IF ( CompNoise                 )  CALL PredictNoise
      IF ( MOD( Step, DecFact ) == 0 )  CALL WrOutput
   ENDIF


   ! Display simulation status every SttsTime-seconds:

   IF ( ZTime - TiLstPrn >= SttsTime )  THEN

      TiLstPrn = ZTime

      CALL SimStatus()

   ENDIF

!-------------------------------------------------------------------------

      ! Copy outputs

   OutData_RT(1:NumOuts) = OutData(1:NumOuts)
   Time_RT = ZTime;
   OutData_RT(NumOuts+1) = TMax;
   OutData_RT(NumOuts+2) = Time_RT;

END SUBROUTINE FAST_RT_DLL_SIM
!====================================================================================
SUBROUTINE FAST_RT_DLL_END ( )
!  This subroutine cleans up the memory that was allocated during the
!  simulation and closes any files that may be open.
!----------------------------------------------------------------------------------------------------


  ! Expose subroutine FAST_RT_DLL_END to users of this DLL
  !
  !DEC$ ATTRIBUTES DLLEXPORT::FAST_RT_DLL_END



   USE             AeroDyn,      ONLY: AD_Terminate

   USE             FAST_IO_Subs, ONLY: RunTimes, WrBinOutput
   USE             FASTSubs,     ONLY: FAST_Terminate
   USE             Features,     ONLY: CompNoise
   USE             General
   USE             HydroDyn
   USE             Noise,        ONLY: WriteAveSpecOut, Noise_Terminate
   USE             Output

   IMPLICIT NONE

   INTEGER                          :: ErrStat
   CHARACTER(1024)                  :: ErrMsg


   IF ( CompNoise )  CALL WriteAveSpecOut()  ! [  FAST.f90\TimeMarch() ]

   !CALL RunTimes( )                          ! [  FAST_Prog.f90 ] !If not initialized, these numbers don't mean anything

      ! Output the binary file if requested

   IF (WrBinOutFile) THEN
      CALL WrBinOutput(UnOuBin, OutputFileFmtID, FileDesc, OutParam(:)%Name, OutParam(:)%Units, TimeData, &
                        AllOutData(:,1:CurrOutStep), ErrStat, ErrMsg)

      IF ( ErrStat /= ErrID_None ) THEN
         CALL WrScr( 'Error '//Num2LStr(ErrStat)//' writing binary output file: '//TRIM(ErrMsg) )
      END IF
   END IF


   CALL FAST_Terminate(ErrStat)                 ! [  FAST_Prog.f90 ]
   CALL AD_Terminate(ErrStat)                   ! [  FAST_Prog.f90 ]
   CALL Hydro_Terminate( )                      ! [  FAST_Prog.f90 ]
   CALL Noise_Terminate( )                      ! [  FAST_Prog.f90 ]


   RETURN

END SUBROUTINE FAST_RT_DLL_END
!====================================================================================
