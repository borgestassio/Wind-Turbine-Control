MODULE FAST_Simulink_Mod

   USE      NWTC_Library

   IMPLICIT NONE

   INTEGER, PARAMETER         :: mxDB = 8                   ! Matlab requires double-precision reals

    REAL(ReKi), SAVE, PRIVATE :: TiLstPrn  = 0.0            ! from TimeMarch  The time of the last print.
  LOGICAL,      SAVE, PRIVATE :: InitializedFlag = .FALSE.



CONTAINS

!====================================================================================================
SUBROUTINE BlockOUTPUT(NumBl, NDOF, NumOuts, T, U, Y)
!----------------------------------------------------------------------------------------------------
!     Abstract:
!       Function to return continuous outputs
!----------------------------------------------------------------------------------------------------

   REAL(mxDB), INTENT(IN)     :: T                                      ! Time
   REAL(mxDB), INTENT(IN)     :: U(*)                                   ! Input vector
   REAL(mxDB), INTENT(INOUT)  :: Y(*)                                   ! Output vector
   REAL(ReKi)                 :: BlPitchCom_s  (NumBl)                  ! Blade pitch                                       (input from Simulink)
   REAL(ReKi)                 :: ElecPwr_s                              ! Electrical power                                  (input from Simulink)
   REAL(ReKi)                 :: GenTrq_s                               ! Electrical generator torque.                      (input from Simulink)
   REAL(ReKi)                 :: OutData_s     (NumOuts)                ! The requested FAST output                         (output to Simulink)
   REAL(ReKi)                 :: QDT_s         (NDOF)                   ! Current estimate of QD.                           (input from Simulink)
   REAL(ReKi)                 :: QD2T_s        (NDOF)                   ! Current estimate of QD2                           (output to Simulink)
   REAL(ReKi)                 :: QT_s          (NDOF)                   ! Current estimate of Q for each degree of freedom. (input from Simulink)
   REAL(ReKi)                 :: Time                                   ! The input time                                    (input from Simulink)
   REAL(ReKi)                 :: YawPosCom_s                            ! Yaw position                                      (input from Simulink)
   REAL(ReKi)                 :: YawRateCom_s                           ! Yaw rate                                          (input from Simulink)

   INTEGER(4),INTENT(IN)      :: NumBl
   INTEGER(4),INTENT(IN)      :: NDOF
   INTEGER(4),INTENT(IN)      :: NumOuts
   INTEGER  BlP_start, BlP_end, QT_start, QT_end, QDT_start, QDT_end ! Indices for input vector


      !----------------------------------------------------------------------------------------------
      ! Check that we're initialized first
      !----------------------------------------------------------------------------------------------
   IF ( .NOT. InitializedFlag ) THEN
      CALL ProgAbort( 'FAST must be initialized before calculating output values.' )
! or, get input file and       
!      CALL FAST_Init(InpFile)
   END IF


      !----------------------------------------------------------------------------------------------
      ! Define where the specific inputs are located in the INPUT vector
      !----------------------------------------------------------------------------------------------

   BlP_start      = 4       + 1                             ! Starting index of blade pitch
   BlP_end        = 4       + NumBl                         ! Ending index of blade pitch
   QT_start       = BlP_end + 1                          
   QT_end         = BlP_end + NDOF
   QDT_start      = QT_end  + 1
   QDT_end        = QT_end  + NDOF

   GenTrq_s       = REAL(U(1), ReKi)
   ElecPwr_s      = REAL(U(2), ReKi)
   YawPosCom_s    = REAL(U(3), ReKi)
   YawRateCom_s   = REAL(U(4), ReKi)
   BlPitchCom_s   = REAL(U(BlP_start:BlP_end), ReKi)
   QT_s           = REAL(U(QT_start :QT_end ), ReKi)
   QDT_s          = REAL(U(QDT_start:QDT_end), ReKi)

   Time           = REAL(T, ReKi)

