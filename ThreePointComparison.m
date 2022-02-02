%Corresponding points for correction
% for now assume we are aligning system 2 to system 1
CorPnts=[1164 1409 1092.909 1395.507; ...
         1855 1403 1738.654 1382.73;...
         1306 312 1312.953 317.6764];
       
disp('reading data sys1');

%Registers DIC data to the surface model saves the registration data
baseDir = 'C:\Users\jhelm\Documents\Sabbatical_Work\DIC Challenge Registration\DIC Data\';
%Get the filenames for the test
[fileNames, testDir]=DicDataFileNames(1);
%setup the filenames for the analysis
testName = testDir;
testDir = [testDir '\'];
fileBase = [char(fileNames(1)) '_Stch'];
DICFileBase = [baseDir testDir fileBase];
RegImgFile = [DICFileBase 'RegProfwImg.mat'];

%%Set global options for the analysis
fminoptions = optimset('Display','notify','PlotFcns',@optimplotfval, 'Tolx', 1e-5, 'TolFun', 1e-5);
regImgData = 0;
%Read the data and then seperate into the sepaerate areas
whos('-file', RegImgFile);
load(RegImgFile);
sys1Data = regImgData;

disp('reading data sys2');
%Get the filenames for the test
[fileNames, testDir]=DicDataFileNames(2);
%setup the filenames for the analysis
testName = testDir;
testDir = [testDir '\'];
fileBase = [char(fileNames(1)) '_Stch'];
DICFileBase = [baseDir testDir fileBase];
RegImgFile = [DICFileBase 'RegProfwImg.mat'];

regImgData = 0;
%Read the data and then seperate into the sepaerate areas
whos('-file', RegImgFile);
load(RegImgFile);
sys2Data = regImgData;

tic
disp('calculating interpolants sys1')
%use scatteredInterpolant with linear interpolaton
FIntX=scatteredInterpolant(sys1Data(:,1:2),sys1Data(:,3),'linear');
FIntY=scatteredInterpolant(sys1Data(:,1:2),sys1Data(:,4),'linear');
FIntZ=scatteredInterpolant(sys1Data(:,1:2),sys1Data(:,5),'linear');
sys1WldXq=FIntX(CorPnts(:,1:2));
sys1WldYq=FIntY(CorPnts(:,1:2));
sys1WldZq=FIntZ(CorPnts(:,1:2));
toc

tic
disp('calculating interpolants sys2')
%use scatteredInterpolant with linear interpolaton
FIntX=scatteredInterpolant(sys2Data(:,1:2),sys2Data(:,3),'linear');
FIntY=scatteredInterpolant(sys2Data(:,1:2),sys2Data(:,4),'linear');
FIntZ=scatteredInterpolant(sys2Data(:,1:2),sys2Data(:,5),'linear');
sys2WldXq=FIntX(CorPnts(:,3:4));
sys2WldYq=FIntY(CorPnts(:,3:4));
sys2WldZq=FIntZ(CorPnts(:,3:4));
toc

disp('determining correction transformation')
sys1Pnts = [sys1WldXq sys1WldYq sys1WldZq];
sys2Pnts = [sys2WldXq sys2WldYq sys2WldZq];

%if we are going to use more than a few point this needs to be modified
D1=pdist(sys1Pnts);
D2=pdist(sys2Pnts);
disp('sys1')
disp(sys1Pnts)
disp(D1)
disp('sys2')
disp(sys2Pnts)
disp(D2)

%find the min and max difference in distances
D1 = D2-D1;
disp('min and max distance difference')
disp(min(D1))
disp(max(D1))

%determine the correcting transformation
vals=zeros(1,6);
ObjFitCylX = @(vals)FitCorrPnts(vals,sys1Pnts,sys2Pnts);
[retVals, fval, exitflag, output] = fminsearch(ObjFitCylX,vals,fminoptions);
disp('correction transformation')
disp(retVals)
retVals = [retVals fval];
tpcFile = [DICFileBase 'TpcParms.dat'];
csvwrite(tpcFile,retVals);

%least squares on the point seperation
function pntErr = FitCorrPnts(vals,sys1Pnts,sys2Pnts)
  %aligns the system 2 points to the system 1 points
  pntErr = 0;
  rotArr = RotArray(vals(1), vals(2), vals(3));
  transArr = [vals(4), vals(5), vals(6)];
  newPnts = sys2Pnts*rotArr+transArr;
  for pntNum = 1: size(newPnts)
    pntErr = pntErr+(newPnts(pntNum,1)-sys1Pnts(pntNum,1))^2;
    pntErr = pntErr+(newPnts(pntNum,2)-sys1Pnts(pntNum,2))^2;
    pntErr = pntErr+(newPnts(pntNum,3)-sys1Pnts(pntNum,3))^2;
  end
end