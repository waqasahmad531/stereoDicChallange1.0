%get the parameters that describe the surface
%Initially the area boundries were rectangular. This takes the rectangular 
%XY Min Max and changes them into corner points (no longer used)
deadZone = 0.3;
fitType = 3;
[theoBoundries,theoCorners,fB,areaCoef] = FillFitParms(fitType, deadZone);   
m=1:14
newCorners(m,:) = [fB(m,1) fB(m,2) fB(m,4) fB(m,2) fB(m,5) fB(m,3) fB(m,5) fB(m,3) fB(m,4)];
disp(newCorners(m,:))
