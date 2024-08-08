function  [caxisLim,meanVal,stat,tmean] = colorbarLims(regData,Z,meanVal,rmNaNFlag,iGroupNum,...
                                        n,avgFlag,storeLim,fixedmean)
%COLORBARLIMS 
% colorbarlims calculates the limits of the colorbars that are eventually
% used to make the tables and figures published in the paper. 
% regData: is the registered data loaded from *_reg.mat of each file
% Z: is the minimum area where all the codes have a provided data.
% meanVal: is used in particular when a fixed mean is to be subtracted from
% all the groups.
% rmNaNFlag: (flag) Main intention was to replace the 0s with nan to 
% improve plots
% iGroupNum: Related to meanVal. Depending on the group number and avgFlag
% the value will be stored will be different.
% n: 1 for U,2 for V,3 for W or 4 for magnitude (Abs).
% avgFlag: (flag) Removes the meanvalue to get the residual fields instead
% storeLim: (flag) To store the lims calculated upto 2 standard deviations
% fixedmean: (flag) Taking mean value from first vendor in the analysis
            %to be subtracted from all of the related steps of other
            %vendors too

if avgFlag == 0
    stat = [];
end
if n == 1
    temp = regData(:,:,4); % U displacement
elseif n == 2
    temp = regData(:,:,5); % V displacement
elseif n == 3
    temp = regData(:,:,6); % W displacement
elseif n == 4
    temp= sqrt(regData(:,:,4).^2 + regData(:,:,5).^2 + regData(:,:,6).^2);
%     'Abs Displacement';
end

if rmNaNFlag == 1
        [~,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
        if max(Ncount)/tn > 0.25
            Z(Z==0) = NaN;
            temp(isnan(Z)) = NaN;
        end
end
stat(1) =  mean(temp,'all','omitnan');
stat(2) = std(temp(:),'omitnan');
stat(3) = min(temp,[],'all','omitnan');
stat(4) = max(temp,[],'all','omitnan');

if avgFlag
    if storeLim
        if iGroupNum == 1
           meanVal = mean(temp,'all','omitnan');
        elseif isnan(meanVal) && iGroupNum ~=1
            meanVal = mean(temp,'all','omitnan');
        end
        if fixedmean %Taking mean value from first vendor in the analysis
            %to be subtracted from all of the related steps of other
            %vendors too
            temp = 1000*(temp-meanVal);
        else
            meanVal = mean(temp,'all','omitnan');
            temp = 1000*(temp-meanVal);        
        end
    else
        if fixedmean
            temp = 1000*(temp-meanVal);
        else
            meanVal = mean(temp,'all','omitnan');
            temp = 1000*(temp-meanVal);
        end
    end
    
else %For the plotting of actual data without mean subtraction
    if storeLim
        if iGroupNum == 1
           meanVal = mean(temp,'all','omitnan');
        elseif isnan(meanVal) && iGroupNum ~=1
            meanVal = mean(temp,'all','omitnan');
        end
    end
end
    
if storeLim %&& iGroupNum == 1
    caxisLim = [mean(temp,'all','omitnan')-2*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2*std(temp,[],'all','omitnan')];
end
tmean = mean(temp,'all','omitnan');   
end
