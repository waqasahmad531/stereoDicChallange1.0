function  [caxisLim,meanVal,stat,tmean] = post_plot_v6(regData,Z,meanVal,rmNaNFlag,iGroupNum,...
                                        n,testfolder,avgFlag,...
                                        storeLim,fixedmean)
%post_plot(regData,baseDir) post_plot gets registered data and plots them.
%baseDir should a folder for every vendor so that we do not mix the plots
%   Value of n would define which type of plot is required. If n=1, U
%   displacement is plotted. For n=2, V displacement is plotted and for n=3
%   W displacement is plotted. However, for n=4, we get the absolute
%   displacement. Default value of n=4. 

% if nargin < 4
%     n = 4;
%     testfolder = pwd;
%     avgFlag = 0;
%     scale = 0;
% end
if avgFlag == 0
    stat = [];
end

% Z = regData(:,:,3);
% if n == 4
%  disp([sum((Z(:)==0)),])
% if avgFlag
%     regData(:,:,4:6) = 1000*regData(:,:,4:6);
% end

if n == 1
    temp = regData(:,:,4);
%     figtit = 'U Displacement';
elseif n == 2
    temp = regData(:,:,5);
%     figtit = 'V Displacement';
elseif n == 3
    temp = regData(:,:,6);
%     figtit = 'W Displacement';
elseif n == 4
    temp= sqrt(regData(:,:,4).^2 + regData(:,:,5).^2 + regData(:,:,6).^2);
%     figtit = 'Abs Displacement';
end

idv = strfind(testfolder,'\');
vendor = extractBetween(testfolder,idv(2)+1,idv(3)-1);
% testfolder(():());

if rmNaNFlag == 1
%     temp(temp==0) = NaN;

%             B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%       loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
%             temp(temp==uv(Ncount == max(Ncount))) = NaN;
            Z(Z==0) = NaN;
            temp(isnan(Z)) = NaN;
        end
end

    
% temp = temp-mean(temp,'all','omitnan'); 

    

%  figure(1)
% fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
%        'Outerposition',[0.1,0.0,0.53,0.99]);
   %, 'InnerPosition',[0.2,0.25,0.62,0.62]
%    if pltflag
%     fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
%        'Outerposition',[0.238802083333333,0.562037037037037,0.225260416666667,0.289351851851852]);
%    end
   
%     ax1 = axes('Position',[0.2 0.23 0.6 0.6],'Box', 'on');
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



% 
% NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.05;
% SW = [min(xlim) min(ylim)]+[diff(xlim) diff(ylim)]*0.05;
% NW = [min(xlim) max(ylim)]+[diff(xlim) -diff(ylim)]*0.05;
% SE = [max(xlim) min(ylim)]+[-diff(xlim) diff(ylim)]*0.05;
% 
% %% Top
% text(NE(1), NE(2), 'Top Right', 'VerticalAlignment','top','HorizontalAlignment',...
%     'right', 'FontSize',20, 'color', 'red')
% 
% text(NE(1)/2 + NW(1)/2, NE(2)/2 + NW(2)/2, 'Top Center', 'VerticalAlignment',...
%     'top', 'HorizontalAlignment','center', 'FontSize',20, 'color', 'red')
% 
% text(NW(1), NW(2), 'Top Left', 'VerticalAlignment','top', 'HorizontalAlignment',...
%     'left', 'FontSize',20, 'color', 'red')
% 
% %% Bottom
% text(SW(1), SW(2), 'Bottom Left', 'VerticalAlignment','bottom', 'HorizontalAlignment',...
% 'left', 'FontSize',20, 'color', 'blue')
% text(SW(1)/2 + SE(1)/2, SW(2)/2 + SE(2)/2, 'Bottom Center', 'VerticalAlignment',...
%     'bottom', 'HorizontalAlignment','center', 'FontSize',20, 'color', 'blue')
% text(SE(1), SE(2), 'Bottom Right', 'VerticalAlignment','bottom', 'HorizontalAlignment',...
%     'right', 'FontSize',20, 'color', 'blue')
% 
% %% Middle
% text(NW(1)/2 + SW(1)/2,NW(2)/2 + SW(2)/2, 'Middle Left', 'VerticalAlignment',...
%     'top', 'HorizontalAlignment','left', 'FontSize',20)
% text(NE(1)/2 + SE(1)/2,NE(2)/2 + SE(2)/2, 'Middle Right', 'VerticalAlignment',...
%     'top', 'HorizontalAlignment','right', 'FontSize',20)
% 
% text(NE(1)/2 + NW(1)/2 + SW(1)/2 + SE(1)/2,NE(2)/2 + NW(2)/2 + SW(2)/2 + SE(2)/2  , ...
%     'Middle Center', 'VerticalAlignment','top', 'HorizontalAlignment','center', 'FontSize',20)
% 
% set(gca,'FontSize',20)