function Z = CylZ3D(pnt, coef)
  %Calculates the model Z on the cylinder for an x,y coordinate
  %requires the cylinder coefficients and the x,y points
  x1=coef(1,1:3);
  x2=coef(1,4:6);
  con=coef(1,7);
  pnt=[pnt(1,1:2) 0];
  %calculate the distance from the (x,y,0) location 
  rd=norm(cross(pnt-x1,pnt-x2))/norm(x2-x1);
  %is the location within the cylinder?
  if rd<con
    %which direction is the cylinder mostly aligned
    if (x2(2)-x1(2))>60
      %mostly y
      fact=(pnt(1,2)-x1(2))/(x2(2)-x1(2));
      xCen = x1(1)+(x2(1)-x1(1))*fact;
      zCen = x1(3)+(x2(3)-x1(3))*fact;
      yCen = pnt(1,2);
    else
      %mostly x
      fact=(pnt(1,1)-x1(1))/(x2(1)-x1(1));
      yCen = x1(2)+(x2(2)-x1(2))*fact;
      zCen = x1(3)+(x2(3)-x1(3))*fact;
      xCen = pnt(1,1);
    end
    %calculate the Z height at that point
    tBase = sqrt(rd^2-zCen^2);
    tHeigth = sqrt(con^2-tBase^2);
    Z=tHeigth+zCen;
  else
    %beyond the cylinder the theoretical distance is set to 0
    Z=pnt(1,3);
  end
end