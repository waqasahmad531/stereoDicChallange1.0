%Script to register the Laser data to a primitive model of the surface

%perform the registration? if false will skip registration
%process and use saved result to save time
fDoReg = false; 
%gridStart gridEnd gridStep XYMin XYMax minCounts
[gridParms,minCounts] = GetGridParms;

%select the files to save to reduce execution time
fSaveRegParms = false;
fSaveInit = false;
fSaveIGuess = false;
fSaveReg = false;
fSaveRegGrid = true;
fSaveTheo = false;
fSaveTheoGrid = false;
fSaveAreas = false;

%filenames 
baseDir = 'C:\Users\jhelm\Documents\Sabbatical_Work\DIC Challenge Registration\DIC Data\';
testDir = 'LaserScan\';
SaveAreaFileBase = [baseDir testDir 'LaserScanArea_'];
SaveRegFile= [baseDir testDir 'LaserScanRegData.dat'];
SaveRegGridFile= [baseDir testDir 'LaserScanRegGridData.dat'];
SaveRegGridMatFile= [baseDir testDir 'LaserScanRegGridData.mat'];
SaveInitFile= [baseDir testDir 'LaserScanInitialData.dat'];
SaveTheoDataFile = [baseDir testDir 'LaserScanTheoData.dat'];
SaveTheoGridFile = [baseDir testDir 'TheoGridData.dat'];
SaveTheoGridMatFile = [baseDir testDir 'TheoGridData.mat'];
SaveIGuessFile= [baseDir testDir 'LaserScanInitialGuessData.dat'];
SaveRegParmsFile= [baseDir testDir 'LaserScanRegParms.dat'];

