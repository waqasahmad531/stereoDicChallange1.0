function dist = PlaneDist(pnt, coef)
  %Calculates the perpendicular distance (signed) from the point to the plane 
  x=pnt(1,1);
  y=pnt(1,2);
  z=pnt(1,3);
  xCoef=coef(1,1);
  yCoef=coef(1,2);
  zCoef=coef(1,3);
  con=coef(1,4);
  %[x; y; z]=pnt;
  %[xCoef; yCoef; zCoef; con]=coef(1,1:4);
  dist=(x*xCoef+y*yCoef+z*zCoef+con)/sqrt(xCoef^2+yCoef^2+zCoef^2);
end