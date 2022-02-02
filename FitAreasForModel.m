%This program does the initial alignment of the laser data to the desired
%coordinate system. It aligns the area 1 perpendicular to the Z axis and at
%location z=0. Then it aligns the Y axes to surface 4 on the triangle in the 
%y direction and sets the positition of the surface in the x direction. It
%then sets the Y location relative to surface 6. 
%After this initial registration the program fits planes or cylinders to
%the rest of the areas to provide the coeficients of those areas for the
%model.

%%Set global options for the analysis
fminoptions = optimset('Display','notify','PlotFcns',@optimplotfval, 'Tolx', 1e-5, 'TolFun', 1e-5);

%get the parameters that describe the surface
deadZone = 0.3;
fitType = 11;
[theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(fitType, deadZone);         
        
%%Read the Laser data file and fill the seperate area arrays
initData=csvread('data\3DPlate_LaserScanData_mm.csv');

%seperate data into registration areas
[areas, areaPts]=SeperateFitAreas(initData,initData,fitBoundries);

%the 50-x changes the laser coordinates into something closer 
%to the dic coordinates
areas(:,1,:)=50-areas(:,1,:);
areas(:,2,:)=50-areas(:,2,:);
initData(:,1)=50-initData(:,1);
initData(:,2)=50-initData(:,2);

%register and return the optimized transform values  
optVals = RegisterPlate(areas,areaPts, areaCoef, -1);

%%apply the transformation to the full data set data and save
%the added values move the origin to so the edge of area 4 and the 
%edge of area 6 are at 28.575 in x and y at 50mm
rotArrReg = RotArray(optVals(7), optVals(8), optVals(9));
transArrReg = [optVals(10) optVals(11) optVals(12)];

%determine the coefficients for each of the planer areas
planeFitCoef = zeros(6,3);
for fitPlaneArea = 1:6
  fitArea = areas(1:areaPts(fitPlaneArea),:,fitPlaneArea);
  fitArea = fitArea*rotArrReg+transArrReg;
  %Best fit plane
  a=ones(areaPts(fitPlaneArea), 3);
  %Do a linear fit to a generic plane
  a(:,1)=fitArea(:,1);
  a(:,2)=fitArea(:,2);
  rh=fitArea(:,3);
  aTa=a.'*a;
  aTrh=a.'*rh;
  coef=aTa\aTrh;
  planeFitCoef(fitPlaneArea,:)=coef;
  disp(fitPlaneArea);
  disp(planeFitCoef(fitPlaneArea));
end

%determine the values for the cyllindrical area 7
area7 = areas(1:areaPts(7),:,7);
area7=area7*rotArrReg+transArrReg;
%run with a fixed radius
vals=[42.07,0,42.07,0];
ObjFitCylYFixed = @(vals)FitCylYFixed(vals,area7);
[regVals, fval, exitflag, output] = fminsearch(ObjFitCylYFixed,vals,fminoptions);
disp('area 7 fixed rad')
disp(regVals);
disp(fval);
%run with a variable radius
vals=[regVals 6.35];
ObjFitCylY = @(vals)FitCylY(vals,area7);
[regVals, fval, exitflag, output] = fminsearch(ObjFitCylY,vals,fminoptions);
disp('area 7 float rad')
disp(regVals);
disp(fval);

%determine the values for the cyllindrical area 8
area8 = areas(1:areaPts(8),:,8);
area8=area8*rotArrReg+transArrReg;
%run with a fixed radius
vals=[42.07,0,42.07,0];
ObjFitCylXFixed = @(vals)FitCylXFixed(vals,area8);
[regVals, fval, exitflag, output] = fminsearch(ObjFitCylXFixed,vals,fminoptions);
disp('area 8 fixed rad')
disp(regVals);
disp(fval);
%run with a variable radius
vals=[regVals 6.35];
ObjFitCylX = @(vals)FitCylX(vals,area8);
[regVals, fval, exitflag, output] = fminsearch(ObjFitCylX,vals,fminoptions);
disp('area 8 float rad')
disp(regVals);
disp(fval);

function CylErr = FitCylYFixed(vals,areaPnts)
  %parameters for cylinders mostly aligned with the y axis fixed rad
  CylErr = 0;
  for pntNum = 1: size(areaPnts)
    x0=areaPnts(pntNum,:);
    x1=[vals(1) 0 vals(2)];
    x2=[vals(3) 100 vals(4)];
    d=norm(cross(x0-x1,x0-x2))/norm(x2-x1);
    CylErr = CylErr + (6.35-d)^2;
  end
end
function CylErr = FitCylY(vals,areaPnts)
  %parameters for cylinders mostly aligned with the y axis variable rad
  CylErr = 0;
  for pntNum = 1: size(areaPnts)
    x0=areaPnts(pntNum,:);
    x1=[vals(1) 0 vals(2)];
    x2=[vals(3) 100 vals(4)];
    d=norm(cross(x0-x1,x0-x2))/norm(x2-x1);
    CylErr = CylErr + (vals(5)-d)^2;
  end
end

function CylErr = FitCylXFixed(vals,areaPnts)
  %parameters for cylinders mostly aligned with the y axis fixed rad
  CylErr = 0;
  for pntNum = 1: size(areaPnts)
    x0=areaPnts(pntNum,:);
    x1=[0 vals(1) vals(2)];
    x2=[100 vals(3) vals(4)];
    d=norm(cross(x0-x1,x0-x2))/norm(x2-x1);
    CylErr = CylErr + (6.35-d)^2;
  end
end

function CylErr = FitCylX(vals,areaPnts)
  %parameters for cylinders mostly aligned with the y axis variable rad
  CylErr = 0;
  for pntNum = 1: size(areaPnts)
    x0=areaPnts(pntNum,:);
    x1=[0 vals(1) vals(2)];
    x2=[100 vals(3) vals(4)];
    d=norm(cross(x0-x1,x0-x2))/norm(x2-x1);
    CylErr = CylErr + (vals(5)-d)^2;
  end
end