function dist = CylDist3D(pnt, coef)
  %Calculates the radial distance (signed) from the point to the cylinder
  %uses the 3D cylinder description (center line and radius)
  x1=coef(1,1:3);
  x2=coef(1,4:6);
  con=coef(1,7);
  pnt=pnt(1,1:3);
  rd=norm(cross(pnt-x1,pnt-x2))/norm(x2-x1);
  dist=rd-con;
end