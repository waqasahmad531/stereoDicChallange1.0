function [auxZoneNames,auxZoneVals] = fillAuxZoneData(allVals, appStep, sysNum, groupNum, dataSetNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  auxZoneNames(1) = "aveU";
  auxZoneNames(2) = "minU";
  auxZoneNames(3) = "maxU";
  auxZoneNames(4) = "stdU";
  auxZoneNames(5) = "aveV";
  auxZoneNames(6) = "minV";
  auxZoneNames(7) = "maxV";
  auxZoneNames(8) = "stdV";
  auxZoneNames(9) = "aveW";
  auxZoneNames(10) = "minW";
  auxZoneNames(11) = "maxW";
  auxZoneNames(12) = "stdW";

  auxZoneNames(13) = "appliedStep";
  auxZoneNames(14) = "groupNum";
  auxZoneNames(15) = "systemNum";
  auxZoneNames(16) = "dataSetNum";

  auxZoneVals(13) = appStep;
  for idx = 1:12
    auxZoneVals(idx) = num2str(allVals(idx+12),"%.4f");
  end
  auxZoneVals(14) = groupNum;
  auxZoneVals(15) = num2str(sysNum,"%u");
  auxZoneVals(16) = num2str(dataSetNum,"%u");
end