!call wrscr('ZTime='//TRIM(Flt2Lstr(Time))//' QT(13)='//TRIM(Flt2Lstr( QT_s(13) ))   )

      !----------------------------------------------------------------------------------------------
      ! Call the FAST dynamics routines for this time step
      !----------------------------------------------------------------------------------------------

   CALL FASTDynamics(Time, QT_s, QDT_s, BlPitchCom_s, YawPosCom_s, YawRateCom_s, ElecPwr_s, GenTrq_s,  QD2T_s, OutData_s)


      !----------------------------------------------------------------------------------------------
      ! Update the OUTPUT vector for MATLAB
      !----------------------------------------------------------------------------------------------

   Y(1:NDOF)              = REAL(QD2T_s(:),    mxDB)
   Y(NDOF+1:NDOF+NumOuts) = REAL(OutData_s(:), mxDB)

   RETURN

END SUBROUTINE BlockOUTPUT

!====================================================================================================
SUBROUTINE FAST_End
!----------------------------------------------------------------------------------------------------
!  This subroutine cleans up the memory that was allocated during the
!  simulation and closes any files that may be open.
!----------------------------------------------------------------------------------------------------

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
   
   

   IF ( InitializedFlag ) THEN
      IF ( CompNoise )  CALL WriteAveSpecOut()  ! [  FAST.f90\TimeMarch() ]

      CALL RunTimes( )                          ! [  FAST_Prog.f90 ] !If not initialized, these numbers don't mean anything
      
         ! Output the binary file if requested
      
      IF (WrBinOutFile) THEN
         CALL WrBinOutput(UnOuBin, OutputFileFmtID, FileDesc, OutParam(:)%Name, OutParam(:)%Units, TimeData, & 
                           AllOutData(:,1:CurrOutStep), ErrStat, ErrMsg)

         IF ( ErrStat /= ErrID_None ) THEN
            CALL WrScr( 'Error '//Num2LStr(ErrStat)//' writing binary output file: '//TRIM(ErrMsg) )
         END IF      
      END IF
      
      
   END IF
   
   CALL FAST_Terminate(ErrStat)                 ! [  FAST_Prog.f90 ]
   CALL AD_Terminate(ErrStat)                   ! [  FAST_Prog.f90 ]
   CALL Hydro_Terminate( )                      ! [  FAST_Prog.f90 ]
   CALL Noise_Terminate( )                      ! [  FAST_Prog.f90 ]


   InitializedFlag = .FALSE.
   TiLstPrn        = 0.0      
   CALL WrScr ( ' ' )

   RETURN

END SUBROUTINE FAST_End

!====================================================================================================
SUBROUTINE FASTDYNAMICS (ZTime_s, QT_s, QDT_s, BlPitchCom_s, YawPosCom_s, YawRateCom_s, ElecPwr_s, GenTrq_s, QD2T_s, OutData_s)
!----------------------------------------------------------------------------------------------------
!  This subroutine uses FAST modules and subroutines to compute the turbine dynamic response
!  to wind input through the AeroDyn subroutines.  The inputs include control inputs:
!
!  ZTime_s = simulation time inherited from S-function inport
!  QT_s = DOF displacement
!  QDT_s = DOF velocity
!  BlPitchCom_s = array of commanded blade pitch angles (size based on number of blades)
!  YawPosCom_s = commanded yaw angle
!  YawRateCom_s = commanded yaw rate
!  ElecPwr_s = electrical power
!  GenTrq_s = generator torque
!
!  Outputs from this subroutine that are transmitted back to Matlab include:
!
!  Output(1:NDOF) = QD2_s = DOF acceleration
!  Output(NDOF+1:NDOF+NumOuts) = OutData_s = Output channels specified in FAST input file
!
!  This program models 2- or 3-bladed turbines of a standard configuration.
!----------------------------------------------------------------------------------------------------

  !USE                             NWTC_Library

   USE                             DriveTrain,  ONLY: GenTrq, ElecPwr
   USE                             DOFs,        ONLY: NDoF
   USE                             Features,    ONLY: CompNoise
   USE                             Output,      ONLY: TStart, DecFact, OutData, NumOuts
   USE                             RtHndSid,    ONLY: QT, QDT, QD2T
   USE                             SimCont,     ONLY: DT, ZTime, Step
   USE                             TurbConf,    ONLY: NumBl
   USE                             TurbCont,    ONLY: YawPosCom, YawRateCom, BlPitchCom
   USE                             Noise,       ONLY: PredictNoise
   USE                             FAST_IO_Subs,ONLY: WrOutput
   USE                             FASTsubs,    ONLY: RtHS, CalcOuts

   IMPLICIT                        NONE

   REAL(ReKi), INTENT(IN)          :: QDT_s      (*)                    ! Current estimate of QD.
   REAL(ReKi), INTENT(IN)          :: QT_s       (*)                    ! Current estimate of Q for each degree of freedom.
   REAL(ReKi), INTENT(IN)          :: GenTrq_s                          ! Mechanical generator torque.
   REAL(ReKi), INTENT(IN)          :: ElecPwr_s                         ! Electrical power
   REAL(ReKi), INTENT(IN)          :: YawPosCom_s                       ! Yaw position
   REAL(ReKi), INTENT(IN)          :: YawRateCom_s                      ! Yaw rate
   REAL(ReKi), INTENT(IN)          :: ZTime_s                           ! Current simulation time.
   REAL(ReKi), INTENT(IN)          :: BlPitchCom_s  (*)
   REAL(ReKi), INTENT(OUT)         :: QD2T_s(*)                         ! The output (QD2T)
   REAL(ReKi), INTENT(OUT)         :: OutData_s(*)                      ! The output (OutData)


      !----------------------------------------------------------------------------------------------
      !  Place Simulink-passed variables in FAST variables
      !----------------------------------------------------------------------------------------------

   ZTime       = ZTime_s
   QT          = QT_s(1:NDOF)
   QDT         = QDT_s(1:NDOF)
   GenTrq      = GenTrq_s
   ElecPwr     = ElecPwr_s
   YawPosCom   = YawPosCom_s
   YawRateCom  = YawRateCom_s
   BlPitchCom  = BlPitchCom_s(1:NumBl)


      !----------------------------------------------------------------------------------------------
      !  Solve equations of motion at this time step                     [ see FAST.f90\TimeMarch() ]
      !----------------------------------------------------------------------------------------------

  !bjj: does it matter that it's called "continuously?" should we only
  ! call these routines if DT has passed?  Perhaps, we should upgrade to
  ! a "Level-2" S-Function so that we can use discrete time?

   CALL RtHS()
   CALL CalcOuts()


      !----------------------------------------------------------------------------------------------
      !  Time-based output, modified for Simulink               [ compare with FAST.f90\TimeMarch() ]
      !  If we've exceeded DT (the integration step), write to the output file
      !----------------------------------------------------------------------------------------------

   IF ( ZTime - TiLstPrn >= DT) THEN  ! FAST uses SttsTime instead of DT

      Step = Step + 1
      TiLstPrn = ZTime

         ! Check to see if we should output data this time step:

      IF ( ZTime >= TStart )  THEN
         IF ( CompNoise                 )  CALL PredictNoise
         IF ( MOD( Step, DecFact ) == 0 )  CALL WrOutput
      ENDIF

   ENDIF


      !----------------------------------------------------------------------------------------------
      !  Place FAST DOF acceleration and outputs into variable for Simulink output
      !----------------------------------------------------------------------------------------------

   QD2T_s(1:NDoF)       = QD2T(1:NDoF)
   OutData_s(1:NumOuts) = OutData(1:NumOuts)  ! OutData(0) = Time

   RETURN

END SUBROUTINE FASTDynamics

!====================================================================================================
SUBROUTINE FAST_Init(InpFile)
!----------------------------------------------------------------------------------------------------
!   This subroutine reads the input files and initializes the FAST variables
!----------------------------------------------------------------------------------------------------

   USE                             General,        ONLY: PriFile, SumPrint, Cmpl4SFun, StrtTime
   USE                             TurbCont,       ONLY: VSContrl, PCMode, YCMode
   USE                             SimCont,        ONLY: UsrTime1
!rm   USE                             SimCont,        ONLY: UsrTime1, UsrTime0
   USE                             FAST_IO_Subs,   ONLY: FAST_Begin, FAST_Input, PrintSum, WrOutHdr, SimStatus
   USE                             FASTSubs,       ONLY: FAST_Initialize
   USE                             Output,         ONLY: OutputFileFmtID, FileFmtID_WithTime

   IMPLICIT NONE


   CHARACTER(*), INTENT(IN)      :: InpFile              ! Name of the FAST input file, retreived from the MATLAB workspace

      !----------------------------------------------------------------------------------------------
      !  Get the first time                                                      [ see FASTProg.f90 ]
      !----------------------------------------------------------------------------------------------

   CALL DATE_AND_TIME ( Values=StrtTime )
   CALL CPU_TIME ( UsrTime1 )


      !----------------------------------------------------------------------------------------------
      !  Initialize some FAST variables                                          [ see FASTProg.f90 ]
      !----------------------------------------------------------------------------------------------

   Cmpl4SFun       = .TRUE.
   OutputFileFmtID = FileFmtID_WithTime      ! We cannot guarantee the output time step is constant in binary files

   CALL SetVersion
   CALL NWTC_Init()                          ! sets the pi constants and open the console for writing
   CALL DispNVD( )
!   CALL WrScr1 ( 'Running '//TRIM(ProgName)//' '//TRIM( ProgVer )//'.' )
      

   PriFile = InpFile

   CALL FAST_Begin()

   CALL FAST_Input()

      !----------------------------------------------------------------------------------------------
      ! Logic to assure input file requests are suitable for Simulink environment
      !---------_-------------------------------------------------------------------------------------

   IF (YCMode   /= 2) CALL ProgWarn ('Yaw angle and rate are not commanded from Simulink model.')
   IF (PCMode   /= 2) CALL ProgWarn ('Pitch angles are not commanded from Simulink model.')
!bjj start of proposed change FAST v6.20d-bjj
!rm   IF (VSContrl /= 3) CALL ProgWarn ('Generator torque are not commanded from Simulink model.')
   IF (VSContrl /= 3) CALL ProgWarn ('Generator torque and power are not commanded from Simulink model.')
!bjj end of proposed change   

      !----------------------------------------------------------------------------------------------
      ! Set up initial values for all degrees of freedom.                        [ see FASTProg.f90 ]
      !----------------------------------------------------------------------------------------------
!call wrscr('Initialize ')

   CALL FAST_Initialize()

      !----------------------------------------------------------------------------------------------
      ! Print summary information to "*.fsm"?                                    [ see FASTProg.f90 ]
      !----------------------------------------------------------------------------------------------

   IF ( SumPrint )  CALL PrintSum()

!bjj start
!rm      !----------------------------------------------------------------------------------------------
!rm      ! Get the current time.                                                    [ see FASTProg.f90 ]
!rm      !----------------------------------------------------------------------------------------------
!rm
!rm   CALL DATE_AND_TIME ( Values=StrtTime )
!rm   CALL CPU_TIME ( UsrTime1 )
!bjj end   

      !----------------------------------------------------------------------------------------------
      ! Set up output file format.                                       [ see FAST.f90/TimeMarch() ]
      !----------------------------------------------------------------------------------------------

   CALL WrOutHdr()

      !----------------------------------------------------------------------------------------------
      ! Initialize the simulation status.                                [ see FAST.f90/TimeMarch() ]
      !----------------------------------------------------------------------------------------------

   CALL WrScr ( ' ' )
   CALL SimStatus()

   InitializedFlag = .TRUE.

   RETURN

END SUBROUTINE FAST_Init
!====================================================================================================
SUBROUTINE Wind_Vel(Time, Position, Velocity, M, N)
!----------------------------------------------------------------------------------------------------
!   This subroutine returns the velocity, V (3 element array), at a location specified by the
!  3-column position array, X.
!----------------------------------------------------------------------------------------------------

   USE                           AeroDyn

   INTEGER, INTENT(IN)        :: M
   INTEGER, INTENT(IN)        :: N

   REAL(mxDB), INTENT(IN)     :: Time
   REAL(mxDB), INTENT(IN)     :: Position(M,N)
   REAL(mxDB), INTENT(OUT)    :: Velocity(M,N)
   
   
   REAL(ReKi)                 :: InputPosition(3)
   
   INTEGER                    :: ErrStat
   INTEGER                    :: ITime
   

!   IF ( N /= 3 ) CALL ProgAbort( ' Invalid array size in Wind_Vel().' )

   DO ITime = 1,M
                     
!     Time          = TimeAry( MIN(ITime, NT) )   
                  
      InputPosition = Position( MIN(ITime,M), : ) 
   
!call wrscr(trim(flt2lstr(inputposition(1)))//' '//trim(flt2lstr(inputposition(2)))//' '//trim(flt2lstr(inputposition(3))) )  

      Velocity(ITime,:) = AD_GetUndisturbedWind ( Time, InputPosition, ErrStat)
    
      IF (ErrStat /= 0) THEN
         Velocity(ITime,:) = 0.0
      END IF

   END DO
   


END SUBROUTINE Wind_Vel
!====================================================================================================
END MODULE FAST_Simulink_Mod
