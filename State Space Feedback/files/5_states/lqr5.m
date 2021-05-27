% 5 State Estimator + Wind Disturbance
% This code is an improvement from the 3 states estimator DAC
% Now we have blade flapwise taken into account, which means that we have
% states in the rotating frame, thus we need to use linear combination to transform the
% states on those needed

%26 May 2021: I've updated the A matrix bulding process, but I don't recall why
%I'm using the 1/3 to build the symmetrical and asymmetrical elements. I'll
%look into that later

%original AvgAMat
% x1 = azimuth_rotor
% x2 = DrTr
% x3 = FP1
% x4 = FP2
% x5 = FP5
% x6 = rot_speed
% x7 = DrTrdot
% x8 = FP1_speed
% x9 = FP2_speed
% x10 = FP3_speed

DrTr=2;
rot_speed = 6;
DrTrdot = 7;

FP1 = 3;
FP2 = 4;
FP3 = 5;

FP1s = 8;
FP2s = 9;
FP3s= 10;




% It's worth say that we cannot control and/or observe the flapwise states
% as they are, we must transform them to symmetrical and asymmetrical flap
% displacement, and velocity, when required;

% Desired A matrix:
% x1 = symetric flap disp
% x2 = symetric flap vel (or x2*)
% x3 = rot_speed
% x4 = DrTr
% x5 = DrTrdot


% And to transform FP states to the symetric one we must combine them
% linearly - This is described by Wang et al (2016)- 1/3 of each FP

%We exclude the first state and use the remaining to build our matrices

thirdA = AvgAMat/3; %this is an auxiliary matrix not to be used elsewhere

A11 = (thirdA(FP1,FP1)+thirdA(FP2,FP1)+thirdA(FP3,FP1)+thirdA(FP1,FP2)+thirdA(FP2,FP2)+thirdA(FP3,FP2)+thirdA(FP1,FP3)+thirdA(FP2,FP3)+thirdA(FP3,FP3))/3 ;
A12 = (AvgAMat(FP1,FP1s)+AvgAMat(FP2,FP1s)+AvgAMat(FP3,FP1s)+AvgAMat(FP1,FP2s)+AvgAMat(FP2,FP2s)+AvgAMat(FP3,FP2s)+AvgAMat(FP1,FP3s)+AvgAMat(FP2,FP3s)+AvgAMat(FP3,FP3s))/3 ;
A13 = thirdA(FP1,rot_speed)+thirdA(FP2,rot_speed)+thirdA(FP3,rot_speed) ;
A13 = thirdA(FP1,rot_speed)+thirdA(FP2,rot_speed)+thirdA(FP3,rot_speed) ;
A14 = thirdA(FP1,DrTr)+thirdA(FP2,DrTr)+thirdA(FP3,DrTr) ;
A15 = thirdA(FP1,DrTrdot)+thirdA(FP2,DrTrdot)+thirdA(FP3,DrTrdot) ;

A21 = (thirdA(FP1s,FP1)+thirdA(FP2s,FP1)+thirdA(FP3s,FP1)+thirdA(FP1s,FP2)+thirdA(FP2s,FP2)+thirdA(FP3s,FP2)+thirdA(FP1s,FP3)+thirdA(FP2s,FP3)+thirdA(FP3s,FP3))/3 ;
A22 = (thirdA(FP1s,FP1s)+thirdA(FP2s,FP1s)+thirdA(FP3s,FP1s)+thirdA(FP1s,FP2s)+thirdA(FP2s,FP2s)+thirdA(FP3s,FP2s)+thirdA(FP1s,FP3s)+thirdA(FP2s,FP3s)+thirdA(FP3s,FP3s))/3 ;
A23 = thirdA(FP1s,rot_speed)+thirdA(FP2s,rot_speed)+thirdA(FP3s,rot_speed);
A24 = thirdA(FP1s,DrTr)+thirdA(FP2s,DrTr)+thirdA(FP3s,DrTr);
A25 = thirdA(FP1s,DrTrdot)+thirdA(FP2s,DrTrdot)+thirdA(FP3s,DrTrdot);

A31 = thirdA(rot_speed,FP1)+thirdA(rot_speed,FP2)+thirdA(rot_speed,FP3);
A32 = thirdA(rot_speed,FP1s)+thirdA(rot_speed,FP2s)+thirdA(rot_speed,FP3s);
A33 = AvgAMat(rot_speed,rot_speed) ;
A34 = AvgAMat(rot_speed,DrTr) ;
A35 = AvgAMat(rot_speed,DrTrdot) ;

A41 = thirdA(DrTr,FP1)+thirdA(DrTr,FP2)+thirdA(DrTr,FP3);
A42 = thirdA(DrTr,FP1s)+thirdA(DrTr,FP2s)+thirdA(DrTr,FP3s);
A43 = AvgAMat(DrTr,rot_speed) ;
A44 = AvgAMat(DrTr,DrTr) ;
A45 = AvgAMat(DrTr,DrTrdot) ;

