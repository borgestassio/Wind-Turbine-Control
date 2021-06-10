%Script to take all .lin files and store them a in single matrix
%Make sure all .lin files are on the same folder
%By Tassio Borges
global RootName
clear A B C D Bd G Gd Gd_teste Gbar Cbar Abar Bbar Kbar Lbar Dbar DescCntrlInpt Bseudoin;


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


files = ["lqr_12ms"; "lqr_13ms";"lqr_14ms"; "lqr_15ms"; "lqr_16ms";"lqr_17ms";"lqr_18ms"]



for i=1 :length(files)
RootName = (char(files(i)));
Get_mat;
mbc3;
temp = strsplit(DescCntrlInpt{1});

Pitch_ref(i) = str2num(temp{10});
twr_accel_ref(i) = Avgyop(7);
twr_ref(i) = Avgyop(9);

%find A
A1(:,:,i) = MBC_AvgA(list,list);
A(:,:,i) = [A1(:,:,i) zeros(size(A1(:,:,i),2),1); 0 0 0 0 0 0 1 0 0 0 0 0];
% A(:,:,i) = A1(:,:,i);

%find B
MBC_AvgB = mean(MBC_B,3);
B1(:,:,i) = MBC_AvgB(list,:);
B(:,:,i) = [B1(:,:,i);zeros(1,size(B1(:,:,i),2))];
% B(:,:,i)=B1(:,:,i);


%find C
MBC_AvgC = mean(MBC_C,3);
C(:,:,i) = [0 0 0 0 0 0 1 0 0 0 0 0;MBC_AvgC(7,list) 0; 0 0 0 0 0 0 0 0 0 0 0 1];
% C(:,:,i) = [0 0 0 0 0 0 1 0 0 0 0;MBC_AvgC(7,list)];

%D is zero, normally
D(i) = 0; 

% sys_open_12 = ss(A,B,C,D);

%Bd now:

MBC_AvgBd = mean(MBC_Bd,3);
Bd1(:,:,i) = MBC_AvgBd(list);
Bd(:,:,i) = [Bd1(:,:,i);zeros(1,size(Bd1(:,:,i),2))];
% Bd(:,:,i) = Bd1(:,:,i);

R=eye(size(B,2));
 Q = diag([0.4 0.01 0 0 0 1.4 1 0.01 0 0 0 1E-3]);
% Q = diag([0 0 0 0 0 1.4 1 1 0 0 0 0.01]);

% Q = diag([0.4 0 0 0 0 1.4 0 1 0 0 0]); %no-integral
% Q = diag([0.4 0 0 0 0 1.4 0 1 0 0 0 1E-6]); %integral
[K,S,e] = lqr(A(:,:,i),B(:,:,i),Q,R);
G(:,:,i) = -K;

% Bseudoin(:,:,i)  = inv((B(:,:,i)')*B(:,:,i))*(B(:,:,i)');
% Gd(:,:,i) = -Bseudoin(:,:,i)*(Bd(:,:,i));


% Gd(:,:,i) = linsolve(B(:,:,i),-Bd(:,:,i)); %this considers all disturbances, altough it's not clear if the values cancel them

%  Gd = 0;

Gd(:,:,i) = linsolve(B(:,:,i),-Bd(:,:,i)); %this considers all disturbances, altough it's not clear if the values cancel them
Gd_teste(:,:,i) = [Gd(1,1,i)/4;Gd(2,1,i);Gd(3,1,i)];

% Gd_teste(:,:,i) = [Gd(1)/4;Gd(2);Gd(3)];




Gbar = [G Gd_teste/2];
Gbar(:,:,i) = [G(:,:,i) Gd(:,:,i)/4];

% Cbar(:,:,i) = [C(:,:,i) [0;0]]; %no-integral

Cbar(:,:,i) = [C(:,:,i) [0;0;0]]; %integral

theta = 1;
F = 0;

Abar(:,:,i) = [A(:,:,i) Bd(:,:,i)*theta; zeros(1,size(A,2)) F];
Bbar(:,:,i) = [B(:,:,i);zeros(1,size(B,2))];

Re=eye(size(Cbar,1));
% Qe= diag([2 0 0 0 0 2 2 0 0 0 0 0.8 800]);
% Qe= diag([1 0 0 0 2 0 2 0 0 0 0 0 1000]);
% Qe= diag([1 0 0 0 2 0 2 0 0 0 0 1000]); %no-integral
Qe= diag([1 0 0 0 2 0 5 0 0 0 0 0 1000]); %integral
[Ke,Se,ee] = lqr(Abar(:,:,i)',Cbar(:,:,i)',Qe,Re);
Kbar(:,:,i) = Ke;

Lbar(:,:,i) = (Abar(:,:,i) + Bbar(:,:,i)*Gbar(:,:,i) - Kbar(:,:,i)'*Cbar(:,:,i));
Dbar(:,:,i) = zeros(size(Gbar,1),size(Kbar(:,:,i)',2));

sys_est = ss(Lbar(:,:,i),Kbar(:,:,i)',Gbar(:,:,i),Dbar(:,:,i));
figure;
step(sys_est);

clear K S e MBC_AvgA MBC_AvgB AvgAMat AvgBMat MBC_A MBC_B Ke DescCntrlInpt temp Avgyop;

end


