% Test14.m
% Written by J. Jonkman, NREL
% Last update: 03/27/2006

% This m-file is used to call Eigenanalysis.m using file 'Test14.lin' and echo
%   out the average sorted natural frequencies.

%bjj rm:% ----------- Call Eigenanalysis.m using Test14.lin -----------------------
% ----------- Call GetMats.m and mbc3 using Test14.lin -----------------------
RootName = 'Test14';
%bjj start of proposed change (replace with scripts from MBC)
%rm Eigenanalysis;
GetMats

mbc3
%bjj end of proposed change

% ----------- Echo out the average sorted natural frequencies -------------
N
%bjj start of proposed change (replace with scripts from MBC)
%rm sort( AvgNaturalFrequencyHz )
sort( MBC_NaturalFrequencyHz )
%end end of proposed change (replace with scripts from MBC)


% ----------- Exit MATLAB -------------------------------------------------
exit;


