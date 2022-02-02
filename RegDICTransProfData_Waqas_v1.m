
close all
clear all
clc
cd('G:\DIC\Matlab')
tic
% profile on
deadZone = 0.3;  %dead area around discontinuities for registration (mm)
fDoRegistration = true; %register the data (otherwise read from parm file)
fSubDispFromProfile = true;%false; %subtract the displacement data from the profile to keep profiles at 0,0
fRemoveOutliers = true; %remove data with displacements greater than numStdDev from the mean
numStdDev = 3;
fSaveRegData = true;%true %save the registered data

fSaveRegGrid_w = true; %W: I added these to avoid saving files 

fSaveRegGrid = true;%true  %create and save a regular grid of registered data
fSaveTPlotGrid = false;  %save a regular grid of data for techplot
fCalcProfileNoise = true;%true; %calculate the noise in the profile from the 5 samples
fSaveGlobalStats = true; %save the global stats to the excel sheet
fExitOnEnd = false; %exit the program at the end

%setup the grid parameters
[gridParms,minCounts] = GetGridParms;

%setup the output matricies for the EXCEL sheet
outputIdx = 0;
outputNumData = [];
outputTextData = strings([1,4]);

%select the groups to work on
% groups = [310 311 312 313 314];  %group 3 system 1
% groups = [220 221 222 223 224];  %group 2 system 2
% groups = [210 211 212 213 214];  %group 2 system 1
%groups = [310];

% sysgroups = [310 311 312 313 314];  %group 3 system 1 GREWER
sysgroups = [320 321 322 323 324];  %group 3 system 2 GREWER
% sysgroups = [220 221 222 223 224;...%group 2 system 2 LAVA
%             210 211 212 213 214];  %group 2 system 1
% groups = [];

% sysgroups = [115;125]; % Sandia 

% sysgroups = [210 211 212 213 214];  %group 3 system 1 GREWER

for grp = 1:size(sysgroups,1)
    groups = sysgroups(grp,:);
