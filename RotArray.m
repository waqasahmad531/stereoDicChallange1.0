function R = RotArray(ang1, ang2, ang3)
%{
generates the rotation array for rotations about x axis then about the
rotated y and then the twice rotated z (Euler angles)
  ang1 - rot about x
  ang2 - rot about rotated y
  ang3 - rot about twice rotated z
%}
  s1 = sin(ang1);
  s2 = sin(ang2);
  s3 = sin(ang3);
  c1 = cos(ang1);
  c2 = cos(ang2);
  c3 = cos(ang3);
  
  Rx=[1 0 0;...
      0 c1 -s1;...
      0 s1 c1];
  Ry=[c2 0 s2;...
      0 1 0;...
      -s2 0 c2];
  Rz=[c3 -s3 0;...
      s3 c3 0;...
      0 0 1];  
  R=Rx*Ry*Rz;  
end