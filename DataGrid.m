function gridData = DataGrid(locPts, dataPts, gridParms, minCounts)
  %This function creates a uniform set of data points on the described grid
  %minCounts is the minimum number of points in the four squares
  %surrounding a node for that node to be included
  %Uses scatteredInterpolant to get the nodal values 
  %Returns a xy grid of (x,y,z,npoints) npoints can be used to identify 
  %valid data points 
  
  gridStart = gridParms(1);
  gridEnd = gridParms(2);
  gridStep = gridParms(3);
  minX = gridParms(4);
  maxX = gridParms(5);
  minY = gridParms(6);
  maxY = gridParms(7);
  
  %Setup standard grid of points
  gridSize = ceil((gridEnd-gridStart)/gridStep+1);
  gridData(1:gridSize,1:gridSize,7)=0;
  qPoints(1:gridSize,1:gridSize,8)=0;
  
  %fill in the intial xy locations and index
  for m=1:gridSize
    for n=1:gridSize
      %Save the locations and index
      qPoints(m,n,1)=(m-1)*gridStep+gridStart;
      qPoints(m,n,2)=(n-1)*gridStep+gridStart;
      qPoints(m,n,3)=m;
      qPoints(m,n,4)=n;
    end
  end
  gridData(:,:,1:2)=qPoints(:,:,1:2);

  %find which grid locations have neighboring data
  %mark the the surrounding points 
  for iPoint = 1:size(dataPts,1)
    %calc the corresponding index
    idxI = floor((locPts(iPoint,1)-gridStart)/gridStep+1);
    idxJ = floor((locPts(iPoint,2)-gridStart)/gridStep+1);

    if (idxI>0)&&(idxI<gridSize)&&(idxJ>0)&&(idxJ<gridSize)
      %increment the surrounding nodes
      qPoints(idxI,idxJ,5)=1;
      qPoints(idxI+1,idxJ,6)=1;
      qPoints(idxI,idxJ+1,7)=1;
      qPoints(idxI+1,idxJ+1,8)=1;
    end
  end
  
  %reshape qPoints
  qPoints=reshape(qPoints,[],8);
  qPoints(:,5)=qPoints(:,5)+qPoints(:,6)+qPoints(:,7)+qPoints(:,8);
  
  %remove any points with less than the required counts
  qPoints(qPoints(:,5)<minCounts,:)=[];
  %remove points outside of the acceptable area
  qPoints(qPoints(:,1)<minX,:)=[];
  qPoints(qPoints(:,1)>maxX,:)=[];
  qPoints(qPoints(:,2)<minY,:)=[];
  qPoints(qPoints(:,2)>maxY,:)=[];

  %setup the input for the interpolation
  x=locPts(:,1);
  y=locPts(:,2);
  z=locPts(:,3);
  v1=dataPts(:,1);
  v2=dataPts(:,2);
  v3=dataPts(:,3);
  
  %break out qPoints
  xq=qPoints(:,1);
  yq=qPoints(:,2);
  idxI=qPoints(:,3);
  idxJ=qPoints(:,4);
  nPnts=qPoints(:,5);
  
  %use scatteredInterpolant with linear interpolaton
  FInt=scatteredInterpolant(x,y,z,'linear');
  zq=FInt(xq,yq);
  FInt=scatteredInterpolant(x,y,v1,'linear');
  v1q=FInt(xq,yq);
  FInt=scatteredInterpolant(x,y,v2,'linear');
  v2q=FInt(xq,yq);
  FInt=scatteredInterpolant(x,y,v3,'linear');
  v3q=FInt(xq,yq);

  %save the data value and set the flag
  for m=1:size(zq,1)
    if idxI(m)>0 && idxJ(m)>0      
      gridData(idxI(m),idxJ(m),3)=zq(m);
      gridData(idxI(m),idxJ(m),4)=v1q(m);
      gridData(idxI(m),idxJ(m),5)=v2q(m);    
      gridData(idxI(m),idxJ(m),6)=v3q(m);
      gridData(idxI(m),idxJ(m),7)=nPnts(m);
    else
      disp(idxI(m));
      disp(idxJ(m));
      disp('index out of bounds')
    end
    
  end

end