for iGroupNum = 1:size(groups,2)
  groupNum = groups(iGroupNum);
  
  %Get the filenames for the test
  [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(groupNum);  

  %setup the filenames for the analysis
  testName = strrep(testDir,'\','_');
  testDir = strcat(testDir, '\');
  
  %get the parameters that describe the surface
  [theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(sysNum, deadZone);
  
  %Make regular grid data from all the files
  for iFile = 1:size(fileNames,1)
    %setup the input file name
    disp('*************************************************************');
    disp(strcat('working on file: ',fileNames(iFile)));
    fileBase = strcat(fileNames(iFile));
    DICFileBase = strcat(baseDir, testDir, fileBase);
    DICInputFile = strcat(DICFileBase, '.mat');
    zoneName = strcat(fileBase, ' ');  %%move to techplot area
    
    %Read the data and then seperate into the sepaerate areas
    whos('-file', DICInputFile);
    fLoad = load(DICInputFile);
    A_1 = fLoad.(cell2mat(fieldnames(fLoad)));

    %strip out any nan entries
    disp(strcat('-rows before StripNan', num2str(size(A_1,1))));
    initRows = size(A_1, 1);
    NaNRows = size(A_1,1);
    A_1 = rmmissing(A_1);
    NaNRows = NaNRows - size(A_1,1);    
    disp(strcat('-rows after StripNan', num2str(size(A_1,1))));
        
    %fill the world and image data arrays
    imgData = A_1(:,1:2);
    profData = A_1(:,3:5);
    dispData = A_1(:,6:8);
    
    %remove the displacement from data where it is added to the profile
    if fSubDispFromProfile
      disp('subtracting displacements from the profile');
      profData = profData - dispData;
    end
    
    %if it is the first file either do the registration or get the parms
    if iFile == 1
        RegParmsFile = strcat(DICFileBase, '_RegParms.dat');        
        if fDoRegistration
          disp('calculating the registration parameters');
          %seperate the data into the registration areas
          [areas, areaPnts]=SeperateFitAreas(imgData, profData, fitBoundries);
          %register and return the optimized transform values  
          optVals = RegisterPlate(areas, areaPnts, areaCoef, 3);
          %save the parameters
          csvwrite(RegParmsFile, optVals);
        else
          assert(isfile(RegParmsFile),'Parameter file not found');
          disp('reading the registration parameters from file');          
          %read the saved parameters
          optVals = csvread(RegParmsFile);
        end
    end
    
    %%apply the transformation to the full data set
    disp('applying the registraion transformation to the data');
    rotArrReg = RotArray(optVals(1), optVals(2), optVals(3));
    transArrReg = [optVals(4) optVals(5) optVals(6)];
    regProfData = profData*rotArrReg+transArrReg;
    regDispData = dispData*rotArrReg;
    
    %Calculate the raw data statistics
    disp('calculating global stats');
    regData = [imgData regProfData regDispData];
    aveVals = mean(regData(:,3:8));
    stdDev = std(regData(:,3:8));
    minVals = min(regData(:,3:8));
    maxVals = max(regData(:,3:8));
    allVals = [aveVals; minVals; maxVals; stdDev];
    allVals = reshape(allVals,1,[]);    
    
    outlierRows = 0.0;
    if fRemoveOutliers
      disp('removing outlier data');
      disp(strcat('-rows before removing outliers', num2str(size(regData,1))));
      outlierRows = size(regData,1);
      regData(regData(:,6)<(aveVals(4)-numStdDev*stdDev(4)),6)= NaN;
      regData(regData(:,7)<(aveVals(5)-numStdDev*stdDev(5)),7)= NaN;
      regData(regData(:,8)<(aveVals(6)-numStdDev*stdDev(6)),8)= NaN;
      regData(regData(:,6)>(aveVals(4)+numStdDev*stdDev(4)),6)= NaN;
      regData(regData(:,7)>(aveVals(5)+numStdDev*stdDev(5)),7)= NaN;
      regData(regData(:,8)>(aveVals(6)+numStdDev*stdDev(6)),8)= NaN;
      regData = rmmissing(regData);
      outlierRows = outlierRows - size(regData,1);
      disp(strcat('-rows after removing outliers', num2str(size(regData,1))));
      
      %recalculate the data statistics
      disp('recalculating global stats');
      aveVals = mean(regData(:,3:8));
      stdDev = std(regData(:,3:8));
      minVals = min(regData(:,3:8));
      maxVals = max(regData(:,3:8));
      allVals = [aveVals; minVals; maxVals; stdDev];
      allVals = reshape(allVals,1,[]);       
    end    
    
    %Save the stats to the overall output matrix
    outputIdx = outputIdx + 1;
    outputNumData(outputIdx,:) = [initRows, NaNRows, outlierRows, stepVals(iFile,:) allVals];
    outputTextData(outputIdx,:) = [groupID; num2str(sysNum); appliedStep(iFile); dataSet];    
    
    %save the img and profile data for the profile noise analysis
    if fCalcProfileNoise && iFile ==1
      switch iGroupNum
        case 1
          profile1 = regData(:,1:6);
        case 2
          profile2 = regData(:,1:6);
        case 3
          profile3 = regData(:,1:6);
        case 4
          profile4 = regData(:,1:6);
        case 5
          profile5 = regData(:,1:6);
      end
    end
    
    if fSaveRegData
      %Save the registered data for the profile
      regMatFile = strcat(DICFileBase, '_Reg.mat');
      %Save the registered data
      disp(strcat('Writing RegMatFile => ',regMatFile));
      %regData = CalcPntErrs(areaCoef, regData, theoCorners);
      save(regMatFile,'regData'); 
    end
    
    if fSaveRegGrid_w || fSaveTPlotGrid
      %Save a grid of the data
      disp('Creating grid data ');
      regGridData=DataGrid(regData(:,3:5), regData(:,6:8), gridParms, minCounts);
      
      %save the registered grid of data
      if fSaveRegGrid 
        regGridMatFile = strcat(DICFileBase, '_RegGrid.mat');      
        disp(strcat('Writing RegGridFile => ',regGridMatFile));      
        save(regGridMatFile,'regGridData');
      end
      
      %save the registered grid of data for plotting
      if fSaveTPlotGrid 
        disp('save techplot file');
        disp('subtract mean displacements for plotting');
        for ix = 1:size(regGridData,1)
          for iy = 1:size(regGridData,2)
            regGridData(ix,iy,4) = regGridData(ix,iy,4) - aveVals(4);
            regGridData(ix,iy,5) = regGridData(ix,iy,5) - aveVals(5);
            regGridData(ix,iy,6) = regGridData(ix,iy,6) - aveVals(6);
            if regGridData(ix,iy,7)<4
              regGridData(ix,iy,4) = 0;
              regGridData(ix,iy,5) = 0;
              regGridData(ix,iy,6) = 0;        
            end
          end
        end
        disp('end techplot subtract mean');        
        
        %Save TechPlot formatted grid data
        regTPlotDatFile = strcat(DICFileBase, '_TPlotGrid.dat');
        disp(strcat('Writing Techplot RegTPlotFile => ',regTPlotDatFile));      
        zoneName = strcat(fileBase, ' ');
        techPlotData.file = regTPlotDatFile;
        techPlotData.title = strcat('"', strcat('Group_', groupID, ' System_', num2str(sysNum), ' Dataset_', dataSet, '"'));
        techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U-aveU(mm)" "V-aveV(mm)" "W-aveW(mm)" "Count"';
        techPlotData.zoneTitle = char(strcat('"', zoneName, '"'));
        [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);
        WriteTechPlot(techPlotData, regGridData,auxZoneNames, auxZoneVals);
        disp(strcat('End => ' ,zoneName)); 
      end

      
    end
    %WAQAS: Added code for plotting  
    avgFlag = 0;
    scale = 1;
    if avgFlag == 1
        regGridData(:,:,4) = regGridData(:,:,4) - aveVals(4);
        regGridData(:,:,5) = regGridData(:,:,5) - aveVals(5);
        regGridData(:,:,6) = regGridData(:,:,6) - aveVals(6);
    end
    
%     imgfolder1 = fullfile(testfolder,strcat(imgfolder,date));
%     
%     if ~isfolder(imgfolder1)
%         mkdir(imgfolder1)
%     end
    if  iGroupNum == 1 && iFile == 1
        
        flag = 1;
    else
        flag = 0;
    end
%    p = profile('info')     
   [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);    
    labn = [auxZoneNames;auxZoneVals]';
    DICFileLoc = strcat(baseDir, testDir);
    fileext = '.png';
    fieldP = post_plot(regGridData,flag,labn,1,DICFileLoc,avgFlag,scale,fileext);
    exportgraphics(gcf,fieldP,'Resolution',300) %U Disp
    clf;
    fieldP = post_plot(regGridData,flag,labn,2,DICFileLoc,avgFlag,scale,fileext);
    exportgraphics(gcf,fieldP,'Resolution',300) %V Disp
    clf;
    fieldP = post_plot(regGridData,flag,labn,3,DICFileLoc,avgFlag,scale,fileext);
    exportgraphics(gcf,fieldP,'Resolution',300) %W Disp
    clf;
    fieldP = post_plot(regGridData,flag,labn,4,DICFileLoc,avgFlag,scale,fileext);
    exportgraphics(gcf,fieldP,'Resolution',300) %Abs Disp
    clf;
    
  end
end
if fSaveGlobalStats
  disp('Saving global stats');
  %Save the stats to the spreadsheet
  outputFile = strcat(baseDir, 'GlobalDataStatistics.xlsx');
  headder = ["groupID" "system" "step" "series" "init rows" "NaN rows" "outlier rows" "disp1" "disp2" "x ave" "x min" "x max" "x stdev" "y ave" "y min" "y max" "y stdev" "z ave" "z min" "z max" "z stdev"  "u ave" "u min" "u max" "u stdev"  "v ave" "v min" "v max" "v stdev"  "w ave" "w min" "w max" "w stdev"]; 
  sheetName = char(strcat('Group_', groupID, '_System_', num2str(sysNum)));
  writematrix(outputTextData,outputFile,'sheet',sheetName,'Range','A5');
  writematrix(outputNumData,outputFile,'sheet',sheetName,'Range','E5');
  writematrix(headder,outputFile,'sheet',sheetName,'Range','A4');

  if fCalcProfileNoise
    disp('calculating profile noise');
    [numProfPts, minDiffProf, maxDiffProf, stdDiffProf] = calcProfileNoise(profile1, profile2, profile3, profile4, profile5);
    outputVals = [numProfPts minDiffProf maxDiffProf stdDiffProf];
    headder = ["Profile Noise" "num Points" "min dev x" "min dev y" "min dev z" "max dev x" "max dev y" "max dev z" "std dev x" "std dev y" "std dev z"];
    writematrix(headder,outputFile,'sheet',sheetName,'Range','A1');   
    writematrix(outputVals,outputFile,'sheet',sheetName,'Range','B2');    
  end
  
end
end
toc
if fExitOnEnd
  exit;
end
