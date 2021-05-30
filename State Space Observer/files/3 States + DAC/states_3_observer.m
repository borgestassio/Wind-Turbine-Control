%By: Tassio Borges 18/10/2017 14h20
%3 State Observer + Wind Disturbance: 
% the most part of the code is exactly the same as the full 3 state before.
% the only thing we need here is to create the state estimator 

%original AvgAMat
% x1 = azimuth_rotor
% x2 = DrTr
% x3 = rot_speed
% x4 = Drtr_speed
DrTr = 2;
rot_speed = 3;
Drtr_speed =4;

% Desired A matrix:
% x1 = rotor_speed
% x2 = DrTr
% x3 = gen_speed
%where: gen_speed = rot_speed _ DrTr_speed states or x3+x4 and Drtr_s =
%gen-rot


%Note : check this first line, specially A33, not sure if it's correct

A = [AvgAMat(rot_speed,rot_speed)-AvgAMat(rot_speed,Drtr_speed) AvgAMat(rot_speed,DrTr) AvgAMat(rot_speed,rot_speed)+AvgAMat(rot_speed,Drtr_speed)
    ;-1      AvgAMat(DrTr,DrTr)      1
    ;AvgAMat(rot_speed,rot_speed)+AvgAMat(Drtr_speed,rot_speed)-AvgAMat(Drtr_speed,Drtr_speed)-AvgAMat(rot_speed,Drtr_speed)  AvgAMat(Drtr_speed,DrTr)+AvgAMat(rot_speed,DrTr)  AvgAMat(Drtr_speed,Drtr_speed)+AvgAMat(rot_speed,Drtr_speed)];

B = [AvgBMat(3); AvgBMat(2); AvgBMat(3)+AvgBMat(4)];

C = [1 0 0]; %measuring rotor_speed in rad/s
D =0;

Bd = [AvgBdMat(3); AvgBdMat(2); AvgBdMat(3)+AvgBdMat(4)];


sys3 = ss(A,B,C,D);

ref_pitch =  7.06230E-02;
ref_rot = Avgyop(3);
ref_DrTr = Avgxop(2);
Gearbox = 97;

%pole placement for closed loop:
poles = [-2 -2+14i -2-14i];
G = -place(A,B,poles)


%gain for wind disturbance rejection (DAC):
Gd = -Bd(3)/B(3);

%Augmented G matrix
Gbar = [G Gd/2]; 

%calculate augmented state matrices:
theta = 1; % step pertubation
F = 0;
Abar = [A Bd*theta; zeros(1,size(A,2)) F];
Bbar = [B;0];
Cbar = [C 0];

%check observability of these augmented matrices
Ob = obsv(Abar,Cbar);
unob = length(Abar)-rank(Ob);
if (unob)
    disp('System has unobservale state(s), please review your model')
end


%Calculate the gain Kbar (estimator)
pole_obs_DAC = [-15 -16 -17 -18];
Kbar = place(Abar',Cbar',pole_obs_DAC);

Lbar = (Abar + Bbar*Gbar - Kbar'*Cbar - Kbar'*D*Gbar);

sys_est_DAC = ss(Lbar,Kbar',Gbar,D)








%FAST and Simulation Parameters
FAST_InputFileName =  '..\..\CertTest\Control_3_state.fst';
TMax   = 1200;
DT = 0.01;
PC_MaxPit = 1.570796;    %Maximum pitch rate (in absolute value) (rad)
PC_MinPit = 0.0;          %Minimum pitch setting in pitch controller (rad)
PC_MaxRat = 0.1396263;    %Max pitch rate (rad)
fc = 0.25;
alpha = exp(-2*pi*DT*fc); %filtre