%get the parameters that describe the surface
deadZone = 0.3;
fitType = 11;
[theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(fitType, deadZone);   

%Read the laser scan data file and fill the seperate area arrays
inFile = [baseDir testDir '3DPlate_LaserScanData_mm.csv'];
initData = csvread(inFile);

%seperate data into registration areas
[areas, areaPts]=SeperateFitAreas(initData,initData,fitBoundries);

%the 50-x changes the laser coordinates into something closer 
%to the dic coordinates
areas(:,1,:)=50-areas(:,1,:);
areas(:,2,:)=50-areas(:,2,:);
initData(:,1)=50-initData(:,1);
initData(:,2)=50-initData(:,2);

if fDoReg
  %register the data to the primitive surface and return the optimized transform values  
  optVals = RegisterPlate(areas,areaPts, areaCoef,3);
  %Save the registration parameters
  csvwrite(SaveRegParmsFile,optVals);
else
  %This is a previous result if you want to skip the time to do the registration
  optVals=csvread(SaveRegParmsFile);
end

%%apply the transformation to the full data set data and save files
rotArrReg = RotArray(optVals(1), optVals(2), optVals(3));
transArrReg = [optVals(4) optVals(5) optVals(6)];

%Fill and save the output arrays
if fSaveInit
  %save the laser points with err no transformation
  disp('SaveInitFile');
  inputData = [initData zeros(size(initData,1),4)];
  inputData = CalcPntErrs(areaCoef, inputData, theoCorners);  
  csvwrite(SaveInitFile,inputData);
end

if fSaveIGuess
  %save the laser points with err after initial guess transformation
  disp('SaveIGuessFile');
  rotArrInit = RotArray(optVals(7), optVals(8), optVals(9));
  transArrInit = [optVals(10) optVals(11) optVals(12)];
  iGuessData = initData*rotArrInit+transArrInit;
  iGuessData = [iGuessData zeros(size(iGuessData,1),4)];
  iGuessData = CalcPntErrs(areaCoef, iGuessData, theoCorners);  
  csvwrite(SaveIGuessFile,iGuessData);
end

if fSaveReg
  %save the laser points with err after registration
  disp('SaveRegFile');
  regData = initData*rotArrReg+transArrReg;
  regData = [regData zeros(size(regData,1),4)];
  regData = CalcPntErrs(areaCoef, regData, theoCorners);  
  csvwrite(SaveRegFile,regData);
end

if fSaveRegGrid
  %save the standard grid of laser points after registration
  disp('SaveRegGridFile');
  regData = initData*rotArrReg+transArrReg;
  dispData = zeros(size(regData));
  gridData=DataGrid(regData, dispData, gridParms, minCounts);
  
  techPlotData.file = SaveRegGridFile;
  techPlotData.title = '"Reg Laser Data"';
  techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U(mm)" "V(mm)" "W(mm)" "Count"';
  techPlotData.zoneTitle = '"Reg Laser Data"';
  WriteTechPlot(techPlotData, gridData)
  
  save(SaveRegGridMatFile,'gridData');
end

if fSaveTheo
  %save the grid of theoretical points that relate to the laser data
  %this includes the deadzones
  disp('SaveTheoFile');
  %Create and save the theoretical surface
  %use xy from laser data
  theoData = initData*rotArrReg+transArrReg;
  theoData = [theoData zeros(size(theoData,1),4)];
  theoData(:,3)=0;
  theoData=CalcPntErrs(areaCoef, theoData, theoCorners);
  %z error is inverse of theo value
  theoData(:,3)=-theoData(:,5);
  theoData(:,4:6)=0;
  csvwrite(SaveTheoDataFile,theoData);
end

if fSaveTheoGrid
  %save the grid of theoretical points that relate to the laser data
  %no dead zones
  disp('SaveTheoGridFile');
  %get the parameters that describe the surface
  deadZone = 0.0;
  [theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(fitType, deadZone);
  %Create and save the theoretical surface
  theoData = initData*rotArrReg+transArrReg;
  theoData = DataGrid(theoData,theoData,gridParms, minCounts);
  %save the size to restore array
  dataSize1 = size(theoData,1);
  dataSize2 = size(theoData,2);
  theoData = reshape(theoData,[],size(theoData,3));
  %set the z, u, v, w values to 0
  theoData(:,3:7)=0;
  theoData=CalcPntErrs(areaCoef, theoData, theoCorners);
  %z error is inverse of theo value
  theoData(:,3)=-theoData(:,5);
  theoData(:,4:6)=0;
  %set the number of counts to a valid level
  theoData(:,7)=4;
  %turn off the parts of the grid outside the boundries
  theoData(theoData(:,1)<gridParms(4),7)=0;
  theoData(theoData(:,1)>gridParms(5),7)=0;
  theoData(theoData(:,2)<gridParms(6),7)=0;
  theoData(theoData(:,2)>gridParms(7),7)=0;
  
  %return to a grid
  gridData = reshape(theoData,dataSize1,dataSize2,size(theoData,2));  
  
  techPlotData.file = SaveTheoGridFile;
  techPlotData.title = '"Theoretical Data"';
  techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U(mm)" "V(mm)" "W(mm)" "Count"';
  techPlotData.zoneTitle = '"Theoretical Data"';
  WriteTechPlot(techPlotData, gridData)
  save(SaveTheoGridMatFile,'gridData');
  
end


%save data on each of the seperate areas
if fSaveAreas
  disp('SaveAreas');
  for areaNum=1:8
    disp(areaNum)
    %creat the area, trim to length and save
    area=areas(1:areaPts(areaNum),:,areaNum);
    areaFile = [SaveAreaFileBase '_area' num2str(areaNum) '.dat'];
    csvwrite(areaFile,area);
    %register the area and save
    area = area*rotArrReg+transArrReg;
    areaFile = [SaveAreaFileBase '_area' num2str(areaNum) 'Reg.dat'];
    csvwrite(areaFile,area);
    %create theoretical Z's for the area locations and save
    area = [area zeros(size(area,1),4)];
    area(:,3)=0;
    area=CalcPntErrs(areaCoef, area, theoCorners);
    area(:,3)=-area(:,5);
    area=area(:,1:3);
    areaFile = [SaveAreaFileBase '_area' num2str(areaNum) 'Reg.dat'];
    csvwrite(areaFile,area);
  end
end


    








