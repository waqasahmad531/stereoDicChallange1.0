%Uses the registered laser data to check the repeatability of the
%registration system. Takes the registered data and applies a random set of
%rotations and translations and feeds the results into the registration
%system to see if the same values are returned.

%select the files to save to reduce execution time
fExitAtEnd = true;

%get the parameters that describe the surface using the same areas for
%fitting as the laser scan data
deadZone = 0.3;
fitType = 12;
[theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(fitType, deadZone); 

%Set the number of passes and the display level
numPasses = 250;
regDispLvl = 3;
%set the range for the angles and the translations
angRange = 0.1;
transRange = 4.0;
noiseLvlBase = 0.01;

DataDir = 'C:\Users\jhelm\Documents\Sabbatical_Work\DIC Challenge Registration\DIC Data\Repeatability\';

%create the grid of points
gridEnd = 48;
gridStart = -48;
gridStep = 0.2;

%Setup standard grid of points
gridSize = ceil((gridEnd-gridStart)/gridStep+1);
gridData = zeros(gridSize, gridSize, 7);

%fill in the intial xy locations and index
for m=1:gridSize
  for n=1:gridSize
    %Save the locations and index
    gridData(m,n,1)=(m-1)*gridStep+gridStart;
    gridData(m,n,2)=(n-1)*gridStep+gridStart;
  end
end
gridData = reshape(gridData,[],7);
%Fill the model with Z data
modelData=CalcPntErrs(areaCoef, gridData, theoCorners);
modelData(:,3)=-modelData(:,5);
%trim to xyz
modelData = modelData(:,1:3);

%seperate data into registration areas
[areas, areaPts]=SeperateFitAreas(modelData,modelData,fitBoundries);

%initialize the registration values array
regValues = zeros(numPasses, 14);

for pass = 1:numPasses
  tic
  if pass == 1
    %run the first pass with no applied rotation/translatio to capture
    %resampling effects
    appVals=[0 0 0 0 0 0];
    noiseLvl=0;
  else
    %fill the rotation translation values
    appVals(1)=2*angRange*rand-angRange;
    appVals(2)=2*angRange*rand-angRange;
    appVals(3)=2*angRange*rand-angRange;
    appVals(4)=2*transRange*rand-transRange;
    appVals(5)=2*transRange*rand-transRange;
    appVals(6)=2*transRange*rand-transRange;
    noiseLvl=noiseLvlBase;
  end
  
  %create transformation arrays
  appRot = RotArray(appVals(1),appVals(2),appVals(3));
  appTrans = [appVals(4),appVals(5),appVals(6)];
  
  %apply the inverse transformation to the areas
  modAreas = areas;
  for areaNum = 1:8
    pts = modAreas(:,:,areaNum);
    noise = rand(size(pts,1),1)*noiseLvl*2-noiseLvl;
    pts(:,3)=pts(:,3)+noise;
    pts = (pts-appTrans)/appRot;
    modAreas(:,:,areaNum) = pts;
  end

  %register and return the optimized transform values  
  optVals = RegisterPlate(modAreas,areaPts, areaCoef, regDispLvl);

  diffVals = optVals(1:6)-appVals(1:6);  
  disp(pass);
  disp(diffVals);
  regValues(pass,:) = [pass appVals(1:6) diffVals(1:6) optVals(13)]; 
  drawnow
  toc

  %Write file every pass just in case these are small and don't 
  %take time
  if noiseLvlBase == 0 
    fileName = [DataDir 'ModelData_MultiRegRand.dat'];
    csvwrite(fileName,regValues);
  else
    fileName = [DataDir 'ModelData_MultiRegRandNoise.dat'];
    csvwrite(fileName,regValues);
  end
end

%free up a license if the program is done
if fExitAtEnd
  exit
end


    








