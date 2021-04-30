!****************************************************************************************************
!Gateway program to call FAST from Simulink (Level 1 S-function)
!   Calls FASTSimulink.f90 to solve FAST equations of motion and compute requested output data.
!   This gateway subroutine originated with the MATLAB files simulink.F and sfunctempl_fortran.F.
!   They have been modified to call the FAST routines in FAST_Prog.f90 and FAST.f90.
!----------------------------------------------------------------------------------------------------
!  simulink.F                                                 Copyright 1990-2002 The MathWorks, Inc.
!  Written:                                                            Aleksandar Bozin  Mar 03, 1992
!  Modifications, bug fixes and extensions:                            Ned Gulley        Apr 29, 1992
!----------------------------------------------------------------------------------------------------
!  sfuntmpl_fortran.f                                         Copyright 1990-2002 The MathWorks, Inc.
!  A template for writing Level 1 FORTRAN S-functions.
!----------------------------------------------------------------------------------------------------
!  FAST_Prog.f90, FAST.f90      National Renewable Energy Laboratory, National Wind Technology Center
!                                                                                Jason Jonkman, et al
!----------------------------------------------------------------------------------------------------
!
!   M. Hand                                                     National Wind Technology Center, NREL
!
!   B. Jonkman                                                                    Updated 10-Sep-2009
!                                                              NREL's National Wind Technology Center
!   The routines have been updated to use modern Fortran; unnecessary routines have been eliminiated;
!   the FAST routines have been updated to use the NWTC_Library;
!
!   Calling syntax in Matlab, for the function compiled as FAST_SFunc.mexw32 is:
!      [y1, y2] = FAST_SFunc(t, x, u, FLAG)
!
! After initialization of the Simulink block (and before termination), wind speeds can be accessed 
! by calling FAST_SFunc with FLAG = 99; t = requested time; x = []; and u = [X,Y,Z] where
! size(X)=size(Y)=size(Z)=[n,1]; in this case, the function returns wind speeds y2 = [U,V,W] 
! (an array of size = [n,3])  
!====================================================================================================

SUBROUTINE mexFunction(nlhs, plhs, nrhs, prhs)
!====================================================================================================
!   Purpose:  Glue routine for making FORTRAN MEX-file systems and blocks
!   Algorithm: FAST_SFunc is a MEX-file
!====================================================================================================

   USE                           FAST_Simulink_Mod                
   USE                           Output, ONLY: MaxOutPts          ! FAST module

   IMPLICIT                      NONE

      !----------------------------------------------------------------------------------------------
      ! define parameters
      !----------------------------------------------------------------------------------------------

   INTEGER(4), PARAMETER        :: mxREAL      = 0         ! MATLAB uses 0 for REAL numbers; 1 for COMPLEX
   INTEGER,    PARAMETER        :: mwPointer   = 4         ! Size of pointer variables; replace 4 with 8 on DE! Alpha and the SGI 64-bit platforms
   INTEGER,    PARAMETER        :: mwSize      = 4         ! Size of size variables; replace 4 with 8 on DE! Alpha and the SGI 64-bit platforms
   REAL(mxDB), PARAMETER        :: HUGE        = 1.0E+33
   INTEGER(4), PARAMETER        :: NSIZES      = 6         ! Number of elements in the size array
   
   INTEGER,    PARAMETER        :: MaxDOFs     = 24        ! Maximum number of DOFs:    required b/c of MATLAB R2009b bug that says ALLOCATABLE arrays do not work with mex* and mx* API functions
   INTEGER,    PARAMETER        :: MaxNumBl    = 3         ! Maximum number of blades:  required b/c of MATLAB R2009b bug that says ALLOCATABLE arrays do not work with mex* and mx* API functions
   INTEGER,    PARAMETER        :: MaxInputs   = 4+MaxNumBl+2*MaxDOFs
   INTEGER,    PARAMETER        :: MaxOutputs  = MaxOutPts + MaxDOFs
   INTEGER,    PARAMETER        :: MaxWinds    = MIN( MaxInputs, MaxOutputs )
   
      !----------------------------------------------------------------------------------------------
      ! define right- and left-hand side arguments of the MATLAB function we're creating
      !----------------------------------------------------------------------------------------------

   INTEGER                      :: nlhs                    ! MATLAB's count of the number of left-hand (output) arguments
   INTEGER                      :: nrhs                    ! MATLAB's count of the number of right-hand (input) arguments
   INTEGER(mwPointer)           :: plhs(*)                 ! MATLAB's pointer(s) to left-hand (output) arguments
   INTEGER(mwPointer)           :: prhs(*)                 ! MATLAB's pointer(s) to right-hand (input) arguments

   INTEGER(mwPointer)           :: ptr_T                   ! pointer to input  (RHS) argument #1 (t)
   INTEGER(mwPointer)           :: ptr_X                   ! pointer to input  (RHS) argument #2 (x)
   INTEGER(mwPointer)           :: ptr_U                   ! pointer to input  (RHS) argument #3 (u)
   INTEGER(mwPointer)           :: ptr_Y                   ! pointer to output (LHS) argument #1 (outputs)

   REAL(mxDB)                   :: T                       ! input  argument #1, TIME
