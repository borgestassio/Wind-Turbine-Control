%--------------------------------------------------------------------------
% This script reads FAST *.fst files and creates Matlab workspace variables
% required to run the FAST s-function in Simulink.
% Developed at NREL's National Wind Technology Center
%     modified 10-Mar-2010 by B. Jonkman, NREL
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%open the FAST input file
%--------------------------------------------------------------------------
fid=fopen(input_fast);
if (fid == -1)
    disp(['Input file:  ',input_fast,' could not be opened.']);
    return
end

for iLine=1:2;                                      % skip the first two lines
    fgetl(fid);         
end
disp( fgetl(fid) )                                  % line 3: input file description

for iLine=1:5;                                      % skip 5 lines (through AnalMode)
    fgetl(fid);         
end

% read simulation parameters
NumBl= fscanf(fid,'%i',1); fgetl(fid);              % the S-function needs this parameter for initialization
TMax = fscanf(fid,'%g',1); fgetl(fid);              % can be used in Simulation Parameters menu
DT   = fscanf(fid,'%g',1); fgetl(fid);              % can be used in Simulation Parameters menu

for iLine=1:34                                      % skip 34 lines (12-45)
    fgetl(fid);                                     % (first part of Turbine control)
end

BlPitch = zeros(3,1);
for iLine=1:3                                       % read lines 46-48
    BlPitch(iLine) = fscanf(fid,'%g',1); fgetl(fid); % initial blade pitch    
end

for iLine=1:20                                      % skip 20 lines (49-68)
    fgetl(fid);                                     % (Turbine control through feature switches)
end                                         

% read initial conditions section
OoPDefl  = fscanf(fid,'%g',1); fgetl(fid);          % read line 69, initial OoPDefl
IPDefl   = fscanf(fid,'%g',1); fgetl(fid);          % read line 70, initial IPDefl
TeetDefl = fscanf(fid,'%g',1); fgetl(fid);          % read line 71, initial TeetDefl
Azimuth  = fscanf(fid,'%g',1); fgetl(fid);          % read line 72, initial Azimuth
RotSpeed = fscanf(fid,'%g',1); fgetl(fid);          % read line 73, initial RotSpeed
NacYaw   = fscanf(fid,'%g',1); fgetl(fid);          % read line 74, initial NacYaw
TTDspFA  = fscanf(fid,'%g',1); fgetl(fid);          % read line 75, initial TTDspFA
TTDspSS  = fscanf(fid,'%g',1); fgetl(fid);          % read line 76, initial TTDspSS

    %Turbine Configuration section
for iLine=1:2                                       % skip 2 lines (77-78)
    fgetl(fid);                                     % (Turbine configuration)
end
HubRad  = fscanf(fid,'%g',1); fgetl(fid);           % read line 79, HubRad
for iLine=1:7                                       % skip 7 lines (80-86)
    fgetl(fid);                                     % (Turbine configuration parameters)
end
TowerHt = fscanf(fid,'%g',1); fgetl(fid);           % read line 87, TowerHt
for iLine=1:7                                       % skip 7 lines (88-94)
    fgetl(fid);                                     % (Turbine configuration parameters)
end
AzimB1Up = fscanf(fid,'%g',1); fgetl(fid);          % read line 95, Azimuth when Blade 1 is up

    % MASS AND INERTIA section
for iLine=1:10                                      % skip 10 lines (96-105)
    fgetl (fid);                                    % (MASS AND INERTIA parameters)
end

    % DRIVETRAIN
for iLine=1:2                                       % skip 2 lines (106-107)
    fgetl (fid);                                    % (DRIVETRAIN parameters)
