% make sure the FASTv8\bin directory is in the MATLAB path
%    (relative path names are not recommended in addpath()):
% addpath('C:\Users\bjonkman\Documents\CAETools\FASTv8\bin');


FAST_InputFileName =  '..\..\CertTest\Test18.fst';
TMax   = 630;
DT = 0.00625;




%paramètres de la 5MW turbine NREL

CornerFreq = 1.570796325;   %Communication interval for pitch controller
PC_DT = 0.00125;         %Integral gain for pitch controller at rated
PC_KI = 0.008068634;     %Pitch angle were the the derivative of the
PC_KK = 0.109996;        %Proportional gain for pitch controller at r
PC_KP = 0.01882681;      %Maximum pitch setting in pitch controller,
PC_MaxPit = 1.570796;    %Maximum pitch rate (in absolute value) in
PC_MinPit = 0.0;          %Minimum pitch setting in pitch controller,
PC_MaxRat = 0.1396263;    %Minimum pitch setting in pitch controller,
PC_RefSpd= 122.9096;      %Desired (reference) HSS speed for pitch controller
R2D = 57.295780;          %Factor to convert radians to degrees.
RPS2RPM = 9.5492966;      %Factor to convert radians per second to rev
VS_CtInSp = 70.16224;     %Transitional generator speed (HSS side) bet
VS_DT = 0.00125;          %Communication interval for torque controller
VS_MaxRat = 15000.0;      %Maximum torque rate (in absolute value) in
VS_MaxTq = 47402.91;      %Maximum generator torque in Region 3 (HSS s
VS_Rgn2K = 2.332287;      %Generator torque constant in Region 2 (HSS
VS_Rgn2Sp = 91.21091;     %Transitional generator speed (HSS side) bet
VS_Rgn3MP = 0.01745329;   %Minimum pitch angle at which the torque is
VS_RtGnSp = 121.6805;     %Rated generator speed (HSS side), rad/s. --
VS_RtPwr = 5296610.0;     %Rated generator generator power in Region 3
VS_SlPc = 10.0;           %Rated generator slip percentage in Region 2
VS_Rgn3MP = 0.01745329;   %Minimum pitch angle at which the torque is
GenEff = 94.4;             % Generator efficiency [ignored by the Thevenin and user-defined generator models] (%)- Generator efficiency [ignored by the Thevenin and user-defined generator models] (%)
fc = 0.25;

alpha = exp(-2*pi*DT*fc); %filtre


VS_SySp = VS_RtGnSp/( 1.0 + 0.01*VS_SlPc );
VS_Slope15 = ( VS_Rgn2K*VS_Rgn2Sp*VS_Rgn2Sp )/( VS_Rgn2Sp - VS_CtInSp );
VS_Slope25 = ( VS_RtPwr/VS_RtGnSp )/( VS_RtGnSp - VS_SySp );

if VS_Rgn2K == 0.0
    VS_TrGnSp = VS_SySp;
else
    VS_TrGnSp = ( VS_Slope25 - sqrt( VS_Slope25*( VS_Slope25 - 4.0*VS_Rgn2K*VS_SySp ) ) )/( 2.0*VS_Rgn2K );
end





%fin de paramètres

%démarrage de la simulation
    
  sim('TestControle.mdl',[0,TMax]);
       