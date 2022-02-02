%creates mat and dat grid files with profile data from the 
%primitives model
close all

%get the parameters that describe the surface
deadZone = 0.0;
sysNum = 1;
[boundries,corners,fitBoundries,areaCoef] = FillFitParms(sysNum, deadZone);

%setup the grid parameters
[gridParms,minCounts] = GetGridParms;
gridStart = gridParms(1);
gridEnd = gridParms(2);
gridStep = gridParms(3);

%Setup standard grid of points
gridSize = ceil((gridEnd-gridStart)/gridStep+1);
gridData(1:gridSize*gridSize,7)=0;
modelGrid(1:gridSize,1:gridSize,7)=0;

%fill in the intial xy locations and index
idx = 0;
for m=1:gridSize
  for n=1:gridSize
    idx=idx+1;
    %Save the locations and index
    gridData(idx,1)=(m-1)*gridStep+gridStart;
    gridData(idx,2)=(n-1)*gridStep+gridStart;
  end
end
  
%use inpolygon to mark which areas each point belongs to
gridData(:,7)=-1;
xq=gridData(:,1);
yq=gridData(:,2);

%setup inArea flags
inArea = false(size(gridData,1),size(corners,1));
for iCorn = 1:size(corners)
  %set the boundary for the area
  xv=corners(iCorn,2:2:8);
  yv=corners(iCorn,3:2:9);
  inArea(:,iCorn)=inpolygon(xq,yq,xv,yv);
end
%mark the points with the appropriate area number
%going backward should maintain the heirarchy of the areas
%maintain the dead zone and make other areas overwrite #1
for iCorn = size(corners):-1:1
  gridData(inArea(:,iCorn),7)=corners(iCorn,1);
end
  
%calculate the locations for each point
idx = 0;
for m=1:gridSize
  for n=1:gridSize
    idx=idx+1;
    pnt = gridData(idx,:);
    areaNum = gridData(idx,7);
    modelGrid(m,n,1:2)=gridData(idx,1:2);
    modelGrid(m,n,7)=areaNum+10;
    switch areaNum
      case {1,2,3,4,5,6}
        %plane area
        coef=areaCoef(areaNum,:);
        modelGrid(m,n,3) = PlaneZ(pnt,coef);
      case {7,8}
        %cylinder area
        coef=areaCoef(areaNum,:);
        modelGrid(m,n,3) = CylZ3D(pnt,coef);
      case {9}
        %dead zone point
        modelGrid(m,n,3) = 0;
        modelGrid(m,n,7) = 0;
      otherwise
        %should not be able to get in here
        modelGrid(m,n,3) = 0;
        modelGrid(m,n,7) = -1;
    end
  end
end 

%Directory information
[fileNames, testDir, sysNum, baseDir]=DicDataFileNames(0);

%Save a grid of the data
disp('Saving model grid ');
regGridMatFile = strcat(baseDir,testDir, '/',fileNames(1),'_RegGrid.mat');
disp(strcat('Writing RegGridFile => ',regGridMatFile));      
save(regGridMatFile,'modelGrid');

%Save TechPlot formatted grid data
regGridDatFile = strcat(baseDir,testDir, '/',fileNames(1),'_RegGrid.dat');
disp(strcat('Writing Techplot RegGridFile => ',regGridDatFile));      
techPlotData.file = regGridDatFile;
techPlotData.title = strcat('"Model Registered Data"');
techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U(mm)" "V(mm)" "W(mm)" "Count"';
techPlotData.zoneTitle = char(strcat('"Model"'));
WriteTechPlot(techPlotData, modelGrid)
disp(strcat('End => Model Creation')); 