
close all
%do you need to do the registration or just read the file
fDoRegistration = false;
fSaveData = true;
fExitOnEnd = false;

%setup the grid parameters
[gridParms,minCounts] = GetGridParms;

%select the groups to work on
groups = [210 211 212 213 214 220 221 222 223 224];
%groups = [210];
for iGroupNum = 1:size(groups,2)
  groupNum = groups(iGroupNum);
  %Get the filenames for the test
  [fileNames, testDir, sysNum, baseDir]=DicDataFileNames(groupNum);
  %setup the filenames for the analysis
  testName = strrep(testDir,'\','_');
  testDir = strcat(testDir, '\');
  
  %get the parameters that describe the surface
  deadZone = 0.3;
  [theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(sysNum, deadZone);
  
  %Make regular grid data from all the files
  for fileNum = 1:size(fileNames,1)
    fileBase = strcat(fileNames(fileNum));
    DICFileBase = strcat(baseDir, testDir, fileBase);
    DICInputFile = strcat(DICFileBase, '.mat');
    zoneName = strcat(fileBase, ' ');
    
    %Read the data and then seperate into the sepaerate areas
    whos('-file', DICInputFile);
    load(DICInputFile);
    A_1 = DicData;

    %strip out any nan entries
    disp(strcat('-rows before StripNan', num2str(size(A_1,1))));
    A_1 = rmmissing(A_1);
    disp(strcat('-rows aafter StripNan', num2str(size(A_1,1))));
        
    %fill the world and image data arrays
    imgData = A_1(:,1:2);
    profData = A_1(:,3:5);
    dispData = A_1(:,6:8);
    if floor(groupNum/100)==2
      profData = profData - dispData;
      disp('subtracting displacements');
    end
    
    %if it is the first file either do the registration or get the parms
    if fileNum == 1
        RegParmsFile = strcat(DICFileBase, '_RegParms.dat');        
        if fDoRegistration
          %seperate the data into the registration areas
          [areas, areaPnts]=SeperateFitAreas(imgData, profData, fitBoundries);
          disp(areaPnts)
          %register and return the optimized transform values  
          optVals = RegisterPlate(areas, areaPnts, areaCoef, 3);
          %save the parameters
          csvwrite(RegParmsFile, optVals);
        else
          assert(isfile(RegParmsFile),'Parameter file not found');
          %read the saved parameters
          optVals = csvread(RegParmsFile);
        end
    end
    
    %%apply the transformation to the full data set
    rotArrReg = RotArray(optVals(1), optVals(2), optVals(3));
    transArrReg = [optVals(4) optVals(5) optVals(6)];
    regProfData = profData*rotArrReg+transArrReg;
    regDispData = dispData*rotArrReg;

    if fSaveData
      %Save the registered data for the profile
      regMatFile = strcat(DICFileBase, '_Reg.mat');
      regGridDatFile = strcat(DICFileBase, '_RegGrid.dat');
      regGridMatFile = strcat(DICFileBase, '_RegGrid.mat');

      %Save the registered data
      disp(strcat('Writing RegMatFile => ',regMatFile));
      regData = [imgData regProfData regDispData];
      %regData = CalcPntErrs(areaCoef, regData, theoCorners);
      save(regMatFile,'regData');
      
      %Save a grid of the data
      disp('Creating grid data ');
      regGridData=DataGrid(regProfData, regDispData, gridParms, minCounts);
      disp(strcat('Writing RegGridFile => ',regGridMatFile));      
      save(regGridMatFile,'regGridData');
      
    end
  end
end
if fExitOnEnd
  exit;
end
