% Simulink_CertTest
clear all


    % the FAST CertTest folder must be entered below:
CertTest_Dir = 'C:\Users\bjonkman\Documents\DATA\DesignCodes\simulators\FAST\SVNdirectory\trunk\CertTest';
% CertTest_Dir = 'C:\Users\bjonkman\DATA\DesignCodes\FAST\CertTest';
% CertTest_Dir = '.';

% cd( CertTest_Dir )

% This script needs the files OpenLoop.mdl, FAST_Sfunc.mexw32, 
% and Read_FAST_Input.m located somewhere on the Matlab path so I'll
% add the Simulink directories in the FAST archive:

addpath( [CertTest_Dir '\..\Simulink'], ...         % FAST_Sfunc.mexw32 and Read_FAST_Input.m
         [CertTest_Dir '\..\Simulink\Samples'] )    % OpenLoop.mdl

%test 2 has a high-speed shaft brake shutdown event, invalid in FAST_SFunc
%test 14 is a linearization test; invalid in FAST_SFunc

for iTest =  [1 3:13 15:17]
    
        %------------------------------------------------------------------       
        % Set up and run the Simulink OpenLoop model
        %------------------------------------------------------------------       
    clear FAST_Sfunc;       %perhaps this requirement could be removed in the future, after we have cleaned up all the SAVEd variables and INITIALIZATION of variables in modules, and deal with AeroDyn's internal states.
    
    FileRoot   = sprintf( 'Test%02.0f', iTest );
    
    disp('***********************************************');
    disp( ['FAST_SFunc certification test for ' FileRoot] );
    disp('***********************************************');
    
    input_fast = [CertTest_Dir filesep FileRoot '.fst'];
    
        % Read FAST input file and set initial conditions
    Read_FAST_Input
    

    sim('OpenLoop.mdl',[0,TMax]);
   
    
end

    % I'll remove the paths I added so I don't mess up your settings!
rmpath(  [CertTest_Dir '\..\Simulink'] );           % FAST_Sfunc.mexw32 and Read_FAST_Input.m
rmpath(  [CertTest_Dir '\..\Simulink\Samples'] );   % OpenLoop.mdl
     
% if unexpected termination (and the message "FAST_SFunc completed." is 
% not displayed in the command window), call 
%    FAST_SFunc(0,[],[],9)
% to avoid closing Matlab (in MOST cases)

disp( '***********************************************');
disp( 'FAST_SFunc certification test completed.' )    
                

