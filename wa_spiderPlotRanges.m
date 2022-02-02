function data = wa_spiderPlotRanges(meanPerFrame,vend,steps)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    dispMinMean = zeros(4,2);
    dispMaxMean = zeros(4,2);
    dispMinStd = zeros(4,2);
    dispMaxStd = zeros(4,2);
    dispMaxMin = zeros(4,2);
    dispMinMin = zeros(4,2);
    dispMaxMax = zeros(4,2);
    dispMinMax = zeros(4,2);
for disp = 1:4
     radCount = 0;
   for iSys = 1:2%:size(sysgroups,1)
        for iDataset= 1:5
            for vn = 1:length(vend)

                    mpfvg = squeeze(meanPerFrame(vn,iSys,:)); %number of datasets
                    temp = mpfvg{iDataset}; %frames
                    meanData = squeeze(temp(:,1,:));
                    stdData = squeeze(temp(:,2,:));
                    minData = squeeze(temp(:,3,:));
                    maxData = squeeze(temp(:,4,:));
                    meanDif = steps-meanData;
%                     sd_m(vn,grp,:) = 1000*meanDif(disp,:);
%                     sdd_std(vn,grp,:) = 1000*stdData(disp,:);
                    sd_m(vn,:,iDataset) = 1000*meanDif(disp,:);
                    sd_std(vn,:,iDataset) = 1000*stdData(disp,:);
                    sd_min(vn,:,iDataset) = minData(disp,:);
                    sd_max(vn,:,iDataset) = maxData(disp,:);
%                     meanData'
 

            end

        end
    dispMinMean(disp,iSys) = min(sd_m(:));
    dispMaxMean(disp,iSys) = max(sd_m(:));
    dispMinStd(disp,iSys) = min(sd_std(:));
    dispMaxStd(disp,iSys) = max(sd_std(:));
%     dispMaxMin(disp,iSys) = max(sd_min(:));
%     dispMinMin(disp,iSys) = min(sd_min(:));
%     dispMaxMax(disp,iSys) = max(sd_max(:));
%     dispMinMax(disp,iSys) = min(sd_max(:));

   end
 
    

end
  data.mean(:,1) = min(abs([dispMinMean dispMaxMean]),[],2);
  data.mean(:,2) =  max(abs([dispMinMean dispMaxMean]),[],2);

  data.std(:,1) = min(abs([dispMinStd dispMaxStd]),[],2);
  data.std(:,2) =  max(abs([dispMinStd dispMaxStd]),[],2);

%   data.min(:,1) = min(abs([dispMinMin dispMaxMin]),[],2);
%   data.min(:,2) =  max(abs([dispMinMin dispMaxMin]),[],2);



end