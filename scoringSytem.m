function [finalMask,totalAoi] = scoringSytem(ZZ,skipTriEdge)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin == 1
    skipTriEdge = false;
end
Z = ZZ;
Z(Z == 0) = NaN;
F = fillmissing(Z,'linear',2,'EndValues','nearest');
F = fillmissing(F,'linear',1,'EndValues','nearest');
% surf(X,Y,F,'EdgeColor','none')
% F(isnan(F)) = 0;
%%
%imagesc(F)

edgesOfInterest = edge(F,'canny',[0.01,0.14]);

%%
firstTri = F(63:287,333:450);
[~,colInd] = max(firstTri,[],2,'omitnan');
maniVec = [colInd,(1:length(colInd))'];
maniVec(colInd~=median(colInd),1) = median(colInd);
%temp =
logiInd = sub2ind(size(edgesOfInterest),63+maniVec(:,2),333+maniVec(:,1));
logiInd(colInd<median(colInd)-1) = NaN;
validPoints = logiInd(~isnan(logiInd));
%validPoints(validPoints<median(colInd)-1) = median(validPoints);
%fillRegion = false(size(firstTri));
if ~skipTriEdge
    edgesOfInterest(validPoints) = true;
end


secondTri = F(330:430,300:575);
[~,colInd2] = max(secondTri,[],1,'omitnan');
maniVec = [colInd2;(1:length(colInd2))]';

maniVec(colInd2<=median(colInd2)-5,:) = NaN;
maniVec = maniVec(~isnan(maniVec(:,1)),:);
maniVec(maniVec(:,1)~=median(maniVec(:,1)),1) = median(maniVec(:,1));
logiInd2 = sub2ind(size(edgesOfInterest),330+maniVec(:,1),300+maniVec(:,2));
%logiInd2(colInd2<median(maniVec(:,1))-1) = NaN;
validPoints = logiInd2;%(~isnan(logiInd));
%validPoints(validPoints<median(colInd2)) = median(validPoints);

%fillRegion = false(size(firstTri));
if ~skipTriEdge 
    edgesOfInterest(validPoints) = true;
end
%edgesOfInterest(38:320,333:450) = fillRegion;

zz = ZZ;
zz(zz==0) = 256;
secondMask = edge(abs(zz),'canny',[0.6 0.9]);
secondMask(250:300,350:450) = false;
finalMask = edgesOfInterest | secondMask;
totalAoi = secondMask;
totalAoi(52:549,52:549) = true;
end