end    
GenEff  = fscanf(fid,'%g',1); fgetl(fid);           % line 108 (used to initialize 
GBRatio = fscanf(fid,'%g',1); fgetl(fid);           % line 109
for iLine=1:6                                       % skip 6 lines (110-115)
    fgetl (fid);                                    % (DRIVETRAIN parameters)
end

    % SIMPLE INDUCTION GENERATOR
for iLine=1:5                                       % skip 5 lines (106-120)
    fgetl (fid);                                    % (SIMPLE INDUCTION GENERATOR parameters)
end

    % THEVENIN-EQUIVALENT INDUCTION GENERATOR
for iLine=1:9                                       % skip 5 lines (121-129)
    fgetl (fid);                                    % (THEVENIN-EQUIVALENT INDUCTION GENERATOR)
end
    % PLATFORM MODEL
fgetl(fid);                                         % heading, line 130
PtfmModel = fscanf(fid,'%g',1); fgetl(fid);         % read line 131, PtfmModel
temp_char = fgetl(fid);                             % read line 132, PtfmFile line

%-----------------------------------------------------------------------
% If we have a platform model, read initial platform displacements: 
% Open the platform file (get the name of the file first)
%-----------------------------------------------------------------------
if ( PtfmModel >= 1 && PtfmModel <= 3 )
   temp_char = strtrim(temp_char);                  % remove leading (and trailing spaces)
   if strfind( '"''', temp_char(1) )                % the string starts with quotes
      PtfmFile = strtok( temp_char(2:end), temp_char(1) ); %read to the end of the quote
   else
      PtfmFile = strtok( temp_char );               % read to the first white space
   end
      
   fid2=fopen(PtfmFile);
   if (fid2 == -1)
      disp(['Platform file:  ',PtfmFile,' could not be opened.']);
      return
   end
   for iLine=1:11;
      fgetl(fid2);                                  % skip first 11 lines of PtfmFile
   end
   PtfmSurge = fscanf(fid2,'%g',1); fgetl(fid2);    % Initial platform surge
   PtfmSway  = fscanf(fid2,'%g',1); fgetl(fid2);    % Initial platform sway
   PtfmHeave = fscanf(fid2,'%g',1); fgetl(fid2);    % Initial platform heave
   PtfmRoll  = fscanf(fid2,'%g',1); fgetl(fid2);    % Initial platform roll
   PtfmPitch = fscanf(fid2,'%g',1); fgetl(fid2);    % Initial platform pitch
   PtfmYaw   = fscanf(fid2,'%g',1); fgetl(fid2);    % Initial platform yaw
   fclose(fid2);
end

for iLine=1:8                                       % skip 8 lines (133-140) of the FAST file
   fgetl(fid);                                      % (Nacelle-Yaw to beginning of Furling)
end

Furling   = strtrim( fgetl(fid) );                  % read line 141, Furling
temp_char = fgetl(fid);                             % read line 142, FurlFile line

%-----------------------------------------------------------------------
% If furling, read initial rotor and tail furl values:
% Open the Furling file (get the name of the file first)
%-----------------------------------------------------------------------
if ( strcmpi(Furling(1), 't') )
   temp_char = strtrim(temp_char);                  % remove leading (and trailing spaces)
   if strfind( '"''', temp_char(1) )                % the string starts with quotes
      FurlFile = strtok( temp_char(2:end), temp_char(1) ); % read to the end of the quote
   else
      FurlFile = strtok( temp_char );               % read to the first whitespace
   end
    
   fid2=fopen(FurlFile);
   if (fid2 == -1)
      disp(['Furling file:  ',FurlFile,' could not be opened.']);
      return
   end
   for iLine=1:7;
      fgetl(fid2);                                  % skip first 7 lines of FurlFile
   end
   RotFurl  = fscanf(fid2,'%g',1); fgetl(fid2);     % Initial rotor furl
   TailFurl = fscanf(fid2,'%g',1); fgetl(fid2);     % Initial tail furl
   fclose(fid2);
end

for iLine=1:42                                      % skip 42 lines (143-184) of the FAST file
    fgetl(fid);                                     % (Rotor-Teeter to beginning of OutList)
end

%--------------------------------------------------------------------------
% get the FAST outputs (OutList) and close the FAST input file
%--------------------------------------------------------------------------
%temp_char = strtrim( fgetl(fid) );
NumOuts   = 0;
OutList   = {};                                     % clear this from subsequent runs
delims    = [' ,;''"' char(9)];                     % allowable delimiters

while ~feof(fid)
       
      % get the next line
   temp_char = strtrim( fgetl(fid) );

   if length(temp_char) < 3     %FAST doesn't have 2-character variables; 
       
            % skip any blank lines
      if isempty(temp_char)
         continue;
      end
      
   elseif strcmpi( temp_char(1:3), 'end' )
            % we've reached the end
        break;
   end       
       
      % get the equivalent "line" that Fortran would read        
   if strfind( '"''', temp_char(1) )                % the string starts with quotes
      temp_char = strtok( temp_char(2:end), temp_char(1) ); % read to the end of the quotes
   else
      temp_char = strtok( temp_char );              % read to the first whitespace
   end
   
      % read all the words on the line     
%    while length(temp_char) > 1
   while ~isempty(temp_char)
      NumOuts = NumOuts + 1;
      [OutList{NumOuts,1}, temp_char] = strtok(temp_char,delims);
   end
   
   
end %while not END of FILE

fclose(fid);


%--------------------------------------------------------------------------
% Set number of DOFs
%--------------------------------------------------------------------------
if (NumBl == 2)
    NDOF = 22;
elseif (NumBl == 3 )
    NDOF = 24;
else
    disp ('NumBl must be 2 or 3')
end

%--------------------------------------------------------------------------
% Set DOF indices
%--------------------------------------------------------------------------
DOF_Sg   =  1;                                      % DOF index for platform surge.
DOF_Sw   =  2;                                      % DOF index for platform sway.
DOF_Hv   =  3;                                      % DOF index for platform heave.
DOF_R    =  4;                                      % DOF index for platform roll.
DOF_P    =  5;                                      % DOF index for platform pitch.
DOF_Y    =  6;                                      % DOF index for platform yaw.
DOF_TFA1 =  7;                                      % DOF index for 1st tower fore-aft mode.
DOF_TSS1 =  8;                                      % DOF index for 1st tower side-to-side mode.
DOF_TFA2 =  9;                                      % DOF index for 2nd tower fore-aft mode.
DOF_TSS2 = 10;                                      % DOF index for 2nd tower side-to-side mode.
DOF_Yaw  = 11;                                      % DOF index for nacelle-yaw.
DOF_RFrl = 12;                                      % DOF index for rotor-furl.
DOF_GeAz = 13;                                      % DOF index for the generator azimuth.
DOF_DrTr = 14;                                      % DOF index for drivetrain rotational-flexibility.
DOF_TFrl = 15;                                      % DOF index for tail-furl.
DOF_BE   = 17 + 3*(0:(NumBl-1))';                   %        1st blade edge mode--DOFs 17, 20, and 23 for blade 1, 2, and 3, respectively
DOF_BF   = [DOF_BE-1 DOF_BE+1];                     % col 1: 1st blade flap mode--DOFs 16, 19, and 22 for blade 1, 2, and 3, respectively
                                                    % col 2: 2nd blade flap mode--DOFs 18, 21, and 24 for blade 1, 2, and 3, respectively
DOF_Teet = 22;                                      % DOF index for rotor-teeter.

%--------------------------------------------------------------------------
% Create initial condition arrays in rad, rad/s
%--------------------------------------------------------------------------
q_init    = zeros(1,NDOF); 
qdot_init = zeros(1,NDOF); 


%--------------------------------------------------------------------------
% Set all initial conditions except initial blade and tower displacements, 
% which are very complicated equations.
%--------------------------------------------------------------------------
if (NumBl == 2)
    q_init(DOF_Teet)=TeetDefl*pi/180;
end
if ( strcmpi( Furling(1), 't') )
    q_init(DOF_RFrl) = RotFurl*pi/180;
    q_init(DOF_TFrl) = TailFurl*pi/180;
end
if ((PtfmModel == 1) || (PtfmModel == 2) || (PtfmModel == 3))
    q_init(DOF_Sg  ) = PtfmSurge;
    q_init(DOF_Sw  ) = PtfmSway;
    q_init(DOF_Hv  ) = PtfmHeave;
    q_init(DOF_R   ) = PtfmRoll*pi/180;
    q_init(DOF_P   ) = PtfmPitch*pi/180;
    q_init(DOF_Y   ) = PtfmYaw*pi/180;
end

q_init(DOF_Yaw )=NacYaw*pi/180;                     % convert from deg to radians
Azim_Initial = rem(Azimuth - AzimB1Up + 270.0 + 360.0, 360); % Internal position of blade 1.
q_init(DOF_GeAz)=Azim_Initial*pi/180;

qdot_init(DOF_GeAz)=RotSpeed*pi/30;

NacYaw   = q_init(DOF_Yaw );                           

% RotSpeed = RotSpeed*pi/30;                        % convert from rpm to rad/s
% HubHt = TowerHt + 0.5*HubRad;                     % calculate hub height

Initialized = 1;                                    % Tells S-function if this script ran prior to simulation.  0 = no.

%--------------------------------------------------------------------------
% clear variables not needed anymore
%--------------------------------------------------------------------------
clear temp_char fid iLine delims
clear AzimB1Up Azim_Initial FTitle 
clear PtfmModel PtfmFile PtfmSurge PtfmSway PtfmHeave PtfmRoll PtfmPitch PtfmYaw
clear Furling FurlFile RotFurl TailFurl fid2
clear OoPDefl IPDefl TeetDefl Azimuth TTDspFA TTDspSS RotSpeed %NacYaw 
clear TowerHt HubRad


