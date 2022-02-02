tic
%do you need to do the registration of just read the file
fDoRegistration = false;
fAnalizeProfile = true;
fApplyToDisp = false;
fApplyTpcCorr = true;

sysNum = 2;
%Registers DIC data to the surface model saves the registration data
baseDir = 'C:\Users\jhelm\Documents\Sabbatical_Work\DIC Challenge Registration\DIC Data\';
%Get the filenames for the test
[fileNames, testDir]=DicDataFileNames(sysNum);
%setup the filenames for the analysis
testName = testDir;
testDir = [testDir '\'];
fileBase = [char(fileNames(1)) '_Stch'];
DICFileBase = [baseDir testDir fileBase];
DICInputFile = [DICFileBase '.mat'];
RegParmsFile = [DICFileBase 'RegParms.dat'];

if fApplyTpcCorr
  tpcParmsFile = [DICFileBase 'TpcParms.dat'];
  tpcParms = csvread(tpcParmsFile);
  tpcLbl = 'Tpc';
else
  tpcParms = zeros(1,7);
  tpcLbl = '';
end

%setup the grid parameters
[gridParms,minCounts] = GetGridParms;

%get the parameters that describe the surface
deadZone = 0.3;
fitType = sysNum;
[theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(fitType, deadZone);

%Read the data and then seperate into the sepaerate areas
whos('-file', DICInputFile);
load(DICInputFile);
%fill the world and image data arrays
profData = A_1(:,3:5);
imgData = A_1(:,1:2);

if fDoRegistration
  %seperate the data into the registration areas
  [areas, areaPnts]=SeperateFitAreas(imgData, profData, fitBoundries);
  disp(areaPnts)
  %register and return the optimized transform values  
  optVals = RegisterPlate(areas, areaPnts, areaCoef, 3);
  %save the parameters
  csvwrite(RegParmsFile, optVals);
else
  %read the saved parameters
  optVals=csvread(RegParmsFile);
end
toc
tic
%%apply the transformation to the full data set
rotArrReg = RotArray(optVals(1), optVals(2), optVals(3));
transArrReg = [optVals(4) optVals(5) optVals(6)];
if fApplyTpcCorr
  tpcRotArr = RotArray(tpcParms(1), tpcParms(2), tpcParms(3));
  tpcTransArr = [tpcParms(4) tpcParms(5) tpcParms(6)];
  rotArrReg = rotArrReg * tpcRotArr;
  transArrReg = transArrReg * tpcRotArr + tpcTransArr;
end  
regProfData = profData*rotArrReg+transArrReg;
  
  
if fAnalizeProfile
  %Save the registered data for the profile
  RegFile = [DICFileBase tpcLbl 'RegProf.dat'];
  RegImgFile = [DICFileBase tpcLbl 'RegProfwImg.mat'];
  RegGridFile = [DICFileBase tpcLbl 'RegProfGrid.dat'];
  RegGridMatFile = [DICFileBase tpcLbl 'RegProfGrid.mat'];

  %Save the file with the image locations as well
  disp('SaveRegImgFile');
  regImgData = [imgData regProfData];
  save(RegImgFile,'regImgData');

  %Save the registered data and differences
  disp('SaveRegFile');
  regData = regProfData;
  regData = [regData zeros(size(regData,1),4)];
  regData = CalcPntErrs(areaCoef, regData, theoCorners);
  csvwrite(RegFile,regData);
  dispData = zeros(size(regData));

  %Save a grid of the data
  disp('SaveRegGridFile');
  gridData=DataGrid(regData,dispData, gridParms, minCounts);
  save(RegGridMatFile,'gridData');

  techPlotData.file = RegGridFile;
  techPlotData.title = ['"' testName ' Profile Data"'];
  techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U(mm)" "V(mm)" "W(mm)" "Count"';
  techPlotData.zoneTitle = ['"' testName tpcLbl ' Profile Data"'];
  WriteTechPlot(techPlotData, gridData)
  
end

if fApplyToDisp
  %Save the registered data for the each of the displacement files
  disp('writing displacement file')
  techPlotData.title = ['"' testName tpcLbl ' Profile Data"'];
  techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U(mm)" "V(mm)" "W(mm)" "Count"';
  
  for fileIdx = 1:size(fileNames,1)
    fileBase = [char(fileNames(fileIdx)) '_Stch'];
    disp(fileBase)
    drawnow;
    DICFileBase = [baseDir testDir fileBase];
    DICInputFile = [DICFileBase '.mat'];
    RegGridFile = [DICFileBase tpcLbl 'RegGrid.dat'];
    RegGridMatFile = [DICFileBase tpcLbl 'RegGrid.mat'];    
    
    techPlotData.file = RegGridFile;
    %Read the data 
    load(DICInputFile);
    %fill the displacement data arrays
    dispData = A_1(:,6:8);
    profData = A_1(:,3:5);
    %register the displacement data
    regDispData = dispData*rotArrReg;
    regProfData = profData*rotArrReg+transArrReg;
    gridData=DataGrid(regProfData,regDispData, gridParms, minCounts);
    save(RegGridMatFile,'gridData');
    techPlotData.zoneTitle = ['"' testName ' step' int2str(fileIdx) tpcLbl ' displacement data"'];
    WriteTechPlot(techPlotData, gridData);
  end
end
toc
%exit
