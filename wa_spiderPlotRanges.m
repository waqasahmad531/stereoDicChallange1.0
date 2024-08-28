function data = wa_spiderPlotRanges(meanPerFrame,vend,steps,absType)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    meanMin = zeros(4,2);
    meanMax = zeros(4,2);
    stdMin = zeros(4,2);
    stdMax = zeros(4,2);
    dispMaxMin = zeros(4,2);
    dispMinMin = zeros(4,2);
    dispMaxMax = zeros(4,2);
    dispMinMax = zeros(4,2);
% for disp = 1:4
%      radCount = 0;
   for iSys = 1:2%:size(sysgroups,1)
       cntr = 0; % we can take this outside to solve both systems in one go
        for vn = 1:length(vend)
            for iDataset= 1:size(vend{1},2)
                tt = cell2mat(squeeze(meanPerFrame(vn,iSys,iDataset)));
                mdata = squeeze(tt(:,1,:)); %mean data
                sdata = squeeze(tt(:,2,:)); %standard deviation data
                mindata = squeeze(tt(:,3,:)); %minimum data
                maxdata = squeeze(tt(:,4,:)); %maximum data
                %difference between mean and stage displacement in
                %micrometers
                md = 1000*(mdata-steps); 
                stdd = 1000*sdata;
                cntr = cntr + 1;
                %take data from all the datasets and vendors and combine
                %them for one system in slices
                sd_m(:,:,cntr) = md; 
                sd_std(:,:,cntr) = stdd;
            end

        end

        tempMean = min(sd_m,[],3); % minimum in slices direction
        meanMin(:,iSys) = min(tempMean,[],2); %minimum in steps direction
        meanMin(:,iSys) = meanMin(:,iSys)-([10;10;10;10]-mod(abs(meanMin(:,iSys)),10));
        tempMean = max(sd_m,[],3); % maximum in slices direction
        meanMax(:,iSys) = max(tempMean,[],2); %maximum in steps direction
        meanMax(:,iSys) = meanMax(:,iSys)+([10;10;10;10]-mod(abs(meanMax(:,iSys)),10));

        tempStd = min(sd_std,[],3); % minimum in slices direction
        stdMin(:,iSys) = min(tempStd,[],2); %minimum in steps direction
        tempStd = max(sd_std,[],3); % maximum in slices direction
        stdMax(:,iSys) = max(tempStd,[],2); %maximum in steps direction
        stdMax(:,iSys) = stdMax(:,iSys)+([5;5;5;5]-mod(abs(stdMax(:,iSys)),5));
   end
 
    

% end
if absType == true 
    data.mean(:,1) = min(abs([meanMin meanMax]),[],2);
    data.mean(:,2) =  max(abs([meanMin meanMax]),[],2);

    data.std(:,1) = min(abs([stdMin stdMax]),[],2);
    data.std(:,2) =  max(abs([stdMin stdMax]),[],2);
else
    data.mean(:,1) = -max(abs([meanMin meanMax]),[],2);%min([meanMin meanMax],[],2);
    data.mean(:,2) =  max(abs([meanMin meanMax]),[],2);

    data.std(:,1) = min([stdMin stdMax],[],2);
    data.std(:,2) =  max([stdMin stdMax],[],2);
end

%   data.min(:,1) = min(abs([dispMinMin dispMaxMin]),[],2);
%   data.min(:,2) =  max(abs([dispMinMin dispMaxMin]),[],2);



end