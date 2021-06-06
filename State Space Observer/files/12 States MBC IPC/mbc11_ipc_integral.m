%IPC controller - 12 states (11 + Integral)
%By Tassio Borges

FAST_InputFileName =  '..\..\CertTest\Control_11_state.fst';
TMax   = 800;
DT = 0.01;


%paramètres de la 5MW turbine NREL
 
CornerFreq = 1.570796325;   %Frequence pour le filtre
fc = 0.25;
alpha = exp(-2*pi*DT*fc); %filtre


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
% x3 = fp1
% x4 = fp2
% x5 = fp3
% x6 = twr_speed
% x7 = rot
% x8 = DrTrdot
% x9 = fp1_speed
% x10 = fp2_speed
% x11 = fp3_speed


%Reference values for perturbations setpoint

ref_DrTr = 0.004818000000000;
ref_DrTrdot = 0;
% ref_symfp = 4.3534;
% ref_symfpdot = 8.0806e-07;
ref_rot = 1.266999999999998;
ref_pitch =  7.13162E-02 ; %(rad)

% ref_twr = 0.307013333333333;
ref_twr = 0; %tower acceleration



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


list = [twr DrTr fp1 fp2 fp3 twr_speed rot DrTrdot fp1_speed fp2_speed fp3_speed];

A1 = MBC_AvgA(list,list);
A = [A1 zeros(size(A1,2),1); 0 0 0 0 0 0 1 0 0 0 0 0];

MBC_AvgB = mean(MBC_B,3);
B1 = MBC_AvgB(list,:);
B = [B1;zeros(1,size(B1,2))];

MBC_AvgBd = mean(MBC_Bd,3);
Bd1 = MBC_AvgBd(list);
Bd = [Bd1;zeros(1,size(Bd1,2))];

MBC_AvgC = mean(MBC_C,3);
C = [0 0 0 0 0 0 1 0 0 0 0 0;MBC_AvgC(7,list) 0; 0 0 0 0 0 0 0 0 0 0 0 1]; %measuring rot, twr accel and rot integral

D = 0; 

sys11 = ss(A,B,C,D);



%LQR
R=eye(size(B,2));
Q = diag([0 0 0 0 0 1.4 1 1 0 0 0 0.01]);
[K,S,e] = lqr(A,B,Q,R);
G_LQR = -K;
newA = A+B*G_LQR;


%State Estimator
% Ce = [0 0 1]
% Re=eye(size(Ce,1));
% Qe = diag([4E5 1E8 1E10]);
% [Ge_LQR,Se,ee] = lqr(A',Ce',Qe,Re);
% K = Ge_LQR
% Ge_LQR = -Ge_LQR;
% newA = A+B*Ge_LQR
% 
% % 
% poles_est = [-0.6 -20+120i -20-120i];
% K = place(A,Ce',poles_est);
% 
% 
% L = (A+B*G_LQR-K'*Ce)
% sys3_esti = ss(L,K',G_LQR,0)
% step(sys3_esti)
% 
% 
% 

%DAC Design



% Gd = linsolve(B_new,-Bd_new);
Bseudoin = inv((B')*B)*(B');
Gd = -Bseudoin*(Bd)
Gbar = [G_LQR 2*Gd];
Cbar = [C [0;0;0]];
theta = 1;
F = 0;
Abar = [A Bd*theta; zeros(1,size(A,2)) F];

Bbar = [B;zeros(1,size(B,2))];

Re=eye(size(Cbar,1));
Qe= diag([1 0 0 0 2 0 2 0 0 0 0 0.8 1000]);
[Ke,Se,ee] = lqr(Abar',Cbar',Qe,Re);
Kbar = Ke;
Lbar = (Abar + Bbar*Gbar - Kbar'*Cbar);
Dbar = zeros(size(Gbar,1),size(Kbar',2));
sys_est = ss(Lbar,Kbar',Gbar,Dbar);
step(sys_est);
%   sim('test_1_state',[0,TMax]);