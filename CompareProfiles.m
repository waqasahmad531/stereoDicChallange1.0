
%Which comparisions should be run?
fSys1Laser=false;
fSys2Laser=false;
fSys1Sys2=false;
fSys1Sys2Tpc=false;
fSys1Mod=false;
fSys2Mod=false;
fLaserMod=false;
fSys1_1_Sys1_11=false;
fSys1_1_Sys1_11b=true;


%Registers DIC data to the surface model saves the registration data
baseDir = 'C:\Users\jhelm\Documents\Sabbatical_Work\DIC Challenge Registration\DIC Data\';
%Get the filenames for DIC system 1
[fileNames, testDir]=DicDataFileNames(1);
%setup the filenames for the analysis
sys1TestName = testDir;
testDir = [testDir '\'];
fileBase = [char(fileNames(1)) '_StchRegProfGrid'];
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
sys1Data = gridData;
sys1_1_Data = gridData;

fileBase = [char(fileNames(11)) '_StchRegProfGrid'];
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
sys1_11_Data = gridData;

fileBase = [char(fileNames(11)) '_StchRegGrid'];
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
sys1_11b_Data = gridData;

%Get the filenames for DIC system 2
[fileNames, testDir]=DicDataFileNames(2);
%setup the filenames for the analysis
sys2TestName = testDir;
testDir = [testDir '\'];
fileBase = [char(fileNames(1)) '_StchRegProfGrid'];
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
sys2Data = gridData;

%Get the filenames for DIC system 2 with tpc
[fileNames, testDir]=DicDataFileNames(2);
%setup the filenames for the analysis
sys2TestName = testDir;
testDir = [testDir '\'];
fileBase = [char(fileNames(1)) '_StchTpcRegProfGrid'];
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
sys2TpcData = gridData;

%setup the filenames for the laser scan
laserTestName = 'LaserScan';
testDir = 'LaserScan\';
fileBase = 'LaserScanRegGridData';
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
laserData = gridData;

%setup the filenames for the plate model
modelTestName = 'PlateModel';
testDir = 'LaserScan\';
fileBase = 'TheoGridData';
fileBase = [baseDir testDir fileBase];
InputFile = [fileBase '.mat'];
whos('-file', InputFile);
load(InputFile);
modelData = gridData;

%do the comparisons
testDir = 'Comparisons\';
techPlotData.vars = '"X(mm)" "Y(mm)" "diff Z(mm)" "diff U(mm)" "diff V(mm)" "diff W(mm)" "Count"';

if fSys1Laser
  %sys1 to laser
  compName = 'sys1_laser';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys1Data,laserData);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end

if fSys2Laser
  %sys2 to laser
  compName = 'sys2_laser';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys2Data,laserData);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end
  
if fSys1Sys2
  %sys1 to sys2
  compName = 'sys1_sys2';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys1Data,sys2Data);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end

if fSys1Sys2Tpc
  %sys1 to sys2Tpc
  compName = 'sys1_sys2Tpc';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys1Data,sys2TpcData);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end  


if fSys1_1_Sys1_11
  %sys1_1 to sys1_11
  compName = 'sys1_1_sys1_11';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys1_1_Data,sys1_11_Data);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end

if fSys1_1_Sys1_11b
  %sys1_1 to sys1_11b  Get back to this one tomorrow
  techPlotData.vars = '"X(mm)" "Y(mm)" "diff Z(mm)" "U-Umean(mm)" "V-Vmean(mm)" "W-Wmean(mm)" "Count"';
  compName = 'sys1_11disp';
  disp(compName)
  fileBase = [baseDir testDir compName];
  aveU=0;
  aveV=0;
  aveW=0;
  nCount = 0;
  for i=1:size(sys1_11b_Data,1)
    for j=1:size(sys1_11b_Data,2)
      if sys1_11b_Data(i,j,7)>0
        nCount = nCount+1;
        aveU=aveU+sys1_11b_Data(i,j,4);
        aveV=aveV+sys1_11b_Data(i,j,5);
        aveW=aveW+sys1_11b_Data(i,j,6);
      end
    end
  end
  aveU=aveU/nCount;
  aveV=aveV/nCount;
  aveW=aveW/nCount;
  
  sys1_11b_Data(:,:,4)=sys1_11b_Data(:,:,4)-aveU;
  sys1_11b_Data(:,:,5)=sys1_11b_Data(:,:,5)-aveV;
  sys1_11b_Data(:,:,6)=sys1_11b_Data(:,:,6)-aveW;
  data1 = sys1_1_Data;
  data1(:,:,4:6)=0;
  compData = CompareGridData(data1,sys1_11b_Data);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
  techPlotData.vars = '"X(mm)" "Y(mm)" "diff Z(mm)" "diff U(mm)" "diff V(mm)" "diff W(mm)" "Count"';

end


if fSys1Mod
  %sys1 to model
  compName = 'sys1_model';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys1Data,modelData);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end

if fSys2Mod
  %sys2 to model
  compName = 'sys2_model';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(sys2Data,modelData);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end

if fLaserMod
  %laser to model
  compName = 'laser_model';
  disp(compName)
  fileBase = [baseDir testDir compName];
  compData = CompareGridData(laserData,modelData);
  fileName = [fileBase '.mat'];
  save(fileName,'compData');
  fileName = [fileBase '.dat'];
  techPlotData.file = fileName;
  techPlotData.title = ['"' compName ' Comparison Data"'];
  techPlotData.zoneTitle = ['"' compName ' Comparison Data"'];
  WriteTechPlot(techPlotData, compData);
end

