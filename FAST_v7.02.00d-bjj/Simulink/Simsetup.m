% This script creates necessary workspace variables to run a Simulink model
% using the FAST dynamics and aerodynamic S-function block.  Before running
% a simulation, the character array, input_fast, must contain the FAST
% input file name, and the script Read_FAST_Input.m must run.

clear all;

% Prompt the user for the input file name.
disp( '   -------------------------------------------------' );
disp( '   Enter the name of the FAST input file to read    ' );
disp( '   -------------------------------------------------' );
input_fast = [ input(' < ','s')];  % FAST (.fst) filename

% Read FAST input file and set initial conditions
Read_FAST_Input

%% ------------------------------------------------------------------------
% Place all controller related parameters here.
%
% Simple Induction Generator Example ======================================
% To model a simple induction generator in Simulink use model Test01_SIG.mdl.  
% The following parameters duplicate those used in Certification Test #01.  
% Change Test01.fst as follows:
% ADAMSPrep = 1
% VSContrl = 3
% Add "LSSGagVxa" to OutList
%
% Remove comment indication (%) from following lines:
%
% GenEff   =  100.0;          % - Generator efficiency [ignored by the Thevenin and user-defined generator models] (%)
% GBRatio  =   22.5;          % - Gearbox ratio (-)
% SIG_SlPc =    1.5125;       % - Rated generator slip percentage [>0] (%)              Now HSS side!
% SIG_SySp = 1200.0;          % - Synchronous (zero-torque) generator speed [>0] (rpm)  Now HSS side!
% SIG_RtTq = 1367.9;          % - Rated torque [>0] (N-m)                               Now HSS side!
% SIG_PORt =    2.0;          % - Pull-out ratio (Tpullout/Trated) [>1] (-)
% 
% SIG_SySp = SIG_SySp*pi/30;  % convert to rad/s
% SIG_RtSp = SIG_SySp*(1.0+0.01*SIG_SlPc);
% SIG_POS1=SIG_PORt*(SIG_RtSp-SIG_SySp);
% SIG_POTq=SIG_RtTq*SIG_PORt;
% SIG_Slop=SIG_RtTq/(SIG_RtSp - SIG_SySp);
%
%% ========================================================================

% If there is an error that requires you to restart the Simulink 
% simulation before FAST terminates properly (you should see the Simulation
% Time Ratio statistics printed to the Matlab command window when it 
% terminates properly), call the FAST_SFunc routine with FLAG=9, like this:
%
% FAST_SFunc(0,[],[],9)
%
% It will close open files and deallocate memory. If you do not do this,
% you may have to close Matlab to release locks on open files and/or 
% free the memory allocated in FAST_SFunc before you can start your 
% Simulink model again.