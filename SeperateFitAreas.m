function [areas,areaPts] = SeperateFitAreas(fitData, wldData, fitBoundries)
%seperated data into areas for registration. The corners do not have to be
%recangular
%fitData - data point locations in boundry coordiantes (img or wld)
%wldData - world data points to seperate 
%fitBoundries - area number and four corners of each boundry area
%areas - array of wldData split into seperate areas
%areaPta - number of points in each area

  %array to hold area numbers
  areaNum = zeros(size(wldData,1),1);
  %use inpolygon to mark which areas each point belongs to
  xq=fitData(:,1);
  yq=fitData(:,2);
  %setup inArea flags
  inArea = false(size(wldData,1),size(fitBoundries,1));
  for iCorn = 1:size(fitBoundries,1)
    %set the boundary for the area
    xv=fitBoundries(iCorn,2:2:8);
    yv=fitBoundries(iCorn,3:2:9);
    inArea(:,iCorn)=inpolygon(xq,yq,xv,yv);
  end
  %mark the points with the appropriate area number
  for iCorn = 1:size(fitBoundries,1)
    areaNum(inArea(:,iCorn))=fitBoundries(iCorn,1);
  end

  %initialize the area arrays
  areas=repmat(-1,[size(wldData,1) 3 1]);
  %initialize the array sizes
  areaPts = [0,0,0,0,0,0,0,0];
  %seperate the data into the designated areas
  %areas defined by the image locations
  for point=1:size(wldData,1)
    if areaNum(point)>0
      areaPts(areaNum(point))=areaPts(areaNum(point))+1;
      areas(areaPts(areaNum(point)),:,areaNum(point))=wldData(point,:);    
    end
  end

end

