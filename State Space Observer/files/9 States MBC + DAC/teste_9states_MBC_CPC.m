% make sure the FASTv8\bin directory is in the MATLAB path
%    (relative path names are not recommended in addpath()):
% addpath('C:\Users\bjonkman\Documents\CAETools\FASTv8\bin');


FAST_InputFileName =  '..\..\CertTest\Control_9_states.fst';
TMax   = 800;
DT = 0.01;

PC_MaxPit = 1.570796;    %Maximum pitch rate (in absolute value) (rad)
PC_MinPit = 0.0;          %Minimum pitch setting in pitch controller (rad)
PC_MaxRat = 0.1396263;    %Max pitch rate (rad/s)
fc = 0.25;
alpha = exp(-2*pi*DT*fc); %filtre

%Original States:
% x1 = azimuth
% x2 = DrTr
% x3 = fp1
% x4 = fp2
% x5 = fp3
% x6 = rot
% x7 = Drtrdot
% x8 = fp1dot
% x9 = fp2dot
% x10 = fp3dot


%Desired MBC States 
% x1 = q0
% x2 = qc
% x3 = qs
% x4 = rot
% x5 = DrTr
% x6 = DrTrdot
% x7 = q0dot
% x8 = qcdot
% x9 = qsdot


%Reference values for perturbations around the OP

% ref_DrTr = 0.004818000000000;
% ref_DrTrdot = 0;
% ref_symfp = 4.3534;
% ref_symfpdot = 8.0806e-07;
ref_rot = 1.266999999999998;
ref_pitch =  7.16347E-02 ; %(rad)





%démarrage de la simulation
list = [3 4 5 6 2 7 8 9 10];
% A = AvgAMat(list, list); 
% B = AvgBMat(list);
% C = [0 0 1 0 0 ]; %only the rotor is avaiable
% D = 0;
%Bd = AvgBdMat(list);



A = MBC_AvgA(list,list);
MBC_AvgB = mean(MBC_B,3);
B = MBC_AvgB(list,:);
MBC_AvgBd = mean(MBC_Bd,3);

Bd = MBC_AvgBd(list);



D=0;
C = [0 0 0 1 0 0 0 0 0]; %only the rotor is avaiable
sys9 = ss(A,B,C,D);

%Necessary states for the 9 states system:

% x1 = q0
% x2 = qc
% x3 = qs
% x4 = rot_speed
% x5 = DrTrdot

%where: symfp = 1/3(fp1+fp2+fp3)
%and symfp_dot = 1/3(fp1dot+...)


%LQR
R=eye(size(B,2));
Q = diag([0.1 0.1 0.1 1E3 10 0.1 0 0 0]);
[G_LQR,S,e] = lqr(A,B,Q,R);
G_LQR = -G_LQR;
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

Gbar = [G_LQR 10*Gd]; %trial and error adjustment to find the proper Gd
Cbar = [C [0]];
theta = 1;
F = 0;

Abar = [A Bd*theta; zeros(1,size(A,2)) F];
Bbar = [B;zeros(1,size(B,2))];
Re=eye(size(Cbar,1));
Qe = diag([1E1 1E1 1E1 1E9 1E0 0 0 0 0 1E12]);
% Qe = diag([10 1 10000 10 1 1E8]);
[Ge_bar,Se,ee] = lqr(Abar',Cbar',Qe,Re);
Kbar = Ge_bar
Lbar = (Abar + Bbar*Gbar - Kbar'*Cbar);


Dbar = zeros(size(Gbar,1),size(Kbar',2));

sys_est = ss(Lbar,Kbar',Gbar,Dbar);


       