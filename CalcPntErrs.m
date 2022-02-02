function area = CalcPntErrs(areaCoef, areaPoints, corners)
  %calculates the difference between the surface model and the data for
  %unstructured data
  
  %use inpolygon to mark which areas each point belongs to
  area = areaPoints;
  area(:,7)=-1;
  xq=area(:,1);
  yq=area(:,2);
  %setup inArea flags
  inArea = false(size(areaPoints,1),size(corners,1));
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
    area(inArea(:,iCorn),7)=corners(iCorn,1);
  end
  
  %calculate the errors for each point
  for point=1:size(area,1)
    pnt = area(point,:);
    areaNum = area(point,7);
    switch areaNum
      case {1,2,3,4,5,6}
        %plane area
        coef=areaCoef(areaNum,:);
        area(point,4) = PlaneDist(pnt,coef);
        area(point,5) = area(point,3)- PlaneZ(pnt,coef);
        area(point,6) = 0;  %use for comparision to laser data
      case {7,8}
        %cylinder area
        coef=areaCoef(areaNum,:);
        area(point,4) = CylDist3D(pnt,coef);
        area(point,5) = area(point,3)-CylZ3D(pnt,coef);
        area(point,6) = 0;  %use for comparision to laser data
      case {9}
        %dead zone point
        area(point,4) = 0;
        area(point,5) = 0;
        area(point,6) = 0;  
      otherwise
        %should not be able to get in here
        area(point,4) = 0;
        area(point,5) = 0;
        area(point,6) = 0;  
        area(point,7) = 10;
    end
  end
  
end

