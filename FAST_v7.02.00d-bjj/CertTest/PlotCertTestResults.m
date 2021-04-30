% FAST-ADAMS-Simulink CertTest comparisons:

function PlotCertTestResults( newPath, oldPath, PlotFAST, PlotAdams, PlotSimulink )
%function PlotCertTestResults( newPath, oldPath, PlotFAST, PlotAdams, PlotSimulink )
% This function plots the FAST, ADAMS, and/or FAST_SFunc CertTest results, 
% comparing .out/.plt, .elm, .asi, .pmf, and .eig files from the newPath 
% with the files contained in oldPath. PlotFAST, PlotADAMS, and PlotSimulink 
% are true/false values that can be set to avoid plotting results from
% particular CertTests (e.g., you can choose not to plot Simulink results)
% 
% This function can produce hundreds of plots, so the files are saved as
% 150 dpi .png files in a directory called [oldPath "\Plots"] (which will 
% be created if it doesn't already exist).

if nargin < 5
    PlotSimulink = false;
end
if nargin < 4
    PlotAdams    = false;
end
if nargin < 3
    PlotFAST     = true;
end



    descFiles = {'SFunc', 'Adams',   'FAST'};
    plotFiles = [PlotSimulink, PlotAdams, PlotFAST];

    BslnTests = {'NRELOffshrBsline5MW_Floating_TLP_Original',...
                 'NRELOffshrBsline5MW_ITIBarge4_Original',...
                 'NRELOffshrBsline5MW_Monopile_RF',...
                 'NRELOffshrBsline5MW_Floating_OC3Hywind',...                
                 'NRELOffshrBsline5MW_Onshore' };
             

    for i = 1:17 %17+(1:5) 
        
        if i > 17
            fileRoot = BslnTests{i-17};
            newPath = ['5MWTestCases\' strrep( strrep(fileRoot,'_Original',''), '_Floating_OC3Hywind','_OC3Hywind') ];
        else
            fileRoot = ['Test' num2str(i,'%02.0f')];
        end
        
        oldRoot  = strcat( oldPath, filesep, fileRoot, {'_SFunc', '_ADAMS', ''} );
        newRoot  = strcat( newPath, filesep, fileRoot, {'_SFunc', '_ADAMS', ''} );
        
        if i == 14 % linearization case
            
            oldFiles = strcat( oldRoot,  {'.eig', '_LIN.out', '.eig'} );
            newFiles = strcat( newRoot,  {'.eig', '_LIN.out', '.eig'} );
            nModes   = 30;
            
            CompareCertTestResults(3,newFiles(plotFiles), oldFiles(plotFiles), nModes, descFiles(plotFiles), ...
                        [fileRoot ' - First ' num2str(nModes) ' Natural Frequencies'], true, [fileRoot '_nf'] );
            
        else
                % Compare time series                            
               
            if i == 4  % use the new binary file format
                oldFiles = strcat( oldRoot,  {'.outb', '.plt', '.outb'} );
                newFiles = strcat( newRoot,  {'.outb', '.plt', '.outb'} );
            else  % use the text format
                oldFiles = strcat( oldRoot,  {'.out', '.plt', '.out'} );
                newFiles = strcat( newRoot,  {'.out', '.plt', '.out'} );               
            end
            
            CompareCertTestResults(1,newFiles(plotFiles), oldFiles(plotFiles), [8, 7, 8], descFiles(plotFiles), [fileRoot ' Output Time Series'], true, [fileRoot '_ts'] );
        end % time series
        
        if i == 10
                % Compare .elm files
                
            oldFiles = strcat( oldRoot,  '.elm' );
            newFiles = strcat( newRoot,  '.elm' );
                                   
            CompareCertTestResults(1,newFiles(plotFiles), oldFiles(plotFiles), [4, 2, 3], descFiles(plotFiles), [fileRoot ' AeroDyn Time Series'], true, [fileRoot '_elm'] );
        end % elm files
            
        if i==1 || i==3 || i==8    
                % Compare .azi files
    
            oldFiles = strcat( oldRoot,  '.azi' );
            newFiles = strcat( newRoot,  '.azi' );
                                   
            CompareCertTestResults(1,newFiles(plotFiles), oldFiles(plotFiles), [7, 6, 7], descFiles(plotFiles), [fileRoot ' Azimuth Averages'] , true, [fileRoot '_azi'] );
        end %azi files
        

        if i==4 || i==7 || i==13 || i==17    
            % Compare .pmf files           
    
            oldFiles = strcat( oldRoot,  '.pmf' );
            newFiles = strcat( newRoot,  '.pmf' );
            
            if i == 4 || i == 17
                CompareCertTestResults(2,newFiles(plotFiles), oldFiles(plotFiles), [ 8,  7,  8], descFiles(plotFiles), [fileRoot ' Probability Density Functions'], true, [fileRoot '_pmf'] );
            else % these have TI and Mean Wind Speed in the header
                CompareCertTestResults(2,newFiles(plotFiles), oldFiles(plotFiles), [11, 10, 11], descFiles(plotFiles), [fileRoot ' Probability Density Functions'], true, [fileRoot '_pmf'] );
            end
            
        end %pmf files
                    
 
    end


return;
%% --------------------------------------------------------------------------
function CompareCertTestResults(pltType, newFiles, oldFiles, HdrLines, descFiles, descTitle, savePlts, saveName )
% Required Input:
%    pltType     - scalar that determines the content of the data files:
%                  when = 1, data file has one X column and many Y columns;
%                  when = 2, data file has X-Y columns.
%                  when = 3, data file is linearization output (files
%                            differ for differing output!)
%                  when = 4,  FAST binary format
%    newFiles    - cell array containing names of the new files to compare with oldFiles (no more than 7 files!)
%    oldFiles    - cell array containing names of the old files
%
% Optional Input:
%    HdrLines   - numeric array of size 3; default is [8, 7, 8]
%                 HdrLines(1) = total number of header lines in the file
%                 HdrLines(2) = number of the line containing the column titles
%                 HdrLines(3) = number of the line containing the column units
%    descFiles  - cell array containing description of the individual (new) files, displayed in plot legend
%    descTitle  - string or cell array containing a description of the plots, used in plot title
%    savePlts   - logical scalar; if true, plots will be saved as .png files in path(oldFiles)\Plots directory; default is false
%    saveName   - a RootName (relative to path(oldFiles)\Plots\) used to name the saved plots; default is RootName(oldFiles{1})
%
% Output:
%    none
    
        % set some constants for plotting

    LineWidthConst = 3;
    FntSz          = 18;
    LineColors     = {[0 1 1],[1 0 1],[0 1 0],[0 0 1],[1 0 0],[1 1 0],[1 1 1]};

        % set some parameters that won't change
    OneXCol  = 1;
    ColPairs = 2;
    NatFreq  = 3;
    FASTBin  = 4;
        
        % get the number of files and do some checking
    numFiles = length(oldFiles);
    numNew   = length(newFiles);
    if numFiles ~= numNew
        error('CompareCertTestResults::oldFiles and newFiles file name cell arrays must be the same size for comparisons.');
    end

    if numFiles > length(LineColors)
        error('CompareCertTestResults::too many files.  there aren''t enough colors defined.');
    end
    
        % set some defaults for optional inputs

    if nargin < 7
        savePlts = false;
        
        if nargin < 4
            HdrLines = [8, 7, 8];
        end
        
    end

    if nargin < 6 || isempty(descTitle)  %short-circuting allowed!
        descTitle = {'File Comparisons Using Old Files' oldFiles{:}};
    else
        descTitle = ['File Comparisons for ' descTitle];
    end

    if (nargin <= 4) || (numFiles ~= length(descFiles))
        descFiles = cell(nf,1);
        getTxt = true;
    else
        getTxt = false;
    end

    [pathstr, name ] = fileparts(oldFiles{1} );
    if nargin < 8 
        saveName = name;
    end
    OutFilePath = [pathstr filesep 'Plots' ];

        % make sure the directory exists; if not, create it
    if ~exist(OutFilePath, 'dir')
        mkdir( OutFilePath );
    end
        
        
    OutFileRoot = [OutFilePath filesep saveName];
    
    
        % get the data for plotting
        
    oldData = cell(numFiles,1);
    newData = cell(numFiles,1);
    
    if pltType == NatFreq
        nFreq = HdrLines(1);
        fig = plotNaturalFrequencies( oldFiles, newFiles, descFiles, descTitle, nFreq, FntSz, LineColors );
        

        set(fig,'paperorientation','landscape','paperposition',[0.25 0.25 10.5 8])
        if savePlts
            print(['-f' num2str(fig)],'-dpng','-r150',[OutFileRoot '.png']);
            close(fig)
        end
        
        return;
        
    end
    
    nCols   = 0;
    if pltType == FASTBin        
        for iFile = 1:numFiles
            [oldData{iFile}                   ] = ReadFASTbinary( oldFiles{iFile} );
            [newData{iFile}, colName, colUnits] = ReadFASTbinary( newFiles{iFile} );                
            nCols = max(nCols, size(oldData{iFile},2));

            if getTxt
                descFiles{iFile} = ['File ' num2str(iFile)];
            end
        end        
    else %read the text file        
   
        for iFile = 1:numFiles
            if strcmpi( oldFiles{iFile}(end-4:end),'.outb' )
                [oldData{iFile}                   ] = ReadFASTbinary( oldFiles{iFile} );
            else
                [oldData{iFile}                   ] = getColumnData(oldFiles{iFile}, '', HdrLines(1), HdrLines(2), HdrLines(3));
            end
            if strcmpi( newFiles{iFile}(end-4:end),'.outb' )
                [newData{iFile}, colName, colUnits] = ReadFASTbinary( newFiles{iFile} );                
            else
                [newData{iFile}, colName, colUnits] = getColumnData(newFiles{iFile}, '', HdrLines(1), HdrLines(2), HdrLines(3));
            end
            
            nCols = max(nCols, size(oldData{iFile},2));

            if getTxt
                descFiles{iFile} = ['File ' num2str(iFile)];
            end
        end
    end
    

    if nCols == 0
        disp(['CompareCertTestResults::No data found for ' saveName]);
        return;
    elseif pltType == ColPairs
        if mod(nCols,2) ~= 0
            error(['CompareCertTestResults::number of columns must be even for X-Y pairings for ' saveName]);
        end
    end

    NoDiff = true(numFiles,1);

    for iFile = 1:numFiles

        [nr_Old, nc_Old] = size(oldData{iFile});
        [nr_New, nc_New] = size(newData{iFile});

        if nc_New == 0 || nc_Old == 0
            NoDiff(iFile) = false;            
        else

            if nCols ~= nc_Old || nCols ~= nc_New 
                disp( [ iFile, nCols, nc_Old, nc_New, nr_Old, nr_New] )
                error(['CompareCertTestResults::number of columns differ in the file comparisons of old and new ' descFiles{iFile} ' files.']);
            end

            if nr_Old ~= nr_New
                disp('WARNING: CompareCertTestResults::number of rows differ in the file comparisons');
                NoDiff(iFile) = false;
            else

                if pltType == OneXCol
                    t_diff = oldData{iFile}(:,1) - newData{iFile}(:,1);
                    if norm(t_diff,inf) > 0.005 
    %                     figure; plot(t_diff);
                        disp(['WARNING: CompareCertTestResults::X columns (column 1) in old and new ' descFiles{iFile} ...
                                     ' files differ by more than 0.005' colUnits{1} ] );
                        NoDiff(iFile) = false;
                    end
                elseif pltType == ColPairs 
                    t_diff = oldData{iFile}(:,1:2:end) - newData{iFile}(:,1:2:end);
                    if norm(t_diff(:),inf) > 0.005 %bjj this is probably not a very good test
    %                     figure; plot(t_diff);
                        disp(['WARNING: CompareCertTestResults::X columns in old and new ' descFiles{iFile} ...
                                     ' files differ by more than 0.005 units.'] );
                        NoDiff(iFile) = false;
                    end %norm(t_diff(

                end %OneXCol

            end   %nr_Old ~= nr_New
        end %nc_New == 0 || nc_Old == 0

    end %for iFile

        % create the plots for time series-type data
            
    switch pltType 
        case ColPairs
            strd = 2;
         case OneXCol
            strd = 1;
        otherwise
            error(['CompareCertTestResults::invalid plot type ' num2str(pltType) ]);

    end 
    
    anyDiffPlot = false;
    for iPlot = 2:strd:nCols
        fig=figure;
        
        switch pltType 
            case ColPairs
                xCol = iPlot-1;
             case OneXCol
                xCol = 1;
        end 
        
        for iFile = 1:numFiles
            subplot(6,1,1:4);
            hold on;
            
            if size(oldData{iFile},2) == nCols
                h1(1) = plot(oldData{iFile}(:,xCol), oldData{iFile}(:,iPlot));
                set(h1(1),'LineStyle','-', 'DisplayName',[descFiles{iFile} ', old'],'Color',LineColors{iFile},      'LineWidth',LineWidthConst+1);
            end

            if size(newData{iFile},2) == nCols
                h1(2) = plot(newData{iFile}(:,xCol), newData{iFile}(:,iPlot) );
                set(h1(2),'LineStyle','--','DisplayName',[descFiles{iFile} ', new'],'Color',LineColors{iFile}*0.75, 'LineWidth',LineWidthConst+1);       
            end            
            currXLim = xlim;


            if NoDiff(iFile)
                anyDiffPlot = true;
                    % absolute difference
                subplot(6,1,5);
                AbsDiff = (oldData{iFile}(:,iPlot)-newData{iFile}(:,iPlot) );
                plot(oldData{iFile}(:,xCol) ,   AbsDiff, ...
                      'Displayname',descFiles{iFile},'Color',LineColors{iFile}, 'LineWidth',LineWidthConst);
                hold on;
                xlim(currXLim);

                    % relative difference (% of old)
                subplot(6,1,6);
                plot(oldData{iFile}(:,xCol) ,   100*AbsDiff./ oldData{iFile}(:,iPlot), ...
                      'Displayname',descFiles{iFile},'Color',LineColors{iFile}, 'LineWidth',LineWidthConst);
                hold on;
                xlim(currXLim);
            end

        end %iFile

        for iSubPl=1:3
            if iSubPl == 3
                subplot(6,1,1:4)            
                yTxt = {colName{iPlot}, colUnits{iPlot}} ;
            elseif anyDiffPlot
                if iSubPl == 2  
                    subplot(6,1,5)
                    yTxt = {'Difference' ,'(Old-New)', colUnits{iPlot}};
                else
                    subplot(6,1,6);
                    yTxt = {'Relative' 'Difference','(%)'};
                    xlabel([colName{xCol} ' ' colUnits{xCol}],'FontSize',FntSz ) ;
                end
            else
                xlabel([colName{xCol} ' ' colUnits{xCol}],'FontSize',FntSz ) ;
                continue;
            end
            set(gca,'FontSize',FntSz,'gridlinestyle','-');           
            ylabel(yTxt);        
            grid on;
        end %iSubPl
        t=title( descTitle,'interpreter','none' );
        set(t,'interpreter','none');
        h=legend('show');
        set(h,'interpreter','none','FontSize',FntSz-3); %'location','best');

        set(fig,'paperorientation','landscape','paperposition',[0.25 0.25 10.5 8])
        if savePlts
            print(['-f' num2str(fig)],'-dpng','-r150',[OutFileRoot '_' num2str(iPlot-1) '.png']);
            close(fig)
        end
    end       %iPlot    
            

return;
%% ------------------------------------------------------------------------
function [fig] = plotNaturalFrequencies( oldFiles, newFiles, descFiles, descTitle, nFreq, FntSz, LineColors )

    nf = length(oldFiles);
    
    OldData = cell(nf,1);
    NewData = cell(nf,1);
        % get the data
%     barData = [];    
%     descTxt = cell(nf*2,1);
    groupSpacing = 1;  %this serves as our spacing between groupings (fraction of a bar)
    nBars = 0;  
    maxNF = 0;
    for iFile = 1:nf
        OldData{iFile} = getEigenvaluesFromFile(oldFiles{iFile});
        NewData{iFile} = getEigenvaluesFromFile(newFiles{iFile});
        
        if ~isempty(OldData{iFile})
            nBars = nBars + 1;
            maxNF = max(maxNF, length(OldData{iFile}));
        end
        if ~isempty(NewData{iFile})
            nBars = nBars + 1;
            maxNF = max(maxNF, length(NewData{iFile}));
        end

%         indx   = iFile*2;        
%         indxm1 = indx - 1 ;
%
%         barData{:,indx  } = getEigenvaluesFromFile(newFiles{iFile});
%         barData{:,indxm1} = getEigenvaluesFromFile(oldFiles{iFile});
%         
%         descTxt{indx}     = [descFiles{iFile} ', new'];
%         descTxt{indxm1}   = [descFiles{iFile} ', old'];
    end    
    
        % create a bar plot
    fig = figure;
    
    t = title( descTitle,'interpreter','none','FontSize',FntSz );
    set(t,'interpreter','none');
    hold on;
    
    barIndxStart = 1.5;
    barIndx = barIndxStart;
    groupSpacing = groupSpacing + nBars;
    for iFile = 1:nf
    
        L1 = length(OldData{iFile});
        if L1 > 0
            xAxis = ( 0:(L1-1) )*groupSpacing + barIndx;
            h = bar(xAxis,OldData{iFile},1/groupSpacing);
            set(h, 'FaceColor', LineColors{iFile}, 'DisplayName',[descFiles{iFile} ', old']);
            barIndx = barIndx + 1;
        end
        
        L2 = length(NewData{iFile});
        if L2 > 0
            xAxis = ( 0:(L2-1) )*groupSpacing + barIndx;
            h = bar(xAxis,OldData{iFile},1/groupSpacing);
            set(h, 'FaceColor', LineColors{iFile}*0.65, 'DisplayName',[descFiles{iFile} ', new']);
            barIndx = barIndx + 1;                        
        end        
    end
    
    
    if maxNF > 0
        xAxis = ( 0:(maxNF-1) )*groupSpacing + barIndx - 0.5*nBars - 0.5;
%         set(gca,'xlim',[1 maxNF*nBars+barIndx-1],'xtick',xAxis);
        
        nFact = max(1,floor(nFreq/15)); %15 is max number of axis ticks
        
        set(gca,'xtick',xAxis(1:nFact:end),'xticklab',1:nFact:maxNF);        
        set(gca,'xlim',[1 groupSpacing*nFreq]);        
    end

    set(gca,'FontSize',FntSz-3,'ygrid','on','gridlinestyle','-');
    ylabel('Full System Natural Frequency, Hz','FontSize',FntSz);    
    xlabel('Full System Mode Number','FontSize',FntSz);
    box on;
    
    h=legend('show');
    set(h,'interpreter','none','FontSize',FntSz-3,'location','NorthWest');


return
%% ------------------------------------------------------------------------
function [eivalues] = getEigenvaluesFromFile(fileName)

    fid = fopen(fileName);
    
    if fid > 0
        line = fgetl(fid);
        
        while ischar(line)
    
            if isempty( strfind(line, 'E I G E N V A L U E S') ) % ADAMS FILES HAVE THIS IDENTIFIER (but this could change in other versions!!!!)
                
                if isempty( strfind(line, 'ans =') )             % Output from Matlab script (this could change, in other versions, too!!!!!)
                    
                        % keep looking
                        
                    line = fgetl(fid);
                    
                else                    
                    
                         % read from Matlab (FAST) output file
                    dat = textscan( fid, '%f' ); %we'll read to the end of this section/file where there aren't any more numbers
                    eivalues = dat{1};
                    break;                    
                    
                end                    
                    
            else
                
                    % read from ADAMS output file
                
                fgetl(fid);  % header
%                 textscan( fid, '%*s%f', 'delimiter','+/-' ); %we're just getting the imaginary parts
                dat = textscan( fid, '%f%f%*s%f' ); %we'll read to the end of this section (when there aren't numbers anymore)
                eivalues = dat{3};
                break;
                
            end
        end
        fclose( fid );        
    else
        disp( ['getEigenvaluesFromFile::Error ' num2str(fid) ' opening file, "' fileName '".' ]);
        eivalues = [];
    end

return;
%% ------------------------------------------------------------------------
function [data, colNames, colUnits] = getColumnData(fileName, delim, HeaderRows, NameLine, UnitsLine )
% this function reads the text file, fileName, which is presumed to contain a 
% number of header rows and columns of numerical data.
%
% Required Input:
%    fname      - the name of the file to be opened
% Optional Input:
%    delim      - the column delimiter, default is all whitespace
%    HeaderRows - the number of header rows in the file; default is 8
%    NameLine   - the line number containing the column names; default is
%                 max( HeaderRows - 1, 0);
%    UnitsLine  - the line number containing the column units; default is
%                 min( NameLine + 1, HeaderRows );
%
% Output:
%    data       - matrix containing the data from the file
%    colNames   - a cell array containing the text for the columns
%    colUnits   - a cell array containing the units for the columns

    switch nargin;
        case 1
            delim = '';
            HeaderRows = 8;
            NameLine   = 7;
            UnitsLine  = 8;
        case 2
            HeaderRows = 8;
            NameLine   = 7;
            UnitsLine  = 8;
        case 3
            NameLine   = max(HeaderRows - 1, 0);
            UnitsLine  = NameLine + 1;
        case 4
            UnitsLine  = NameLine + 1;
        case 5
        otherwise
            error('getColumnData::Invalid number of inputs.')
    end
              
    if nargout < 3
        UnitsLine = 0;
        if nargout < 2
            NameLine = 0;
        end
    end
    
    if UnitsLine > HeaderRows
        UnitsLine = 0;
    end
    
    if NameLine > HeaderRows
        NameLine = 0;
    end

    
     
    fid = fopen(fileName);
    if fid <= 0
        disp(['getColumnData::Error ' int2str(fid) ' reading from file, "' fileName '"'] )
        data     = [];
        colNames = {};
        colUnits = {};
    else    
        nCols1 = 0;
        nCols2 = 0;
    
        if UnitsLine == 0 && NameLine == 0
            fclose(fid);
            data = dlmread(fileName,delim,HeaderRows,0);
            nCols = size(data, 2);
        else
            for i = 1:HeaderRows
                line = fgetl(fid);
                
                if i == NameLine
                    if isempty( delim )
                        colNames = textscan( line, '%s' );  %all whitespace; consecutive whitespace is okay
                    else
                        colNames = textscan( line, '%s', 'delimiter', delim ); %consecutive delimiters are separate columns
                    end
                    colNames = colNames{1};                    
                    nCols1 = length(colNames);
                    
                elseif i == UnitsLine
                    if isempty( delim )
                        colUnits = textscan( line, '%s' );
                    else
                        colUnits = textscan( line, '%s', 'delimiter', delim );
                    end
                    colUnits = colUnits{1};
                    nCols2 = length(colUnits);
                   
                end %if i
                
            end %for i
            
            if nCols1 ~= nCols2 && nCols1*nCols2 > 0
                 disp( ['getColumnData::Column names and units are different sizes in file, "' fileName '."']  );
            end 
            nCols = max( nCols1, nCols2 );
             
            fmtStr = repmat('%f',1,nCols);
            if isempty( delim )
               data = cell2mat( textscan( fid, fmtStr ) );
            else
               data = cell2mat( textscan( line, fmtStr, 'delimiter', delim ) );
            end

            fclose(fid);

        end %UnitsLine == 0 && NameLine == 0
            
        if nargout > 1
          if nCols < nCols1
             colNames(nCols+1:end) = cell(nCols1-nCols,1);
          end

          if nargout > 2
             if nCols < nCols2
                colUnits(nCOls+1:end) = cell(nCols2-nCols,1);
             end
          end
        end
    
    end


return;