A51 = thirdA(DrTrdot,FP1)+thirdA(DrTrdot,FP2)+thirdA(DrTrdot,FP3);
A52 = thirdA(DrTrdot,FP1s)+thirdA(DrTrdot,FP2s)+thirdA(DrTrdot,FP3s);
A53 = AvgAMat(DrTrdot,rot_speed) ;
A54 = AvgAMat(DrTrdot,DrTr) ;
A55 = AvgAMat(DrTrdot,DrTrdot) ;

A = [ A11 A12 A13 A14 A15
    ; A21 A22 A23 A24 A25 
    ; A31 A32 A33 A34 A35
    ; A41 A42 A43 A44 A45
    ; A51 A52 A53 A54 A55
    ];
clear A11 A12 A13 A14 A15 A21 A22 A23 A24 A25 A31 A32 A33 A34 A35 A41 A42 A43 A44 A45 A51 A52 A53 A54 A55

B = [(AvgBMat(FP1)+AvgBMat(FP2)+AvgBMat(FP3))/3
    ;(AvgBMat(FP1s)+AvgBMat(FP2s)+AvgBMat(FP3s))/3
    ; AvgBMat(rot_speed)
    ; AvgBMat(DrTr)
    ; AvgBMat(DrTrdot)
    ];


%Wind Disturbance 
% Bd1 = mean(AvgBdMat(FP1,1)+AvgBdMat(FP2,1)+AvgBdMat(FP3,1));
% Bd2 = mean(AvgBdMat(FP1s,1)+AvgBdMat(FP2s,1)+AvgBdMat(FP3s,1));
% Bd3 = AvgBdMat(rot_speed,1);
% Bd = [Bd1;Bd2;Bd3];

%C = [0 0 1]; %measuring rotor_speed in rad/s

% all measurements available
C = [1 1 1 1 1]; %measuring rotor_speed in rad/s
D =0;



sys5 = ss(A,B,C,D);


%Reference values for perturbations setpoint

ref_DrTr = Avgxop(DrTr);
ref_DrTrdot = Avgxop(DrTrdot);
ref_symfp = (Avgxop(FP1)+Avgxop(FP2)+Avgxop(FP3))/3;
ref_symfpdot = (Avgxop(FP1s)+Avgxop(FP2s)+Avgxop(FP3s))/3;
ref_rot = Avgxop(rot_speed);
ref_pitch =  7.16347E-02 ; %(rad)



% %pole placement for closed loop:
% poles = [-2 -2+14i -2-14i -4+4i -4-4i];
% G = -place(A,B,poles)
% 
% 
% %gain for wind disturbance rejection (DAC), need revision to include the other states:
% Gd = -Bd(3)/B(3);
% 
% %Augmented G matrix
% Gbar = [G Gd/1.2]; 
% 
% %calculate augmented state matrices:
% theta = 1;
% F = 0;
% Abar = [A Bd*theta; zeros(1,size(A,2)) F];
% Bbar = [B;0];
% Cbar = [C 0];
% 
% %check observability of these augmented matrices
% Ob = obsv(Abar,Cbar);
% unob = length(Abar)-rank(Ob);
% if (unob)
%     disp('System has unobservale state(s), please review your model')
% end
% 
% 
% %Calculate the gain Kbar (estimator) - this time we use estimator poles
% %with high damping 
% pole_obs_DAC = [-12 -10+0.1i -10-0.1i -9+0.2i -9-0.2i -7];
% Kbar = place(Abar',Cbar',pole_obs_DAC);
% 
% Lbar = (Abar + Bbar*Gbar - Kbar'*Cbar - Kbar'*D*Gbar);
% 
% sys_est_DAC = ss(Lbar,Kbar',Gbar,D)
% eig(Lbar)
% step(sys_est_DAC)



%-------------------------------------------------
%This one we use LQR to find the gains:

%First it's the gain for the feedback controller:

R =1;
Q = diag([0 0 10 0 0]);
[K,S,e] = lqr(A,B,Q,R);
G = -K


% Gd = -Bd(3)/B(3);

%Augmented G matrix
%Gbar = [G Gd/2]; 

%calculate augmented state matrices:
% theta = 1;
% F = 0;
% Abar = [A Bd*theta; zeros(1,size(A,2)) F];
% Bbar = [B;0];
% Cbar = [C 0];

%check observability of these augmented matrices
% Ob = obsv(Abar,Cbar);
% unob = length(Abar)-rank(Ob);
% if (unob)
%     disp('System has unobservale state(s), please review your model')
% end
% 
% pole_obs_DAC = [-10 -11 -12];
% Kbar = place(Abar',Cbar',pole_obs_DAC/2);
% 
% Lbar = (Abar + Bbar*Gbar - Kbar'*Cbar - Kbar'*D*Gbar);
% 
% sys_est_DAC = ss(Lbar,Kbar',Gbar,D);
% eig(Lbar)
% step(sys_est_DAC)












%FAST and Simulation Parameters
FAST_InputFileName =  '..\..\CertTest\Control_5_state.fst';
TMax   = 800;
DT = 0.01;
PC_MaxPit = 1.570796;    %Maximum pitch rate (in absolute value) (rad)
PC_MinPit = 0.0;          %Minimum pitch setting in pitch controller (rad)
PC_MaxRat = 0.1396263;    %Max pitch rate (rad)
fc = 0.25;
alpha = exp(-2*pi*DT*fc); %filtre