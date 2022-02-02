function [numPoints,minDiffProf,maxDiffProf,stdDiffProf] = calcProfileNoise(profile1, profile2, profile3, profile4, profile5)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    maxDiffProf(1:3) = 0;
    minDiffProf(1:3) = 0;
    stdDiffProf(1:3) = 0;
%% calculate the profile noise (move to subroutine)

    disp('Calculating profile noise');
    p1 = profile1(:,1:2);
    p2 = profile2(:,1:2);
    p3 = profile3(:,1:2);
    p4 = profile4(:,1:2);
    p5 = profile5(:,1:2);
    idx1 = 1:size(profile1,1);
    idx1 = idx1.';
    disp('calculating delaunayn array2');
    T = delaunayn(p2);
    [idx2, dist2] = dsearchn(p2,T,p1);
    disp('calculating delaunayn array3');
    T = delaunayn(p3);
    [idx3, dist3] = dsearchn(p3,T,p1);
    disp('calculating delaunayn array4');
    T = delaunayn(p4);
    [idx4, dist4] = dsearchn(p4,T,p1);
    disp('calculating delaunayn array5');
    T = delaunayn(p5);
    [idx5, dist5] = dsearchn(p5,T,p1);
    
%% find common points (zero distance in all arrays)
    commPts = dist2+dist3+dist4+dist5;
    commPts = commPts<0.1;
    
    idx1r = idx1(commPts);
    idx2r = idx2(commPts);
    idx3r = idx3(commPts);
    idx4r = idx4(commPts);
    idx5r = idx5(commPts);
    numPoints = size(idx1r,1);

    aveProf = (profile1(idx1r,3:5) + profile2(idx2r,3:5) + profile3(idx3r,3:5) + profile4(idx4r,3:5) + profile5(idx5r,3:5))/5.0;
    diffProf1 = profile1(idx1r,3:5)-aveProf;
    diffProf2 = profile2(idx2r,3:5)-aveProf;
    diffProf3 = profile3(idx3r,3:5)-aveProf;
    diffProf4 = profile4(idx4r,3:5)-aveProf;
    diffProf5 = profile5(idx5r,3:5)-aveProf;
    

    
    for iStats = 1:3
      maxDiffProf(iStats) = max([max(diffProf1(:,iStats)) max(diffProf2(:,iStats)) max(diffProf3(:,iStats)) max(diffProf4(:,iStats)) max(diffProf5(:,iStats))]);
      minDiffProf(iStats) = min([min(diffProf1(:,iStats)) min(diffProf2(:,iStats)) min(diffProf3(:,iStats)) min(diffProf4(:,iStats)) min(diffProf5(:,iStats))]);
      stdDiffProf(iStats) = sqrt(sum(diffProf1(:,iStats).^2+diffProf2(:,iStats).^2+diffProf3(:,iStats).^2+diffProf4(:,iStats).^2+diffProf5(:,iStats).^2)/5.0/size(diffProf1,1));
    end
    disp('calculating deviations');

end

