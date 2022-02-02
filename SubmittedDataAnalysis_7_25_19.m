
close all;
clear all;

%groupNum = [210 211 212 213 214];
groupNum = [220 221 222 223 224];
outputIdx = 0;
outputNumData = [];
outputTextData = strings([1,4]);
for iGroup = 1:size(groupNum,2)
  [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(groupNum(iGroup));
  testName = strrep(testDir,'\','_');
  for iFile = 1:size(fileNames,1)
    %Load the registered raw data and grid files
    disp(strcat('Working on file => ',fileNames(iFile)));
    regData = [];
    regGridData = [];
    regRawDataFile = strcat(baseDir,testDir,'/',fileNames(iFile), '_reg.mat');
    load(regRawDataFile);
    regGridMatFile = strcat(baseDir,testDir,'/',fileNames(iFile), '_regGrid.mat');  
    load(regGridMatFile);
    regGridDatFile = strcat(baseDir,testDir,'/',fileNames(iFile), '_regGrid.dat');  


    %Calculate the raw data statistics
    aveVals = mean(regData(:,3:8));
    stdDev = std(regData(:,3:8));
    minVals = min(regData(:,3:8));
    maxVals = max(regData(:,3:8));
    allVals = [aveVals; minVals; maxVals; stdDev];
    %allVals = allVals.';
    allVals = reshape(allVals,1,[]);

    %Save the stats to the overall output matrix
    outputIdx = outputIdx + 1;
    outputNumData(outputIdx,:) = [size(regData,1) stepVals(iFile,:) allVals];
    outputTextData(outputIdx,:) = [groupID; num2str(sysNum); appliedStep(iFile); dataSet];


    %subtract out the mean from the grid data translations and save for
    %techplot
    disp('sub mean');
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
    disp('end sub mean');


    %Save TechPlot formatted grid data
    fileBase = strcat(fileNames(iFile));
    zoneName = strcat(fileBase, ' ');
    disp(strcat('Writing Techplot RegGridFile => ',regGridDatFile));      
    techPlotData.file = regGridDatFile;
    techPlotData.title = strcat('"', strcat('Group_', groupID, ' System_', num2str(sysNum), ' Dataset_', dataSet, '"'));
    techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U-aveU(mm)" "V-aveV(mm)" "W-aveW(mm)" "Count"';
    techPlotData.zoneTitle = char(strcat('"', zoneName, '"'));
    [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);
    WriteTechPlot(techPlotData, regGridData,auxZoneNames, auxZoneVals);
    disp(strcat('End => ' ,zoneName)); 

  end
end
%Save the stats to the spreadsheet
outputFile = strcat(baseDir, 'GlobalDataStatistics.xlsx');
headder = ["groupID" "system" "step" "series" "#Points" "disp1" "disp2" "x ave" "x min" "x max" "x stdev" "y ave" "y min" "y max" "y stdev" "z ave" "z min" "z max" "z stdev"  "u ave" "u min" "u max" "u stdev"  "v ave" "v min" "v max" "v stdev"  "w ave" "w min" "w max" "w stdev"]; 
sheetName = char(strcat('Group_', groupID, '_System_', num2str(sysNum)));
writematrix(outputTextData,outputFile,'sheet',sheetName,'Range','A2');
writematrix(outputNumData,outputFile,'sheet',sheetName,'Range','E2');
writematrix(headder,outputFile,'sheet',sheetName,'Range','A1');


