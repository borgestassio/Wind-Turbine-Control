FAST_InputFileName =  '..\..\CertTest\Control_11_state.fst';
TMax   = 800;
DT = 0.01;

PC_MaxPit = 1.570796;    %Maximum pitch rate (in absolute value) (rad)
PC_MinPit = 0.0;          %Minimum pitch setting in pitch controller (rad)
PC_MaxRat = 0.1396263;    %Max pitch rate (rad/s)
fc = 0.25;
alpha = exp(-2*pi*DT*fc); %filter



%Original States:
% x1 = twr
% x2 = azimuth
% x3 = DrTr
% x4 = fp1
% x5 = fp2
% x6 = fp3
% x7 = twr_dot
% x8 = rot
% x9 = Drtrdot
% x10 = fp1dot
% x11 = fp2dot
% x12 = fp3dot



%Desired States (a priori)
% x1 = twr
% x2 = DrTr
% x3 = q0
% x4 = qc
% x5 = qs
% x6 = twrdot
% x7 = rot
% x8 = DrTrdot
% x9 = q0dot
% x10 = qcdot
% x11 = qsdot

%Reference values for perturbations setpoint

ref_DrTr = 0.004818000000000;
ref_DrTrdot = 0;
% ref_symfp = 4.3534;
% ref_symfpdot = 8.0806e-07;
ref_rot = 1.266999999999998;
ref_pitch =  7.13162E-02 ; %(rad)




twr = 1;
DrTr = 3;
fp1 = 4;
fp2 = 5;
fp3 = 6;
twr_speed = 7;
rot = 8;
DrTrdot = 9;
fp1_speed = 10;
fp2_speed = 11;
fp3_speed = 12;



list = [twr DrTr fp1 fp2 fp3 DrTrdot rot twr_speed fp1_speed fp2_speed fp3_speed];

A = MBC_AvgA(list,list);

MBC_AvgB = mean(MBC_B,3);
B = MBC_AvgB(list,:);


MBC_AvgBd = mean(MBC_Bd,3);
Bd = MBC_AvgBd(list);


MBC_AvgC = mean(MBC_C,3);
% C = MBC_AvgC(list);

D = 0; 
C = [0 0 0 0 0 0 1 0 0 0 0; 0 0 0 0 0 0 0 1 0 0 0]; %measuring rot and twr

sys11 = ss(A,B,C,D);




ref_rot = 1.266999999999998; %rad/s
ref_pitch =  7.13132E-02; %rad
% ref_twr = 0.307025000000000; %meters
ref_twr = 0; %this is for the speed, which is the case now, if u want to control the displacement, you must change to the correct value
R=eye(size(B,2));
Q = diag([0.1 0 0 0 0 0.1 2 0 0 0 0]);
[K,S,e] = lqr(A,B,Q,R);
G = -K;
sys_11 = ss(A+B*G,B,C,D);

% Gd = linsolve(B,-Bd); %this considers all disturbances, altough it's not clear if the values cancel them
% Gd = 0;
Bseudoin = inv((B')*B)*(B');
Gd = -Bseudoin*(Bd)
Gbar = [G 4*Gd];
Cbar = [C [0;0]];
theta = 1;
F = 0;
Abar = [A Bd*theta; zeros(1,size(A,2)) F];
Bbar = [B;zeros(1,size(B,2))];
Re=eye(size(Cbar,1));
Qe= diag([1 0 0 0 0 0 10 0 0 0 0 800]);
[Ke,Se,ee] = lqr(Abar',Cbar',Qe,Re);
Kbar = Ke;
Lbar = (Abar + Bbar*Gbar - Kbar'*Cbar);
Dbar = zeros(size(Gbar,1),size(Kbar',2));
sys_est = ss(Lbar,Kbar',Gbar,Dbar);
% step(sys_est);
