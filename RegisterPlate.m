function regVals = RegisterPlate(areas, areaPts, areaCoef, dispLvl)

  %Registers a set of data to the plate model
  %Set the options for fminsearch
  dispOut=true;
  calcFull=true;
  funTol = 1e-4;
  varTol = 1e-4;
  switch dispLvl
    case -1
      %does not run the full optimization, no fit output, no graph
      fminoptions = optimset('Tolx', varTol,'TolFun', funTol);
      calcFull = false;
    case 0
      %runs the full optimization, no fit output, no graph
      fminoptions = optimset('Tolx', varTol,'TolFun', funTol);
      dispOut=false;
    case 1
      %runs the full optimization, fit output, no graph
      fminoptions = optimset('Display','notify', 'Tolx', varTol, 'TolFun', funTol);
      dispOut=false;
    case 2
      %runs the full optimization, fit output, graph, other output
      fminoptions = optimset('Display','notify', 'Tolx', varTol, 'TolFun', funTol);
    case 3
      %runs the full optimization, fit output, graph, other output
      fminoptions = optimset('Display','notify','PlotFcns',@optimplotfval, 'Tolx', varTol, 'TolFun', funTol);
    otherwise
      %runs the full optimization, fit output for each iteration, graph, other output
      fminoptions = optimset('Display','iter','PlotFcns',@optimplotfval, 'Tolx', varTol, 'TolFun', funTol);
  end

  %Trim the arrays to length
  %only uses areas 1, 4 and 6
  area1=areas(1:areaPts(1),:,1);
  area4=areas(1:areaPts(4),:,4);
  area6=areas(1:areaPts(6),:,6);

  %%Generate the initial guess values for the optimization
  %Align the normal to the bottom plane of the plate  
  a=ones(areaPts(1), 3);
  %Do a linear fit to a generic plane
  a(:,1)=area1(:,1);
  a(:,2)=area1(:,2);
  rh=area1(:,3);
  aTa=a.'*a;
  aTrh=a.'*rh;
  coef=aTa\aTrh;
  coef(1) = -coef(1);
  coef(2) = -coef(2);
  coef(3) = -coef(3);

  %chose the sign of the denominator so cosG is
  %always be positive to keep the normal on the correct side
  denom=sqrt(coef(1)^2+coef(2)^2+1.0);
  %direction cosines
  cosA=coef(1)/denom;
  cosB=coef(2)/denom;
  cosG=1.0/denom;
  perpDist=-coef(3)/denom;

  %2nd rotation angle about y
  ang2 = asin(cosA);
  %inital rotation angle about x
  ang1 = atan2(-cosB, cosG);

  %fill the current rotation/translation arrays
  rotArrInit=RotArray(ang1, ang2, 0);
  transArrInit=[0 0 -perpDist];

  %Display the results
  if dispOut
    disp('initial angles  and offset');
    disp(ang1);
    disp(ang2);
    disp(-perpDist);
  end

  %Calculate the rotation angle about z and the x offset from surface #4
  %apply the current rotation/translation to area #4
  area4mod=area4*rotArrInit+transArrInit;
  %Use a 0,0 initial guess for rotation and translation
  vals=[0,0];
  %set up a function for the optimization
  ObjZRotFit = @(vals)ZRotFit(vals,4,areaCoef,area4mod);
  %optimize 
  [optVals, fval, exitflag, output] = fminsearch(ObjZRotFit,vals,fminoptions);
  %update the rotation and translation arrays
  ang3=optVals(1);
  rotArrInit=RotArray(ang1, ang2, ang3);
  transArrInit=transArrInit+[optVals(2) 0 0];
  if dispOut
    disp('rot angle about z and X offset');
    disp(ang3);
    disp(optVals(2));
  end

  %Calculate the y offset from surface #6
  %apply the current rotation/translation to area #6
  area6mod=area6*rotArrInit+transArrInit;
  %set the initial guess to 0
  vals=0;
  %set up a function for the optimization
  ObjYOffFit = @(vals)YOffFit(vals,6,areaCoef,area6mod);
  [optVals, fval, exitflag, output] = fminsearch(ObjYOffFit,vals,fminoptions);
  transArrInit=transArrInit+[0 optVals 0];
  if dispOut
    disp('Y offset');
    disp(optVals);
  end
  
  %%Do the optimization on all of the designated areas
  %Use the inital values from the previous optimizations 
  vals=[ang1 ang2 ang3 transArrInit(1,1) transArrInit(1,2) transArrInit(1,3)];
  if calcFull
    %do the full optimization
    ObjFullFit = @(vals)FullFit(vals,areaPts,areaCoef,areas);
    [regVals, fval, exitflag, output] = fminsearch(ObjFullFit,vals,fminoptions);
    if dispOut
      disp ('full optimization parameters');
      disp(regVals);
    end
  else
    %run the two inplane optimizations again to improve the initial guess
    %because we are not assuming perfect alignment of the triangles
    
    %Calculate the rotation angle about z and the x offset from surface #4
    %apply the current rotation/translation to area #4
    area4mod=area4*rotArrInit+transArrInit;
    %Use a 0,0 initial guess for rotation and translation
    vals=[0,0];
    %set up a function for the optimization
    ObjZRotFit = @(vals)ZRotFit(vals,4,areaCoef,area4mod);
    %optimize 
    [optVals, fval, exitflag, output] = fminsearch(ObjZRotFit,vals,fminoptions);
    %update the rotation and translation arrays
    ang3=ang3+optVals(1);
    rotArrInit=RotArray(ang1, ang2, ang3);
    transArrInit=transArrInit+[optVals(2) 0 0];
    if dispOut
      disp('rot angle about z and X offset second pass');
      disp(optVals(1));
      disp(optVals(2));
    end
    
    %Calculate the y offset from surface #6
    %apply the current rotation/translation to area #6
    area6mod=area6*rotArrInit+transArrInit;
    %set the initial guess to 0
    vals=0;
    %set up a function for the optimization
    ObjYOffFit = @(vals)YOffFit(vals,6,areaCoef,area6mod);
    [optVals, fval, exitflag, output] = fminsearch(ObjYOffFit,vals,fminoptions);
    transArrInit=transArrInit+[0 optVals 0];
    if dispOut
      disp('Y offset second pass');
      disp(optVals);
    end
    %update the complete set of values
    vals=[ang1 ang2 ang3 transArrInit(1,1) transArrInit(1,2) transArrInit(1,3)];
    regVals=[0 0 0 0 0 0];
    fval=0;
  end
  %save the registration and initial guess values
  regVals = [regVals vals fval];
  
