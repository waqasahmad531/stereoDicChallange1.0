function Z = PlaneZ(pnt, coef)
  %Calculates the theoretical value of z for the point 
  x=pnt(1,1);
  y=pnt(1,2);
  xCoef=coef(1,1);
  yCoef=coef(1,2);
  zCoef=coef(1,3);
  con=coef(1,4);
  %[x; y; z]=pnt;
  %[xCoef; yCoef; zCoef; con]=coef(1,1:4);
  Z=-(x*xCoef+y*yCoef+con)/zCoef;
end