!  REAL(mxDB), ALLOCATABLE      :: U       (:)             ! input  argument #2, INPUT ARRAY
   REAL(mxDB)                   :: U (MaxInputs)           ! input  argument #2, INPUT ARRAY
   INTEGER                      :: FLAG                    ! input  argument #4, FLAG
!  REAL(mxDB), ALLOCATABLE      :: Y       (:)             ! output argument #1
   REAL(mxDB)                   :: Y (MaxOutputs)          ! output argument #1, OUTPUT ARRAY

!bjj: MATLAB R2009b says ALLOCATABLE arrays do not work with mex* and mx* API functions!!!!  Workaround: use "fixed size" arrays BOOOOOO!!!!

      !----------------------------------------------------------------------------------------------
      ! define variables from the MATLAB workspace
      !----------------------------------------------------------------------------------------------

   INTEGER(mwPointer)           :: ptr_retrn               ! pointer to Matlab workspace variable
   REAL(mxDB)                   :: retrn_dp                ! real array created from pointer ptr_retrn

   INTEGER                      :: NumBl                   !! Added by M. Hand
   INTEGER                      :: NDOF                    !! Added by M. Hand
   INTEGER                      :: NumOuts                 !! Added by M. Hand
   REAL(mxDB)                   :: Initialized             ! Prevents running Simulink model with old FAST input file
   CHARACTER(1024)              :: InpFile                 ! Name of the FAST input file, from the MATLAB workspace (dimensioned the same as FAST's PriFile)

      !----------------------------------------------------------------------------------------------
      ! define internal variables
      !----------------------------------------------------------------------------------------------

   INTEGER(mwSize)              :: M                       ! Number of rows in array
   INTEGER(mwSize)              :: N                       ! Number of columns in array
   INTEGER                      :: Stat                    ! Return status

   INTEGER(mwSize)              :: MDLsizes(NSIZES)        ! Local array, containing the SimuLink SIZE array that is required as input/output
   REAL(mxDB)                   :: DSIZE   (NSIZES)        ! Local array = DOUBLE(MDLsizes), used to output the MDLsizes array
   REAL(mxDB)                   :: NXTHIT                  ! return value for next time (not used)

   LOGICAL                      :: InitStep                ! Flag determines if this is an initialization step
   LOGICAL, SAVE                :: FirstStep = .TRUE.      ! Flag to determine if FAST has been initialized

      !----------------------------------------------------------------------------------------------
      ! define the EXTERNAL MATLAB procedures
      !----------------------------------------------------------------------------------------------

   INTEGER(mwPointer), EXTERNAL :: mexGetVariablePtr       ! MATLAB routine
   EXTERNAL                     :: mxCopyPtrToReal8        ! MATLAB mex function to create REAL(8) array from pointer to an array
   EXTERNAL                     :: mxCopyReal8ToPtr        ! MATLAB mex function to create pointer to copy of a REAL(8) array
   INTEGER(mwPointer), EXTERNAL :: mxCreateDoubleMatrix    ! pointer [Replace integer by integer*8 on the DE! Alpha and the SGI 64-bit platforms]
   INTEGER(mwSize),    EXTERNAL :: mxGetM                  ! MATALB mex function get number of rows in array
   INTEGER(mwSize),    EXTERNAL :: mxGetN                  ! MATALB mex function to get number of columns in array
   INTEGER(mwPointer), EXTERNAL :: mxGetPr                 ! MATLAB mex function to get the address of the first real number [Replace integer by integer*8 on the DE! Alpha and the SGI 64-bit platforms]
   REAL(mxDB),         EXTERNAL :: mxGetScalar             ! MATLAB mex function to return a scalar ( like mxCopyPtrToReal8() for 1 element )
   INTEGER(mwPointer), EXTERNAL :: mxGetString             ! MATLAB mex function to get string from its pointer



   !=================================================================================================
   ! Get variables from the Matlab workspace (added by M. Hand)
   !=================================================================================================

   !bjj: these variables can be returned from FAST_Init() rather than the Matlab workspace! 
   !     these checks would not only be done on initialization instead of each call to FAST_SFunc.
   !     We could also pass this function the name of the FAST input file and perhaps return the
   !     values obtained from the input file instead of using Read_FAST_Input.m.

      ! Get NumBl from workspace
   ptr_retrn = mexGetVariablePtr('base', 'NumBl')
   IF ( ptr_retrn == 0 ) THEN
      CALL ProgAbort('ERROR: Variable "NumBl" does not exist in the MATLAB workspace.')
   ELSE
      CALL mxCopyPtrToReal8(mxGetPr(ptr_retrn), retrn_dp, 1)
      NumBl = INT(retrn_dp)
   ENDIF

      ! Get NDOF from workspace
   ptr_retrn = mexGetVariablePtr('base', 'NDOF')
   IF ( ptr_retrn == 0 ) THEN
      CALL ProgAbort('ERROR: Variable "NDOF" does not exist in the MATLAB workspace.')
   ELSE
      CALL mxCopyPtrToReal8(mxGetPr(ptr_retrn), retrn_dp, 1)
      NDOF = INT(retrn_dp)
   ENDIF

      ! Get NumOuts from workspace
   ptr_retrn = mexGetVariablePtr('base', 'NumOuts')
   IF ( ptr_retrn == 0 ) THEN
      CALL ProgAbort('ERROR: Variable "NumOuts" does not exist in the MATLAB workspace.')
   ELSE
      CALL mxCopyPtrToReal8(mxGetPr(ptr_retrn), retrn_dp, 1)
      NumOuts = INT(retrn_dp)
   ENDIF


   !=================================================================================================
   ! Set the MDLsizes vector, which determines Simulink model characteristics
   !=================================================================================================

      MDLsizes(1) = 0                        ! number of continuous states
      MDLsizes(2) = 0                        ! number of discrete states
      MDLsizes(3) = NDOF + NumOuts           ! number of outputs: qdotdot + NumOuts
      MDLsizes(4) = 2 + 2 + NumBl + NDOF*2   ! number of inputs:  Gen(2), Yaw(2), BlPitch, q, qdot
      MDLsizes(5) = 0                        ! number of discontinuous roots in the system
      MDLsizes(6) = 1                        ! Direct feedthrough of U


      IF ( MDLsizes(3) > SIZE(Y,1) ) THEN
         CALL ProgAbort( ' Output array cannot hold the number of outputs.' )
      ELSEIF ( MDLsizes(4) > SIZE(U,1) ) THEN
         CALL ProgAbort( ' Input array cannot hold the number of inputs.' )
      END IF

   !=================================================================================================
   ! Check the function input arguments to determine if this is an initialization step.
   ! Initialization occurs when there are no input arguments or when the last input
   ! argument (#4), FLAG, is 0.
   !=================================================================================================

   IF (NRHS == 0) THEN
      InitStep = .TRUE.
   ELSE
      IF (NRHS /= 4) THEN
         CALL ProgAbort('Wrong number of input arguments.')
         InitStep = .TRUE.  ! This line should not be reached (mexErrMsgTxt in ProgAbort() returns to the MATLAB prompt)
      ELSE
            ! *** The FLAG input parameter, argument #4 ***
         M = mxGetM(PRHS(4))
         N = mxGetN(PRHS(4))
         IF ((M .NE. 1) .OR. (N .NE. 1)) THEN
            CALL ProgAbort('FLAG (input 4) must be a scalar variable.')
         ENDIF

         FLAG = INT(mxGetScalar(PRHS(4)))    ! Special case FLAG=0, return sizes and initial conditions

         IF (FLAG .EQ. 0) THEN
            InitStep = .TRUE.
         ELSE
            InitStep = .FALSE.
         ENDIF
      ENDIF
   ENDIF


   !=================================================================================================

   IF ( InitStep ) THEN  ! mdlInitializeSizes(), mdlStart()

!      CALL WrScr('Initializing the S-Function.') !BJJ: this is called 2x per simulation.  Why?

      !-----------------------------------------------------------------------------------------------
      ! S-Function Initialization
      ! Calling syntax: (Special case FLAG=0: return sizes and initial conditions)
      !     [y1]=FAST_SFunc();
      ! [y1, y2]=FAST_SFunc();
      !     [y1]=FAST_SFunc(t,x,u,FLAG=0);
      ! [y1, y2]=FAST_SFunc(t,x,u,FLAG=0);
      !-----------------------------------------------------------------------------------------------

      IF (NLHS < 1 ) THEN
         CALL ProgAbort('Not enough output arguments.')
      ELSEIF (NLHS > 2) THEN
         CALL ProgAbort('Too many output arguments.')
      ENDIF

         ! *** Output argument y1 contains the size vector (MDLsizes) ***

      !bjj: this should be done after the call to FAST_Init to allow NDOF and other parameters stored in MDLsizes() to be
      !     retreived from Fortran, rather than a variable in the Matlab workspace!
      
      PLHS(1)     = mxCreateDoubleMatrix(NSIZES, 1, mxREAL)                       ! Create NSIZES x 1 REAL array for the first output, y1
      ptr_Y       = mxGetPr(PLHS(1))                                              ! Get the address of the first element of the data
      DSIZE(:)    = REAL( MDLsizes(:), mxDB )                                     ! Integer(4) to Real(8)
      CALL mxCopyReal8ToPtr(DSIZE, ptr_Y, NSizes)                                 ! Copy the SIZE vector (DSize) to the output array pointed to by PLHS(1)


         ! *** Output argument y2 contains the initial states (ptr_X0) ***

      IF (NLHS > 1) THEN  ! [y1, y2]=FAST_SFunc();                                ! bjj: Since we have no states, this creates an empty array
         PLHS(2) = mxCreateDoubleMatrix(MDLsizes(1)+MDLsizes(2), 1, mxREAL)
      ENDIF

      NXTHIT =  HUGE

      IF (FirstStep) THEN

         !............................................................................................
         !  Make sure Read_FAST_Input.m was run before this simulation
         !............................................................................................

            ! Get input_fast variable from MATLAB workspace

         ptr_retrn = mexGetVariablePtr('base', 'input_fast')
         IF ( ptr_retrn == 0 ) THEN
            CALL ProgAbort('ERROR: variable "input_fast" does not exist in the MATLAB workspace.')
         ELSE
            M = mxGetM(ptr_retrn)
            N = mxGetN(ptr_retrn)
            Stat = mxGetString(ptr_retrn, InpFile, M*N)
            IF (Stat /= 0) CALL mexErrMsgTxt('Error getting FAST file name from the MATLAB workspace.')
         ENDIF


            ! Get Initialized variable from MATLAB workspace

         ptr_retrn = mexGetVariablePtr('base', 'Initialized')
         IF ( ptr_retrn == 0 ) THEN
            CALL ProgAbort('ERROR: Variable "Initialized" does not exist in the MATLAB workspace.')
         ELSE
            CALL mxCopyPtrToReal8(mxGetPr(ptr_retrn), Initialized, 1)
            IF ( Initialized == 0 ) THEN
               CALL ProgAbort('ERROR: Call Read_Fast_Input.m before running the simulation.')
            ELSE
               Initialized = 0
               CALL mxCopyReal8ToPtr (Initialized, mxGetPr(ptr_retrn), 1)  ! Set initialized to 0 the first time
            ENDIF
         ENDIF

         !............................................................................................
         !  Run FAST initialization
         !............................................................................................

         CALL FAST_Init(InpFile)

         FirstStep = .FALSE.
      
         CALL WrScr(' FAST_SFunc initialized with '//TRIM(Int2LStr( MDLsizes(4) ))// &
                        ' inputs and '//TRIM(Int2LStr( MDLsizes(3) ))//' outputs.')

      ENDIF

   ELSE

      !-----------------------------------------------------------------------------------------------
      ! S-Function Simulation Step
      ! calling syntax:
      !      [y1]=FAST_SFunc(t,x,u,FLAG);
      !  [y1, y2]=FAST_SFunc(t,x,u,FLAG);  - y2 is never defined, but this is apparently allowed
      !-----------------------------------------------------------------------------------------------

         !............................................................................................
         !      *******    The TIME (t) input parameter, argument #1    *******
         !............................................................................................

      M = mxGetM(PRHS(1))
      N = mxGetN(PRHS(1))
      IF ((M .NE. 1) .OR. (N .NE. 1)) THEN
         CALL ProgAbort('TIME (t) must be a scalar variable.')
      ENDIF
      ptr_T = mxGetPr(PRHS(1))


         !............................................................................................
         !      *******    The STATE VECTOR (x) input parameter, argument #2    *******
         !  Remark:  The state vector is partitioned into continuous and discrete states. The first
         !    states contain the continuous states, and the last states contain the discrete states.
         !............................................................................................

      M = mxGetM(PRHS(2))
      N = mxGetN(PRHS(2))
      IF ((M*N) .NE. MDLsizes(1)+MDLsizes(2)) THEN
         CALL ProgAbort('The STATE VECTOR (x) is the wrong size.')
      ENDIF
      ptr_X = mxGetPr(PRHS(2))



         !............................................................................................
         !      *******    The FLAG input parameter, argument #4    *******
         ! This flag determines what the function outputs. Its value was processed
         ! during the check that determined if this is an initialization step.
         !............................................................................................

      SELECT CASE (FLAG)

         CASE (0)

            !-----------------------------------------------------------------------------------------
            !     Define basic S-Function block characteristics; Return SIZES array: setup()
            !-----------------------------------------------------------------------------------------

               ! This was done in the InitStep logic above

         CASE (1, -1)

            !-----------------------------------------------------------------------------------------
            !     Return state derivatives: mdlDerivatives()
            !-----------------------------------------------------------------------------------------

               ! We don't have any so just create an empty array and return;

            IF (NLHS >= 0) THEN
               PLHS(1) = mxCreateDoubleMatrix(MDLsizes(1), 1, mxREAL)
            ENDIF

         CASE (2, -2)

            !-----------------------------------------------------------------------------------------
            !     Return discrete states: mdlUpdate()
            !-----------------------------------------------------------------------------------------

               ! We don't have any so just create an empty array and return;

            IF (NLHS >= 0) THEN
               PLHS(1) = mxCreateDoubleMatrix(MDLsizes(2), 1, mxREAL)
            ENDIF

         CASE (3, -3)

            !-----------------------------------------------------------------------------------------
            !     Return system outputs: mdlOutputs())
            !-----------------------------------------------------------------------------------------

            IF (NLHS >= 0) THEN


                  ! Set up the TIME array, T

               CALL mxCopyPtrToReal8(ptr_T,   T,   1)


                  ! Set up the INPUT array, U

                  !..................................................................................
                  !      *******    The INPUT VECTOR (u) input parameter, argument #3    *******
                  !..................................................................................

               M = mxGetM(PRHS(3))
               N = mxGetN(PRHS(3))
               IF ((M*N) .NE. MDLsizes(4)) THEN
                  CALL ProgAbort('The INPUT VECTOR (u) is the wrong size.')
               ENDIF
               ptr_U = mxGetPr(PRHS(3))


!               IF (.NOT. ALLOCATED(U)) THEN
!                  ALLOCATE ( U(MDLsizes(4)) , STAT=Stat )
!                  IF (Stat /= 0) CALL ProgAbort( 'Error allocating memory for the U array.' )
!               END IF
               CALL mxCopyPtrToReal8(ptr_U,   U(1:MDLsizes(4)),   MDLsizes(4))


!                  ! Set up the OUTPUT array, Y
!
!               IF (.NOT. ALLOCATED(Y)) THEN
!                  ALLOCATE ( Y(MDLsizes(3)) , STAT=Stat )
!                  IF (Stat /= 0) CALL ProgAbort( 'Error allocating memory for the Y array.' )
!               END IF


                  ! Get output results for this time

	            CALL BlockOUTPUT(NumBl, NDOF, NumOuts, T, U(1:MDLsizes(4)), Y(1:MDLsizes(3)))


                  ! Create the OUTPUT array for MATLAB

               PLHS(1) = mxCreateDoubleMatrix(MDLsizes(3), 1, mxREAL)
               ptr_Y   = mxGetPr(PLHS(1))                                     ! get a pointer to the output array
	            CALL mxCopyReal8ToPtr(Y(1:MDLsizes(3)), ptr_Y, MDLsizes(3))    ! Load the FORTRAN Y output into the MATLAB Y array (PLHS).


!	               ! Deallocate the arrays
!
!	            IF (ALLOCATED(U)) DEALLOCATE(U)
!	            IF (ALLOCATED(Y)) DEALLOCATE(Y)

            ENDIF

         CASE (4, -4)

            !-----------------------------------------------------------------------------------------
            !     Return next time interval for update: mdlOutputs method updates NextTimeHit property
            !-----------------------------------------------------------------------------------------

               ! bjj: NXTHIT is never updated (not used unless variable discrete-time sample time is specified)

            IF (NLHS >= 0) THEN
               PLHS(1) = mxCreateDoubleMatrix(1, 1, mxREAL)
               ptr_Y   = mxGetPr(PLHS(1))
               CALL mxCopyReal8ToPtr(NXTHIT, ptr_Y, 1)
            ENDIF

         CASE (5, -5)

            !-----------------------------------------------------------------------------------------
            !     Return the values of the system root functions
            !-----------------------------------------------------------------------------------------

               ! We don't have any so just create an empty array and return;

            IF (NLHS >= 0) THEN
               PLHS(1) = mxCreateDoubleMatrix(MDLsizes(5), 1, mxREAL)
            ENDIF

         CASE (9, -9)

            !-----------------------------------------------------------------------------------------
            !     Perform end-of-simulation tasks: mdlTerminate()
            !-----------------------------------------------------------------------------------------

            IF (NLHS >= 0) THEN
               PLHS(1) = mxCreateDoubleMatrix(0, 0, mxREAL)    ! bjj: this is an empty array
            ENDIF


            CALL WrScr(' FAST_SFunc completed.')
            CALL WrScr( ' ' )

            CALL FAST_End()
            

            FirstStep = .TRUE.


         CASE ( 99 )
         
            !-----------------------------------------------------------------------------------------
            !     Return wind speeds   
            !  Added by bjj (not part of the Simulink SFunc definition)
            !-----------------------------------------------------------------------------------------

            IF (NLHS >= 0) THEN


                  ! Set up the TIME array, T

               CALL mxCopyPtrToReal8(ptr_T,   T,   1)


                  ! Set up the INPUT array, U, containing positions

               M = mxGetM(PRHS(3))
               N = mxGetN(PRHS(3))
               IF ( N .NE. 3) THEN
                  CALL ProgAbort('The INPUT VECTOR (u) is the wrong size. It must have 3 columns.')
               ELSE IF ( M > INT(MaxWinds/3) ) THEN
                  CALL ProgAbort( ' Maximum number of wind positions available is '//TRIM(Int2Lstr(INT(MaxWinds/3)))//'.' )                  
               ENDIF
               
               ptr_U = mxGetPr(PRHS(3))

               CALL mxCopyPtrToReal8(ptr_U,   U(1:M*N),  M*N )


                  ! Get the wind speed at this time/location
                  
               CALL Wind_Vel(T, U, Y, M, N)                           

                  ! Create the OUTPUT array for MATLAB
         
               PLHS(1) = mxCreateDoubleMatrix(M, N, mxREAL)
               ptr_Y   = mxGetPr(PLHS(1))                               ! get a pointer to the output MATLAB array
	            CALL mxCopyReal8ToPtr(Y(1:M*N), ptr_Y, M*N)              ! Load the FORTRAN Y output into the MATLAB Y array (PLHS).
         
            ENDIF


         CASE DEFAULT

            !-----------------------------------------------------------------------------------------
            !     Undefined FLAG
            !-----------------------------------------------------------------------------------------

!            CALL mexErrMsgTxt('Not a valid FLAG number.')
            CALL ProgAbort('Not a valid FLAG number.')

      END SELECT


   ENDIF !InitStep

END SUBROUTINE MexFunction