end


function ZRotFitErr=ZRotFit(vals, areaNum, areaCoef, areaPoints)
  %Rotate the points about the twice rotated Z axis and translate
  %in the x direction
  rotArray = RotArray(0, 0, vals(1));
  transArray = [vals(2) 0 0];
  newPoints = areaPoints*rotArray+transArray;
  ZRotFitErr = AreaErr(areaNum, areaCoef, newPoints);
end

function YOffFitErr=YOffFit(vals, areaNum, areaCoef, areaPoints)
  %Translate the points along the Y axis
  transArray = [0 vals(1) 0];
  newPoints = areaPoints+transArray;
  YOffFitErr = AreaErr(areaNum, areaCoef,newPoints);
end  
  
function FullFitErr=FullFit(vals,areaPts,areaCoef,areas)
  %Rotate the points about the Z axis and translate
  rotArray = RotArray(vals(1), vals(2), vals(3));
  transArray = [vals(4) vals(5) vals(6)];
  FullFitErr=0;
  for areaNum=1:8
    trunPnts = areas(1:areaPts(areaNum),:,areaNum);
    newPnts = trunPnts*rotArray+transArray;
    FullFitErr = FullFitErr + AreaErr(areaNum, areaCoef, newPnts);
  end
end

function sumE=AreaErr(areaNum, areaCoef, areaPoints)
  %initialize the error
  sumE=0;
  if areaCoef(areaNum,7)==0
    %plane area
    coef=areaCoef(areaNum,:);
    for pntNum=1:size(areaPoints,1)
      pnt = areaPoints(pntNum,:);
      pointDist = PlaneDist(pnt,coef);
      sumE = sumE + pointDist^2;
    end
  else
    %cylinder area
    coef=areaCoef(areaNum,:);
    for pntNum=1:size(areaPoints,1)
      pnt = areaPoints(pntNum,:);
      pointDist = CylDist3D(pnt,coef);
      sumE = sumE + pointDist^2;
    end
  end
end
