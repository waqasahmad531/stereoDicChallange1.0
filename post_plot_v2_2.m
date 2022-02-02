function  [plotName,caxisLim] = post_plot_v2_2(regData,Z,rmNaNFlag,labn,n,testfolder,avgFlag,...
                        storeLim,fileext,stU,stV,stW,lims)
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

X = regData(:,:,1);
Y = regData(:,:,2);
% Z = regData(:,:,3);
% if avgFlag
%     regData(:,:,4:6) = 1000*regData(:,:,4:6);
% end

if n == 1
    temp = regData(:,:,4);
    figtit = 'U Displacement';
elseif n == 2
    temp = regData(:,:,5);
    figtit = 'V Displacement';
elseif n == 3
    temp = regData(:,:,6);
    figtit = 'W Displacement';
elseif n == 4
    temp= sqrt(regData(:,:,4).^2 + regData(:,:,5).^2 + regData(:,:,6).^2);
    figtit = 'Abs Displacement';
end

idv = strfind(testfolder,'\');
vendor = extractBetween(testfolder,idv(2)+1,idv(3)-1);
% testfolder(():());

if rmNaNFlag == 1
%     temp(temp==0) = NaN;

    if strcmp(vendor,'Lava')
%         B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%     loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
            Z(Z==0) = NaN;
            temp(isnan(Z)) = NaN;
            
        end
    end
    
     if strcmp(vendor,'Sandia')
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
    
     if strcmp(vendor,'Grewer')
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
end

    
% temp = temp-mean(temp,'all','omitnan'); 

    

%  figure(1)
% fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
%        'Outerposition',[0.1,0.0,0.53,0.99]);
   %, 'InnerPosition',[0.2,0.25,0.62,0.62]
   fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
       'Outerposition',[0.3,0.3,0.5,0.6]);
   
%     ax1 = axes('Position',[0.2 0.23 0.6 0.6],'Box', 'on');
if avgFlag
    temp = 1000*(temp-mean(temp,'all','omitnan'));
end
   ax = surf(X,Y,Z,temp); 
   colormap((hsv(30))); 
    cb = colorbar;
    cbp = cb.Position;
    yt=get(cb,'XTick');
    %     set(cb,'XTickLabel',sprintf('%0.3f',yt));
%     cb.Position = [cbp(1)+10 cbp(2)-10 cbp(3) 0.6];
    if avgFlag 
        cb.Title.String = '[\mum]';
    else
        cb.Title.String = '[mm]';
    end
    cb.TickLabelInterpreter = 'latex';
    
if storeLim
    caxisLim = [mean(temp,'all','omitnan')-2.5*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2.5*std(temp,[],'all','omitnan')];
        if any(isnan(caxisLim))
           caxisLim = caxis;
        else
            caxis(lims);
            cxisLim = lims;
        end
else
    caxis(lims);
    caxisLim = lims;
end

ax.LineStyle = 'none';ax.EdgeColor = 'flat';ax.FaceColor = 'flat';

axis xy tight equal
f = gca;
% f.View = [30,30];
f.TickDir = 'in';
f.XMinorTick = 'on';
f.YMinorTick = 'on';
f.ZMinorTick = 'on';
f.Box = 'on';
f.BoxStyle = 'back';
f.XMinorGrid = 'on';
f.YMinorGrid = 'on';
f.ZMinorGrid = 'on';
% if max(Z,[],'all') 
f.ZTick = [min(Z,[],'all'),max(Z,[],'all')];
f.ZTickLabel = {[round(min(Z,[],'all')),round(max(Z,[],'all'))]};%,[0,round(max(Z,[],'all'))]'],[1,1]);



f.TickLabelInterpreter = 'latex';
xlabel('X (mm)','Interpreter','latex');
ylabel('Y (mm)','Interpreter','latex');
zlabel('Z (mm)','Interpreter','latex');
imgfolder = 'Plots';
imgfolder1 = fullfile(testfolder,strcat(imgfolder,'(',date,')'),'turbo');
    
    if ~isfolder(imgfolder1)
        mkdir(imgfolder1)
    end
    
%     [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);    
%     labn = [auxZoneNames;auxZoneVals]';
%     field = post_plot(regGridData,iFile,labn,2);
    
    if avgFlag ~= 1
%         figtit = strcat(figtit,'(Error)');
        title(figtit,labn,'Interpreter','latex')
        st = strrep(labn,':','');
        st = strrep(st,',','_');
        iFileName = strcat(st,' ',figtit(1:end-8),fileext);
        iFileName = iFileName(~isspace(iFileName));
%         gds = strrep(gds,':','_');
    else
        figtit = strcat(figtit,'(Error)');
        title(figtit,labn,'Interpreter','latex')
        st = strrep(labn,':','');
        st = strrep(st,',','_');
        iFileName = strcat(st,' ',figtit(1:end-15),'_Avg',fileext);
        iFileName = iFileName(~isspace(iFileName));
    end
    
    op = [0.102,0.0065,0.6911,0.1474];
    ax1 = axes('Position',op);
    ax1.XColor = 'none';
    ax1.YColor = 'none';
    tu=text(0.05,0.05,stU,'VerticalAlignment',...
    'bottom', 'HorizontalAlignment','center', 'FontSize',8,...
    'Interpreter','latex');
    tv=text(0.45,0.05,stV,'VerticalAlignment',...
    'bottom', 'HorizontalAlignment','center', 'FontSize',8,...
    'Interpreter','latex');
    tw=text(0.85,0.05,stW,'VerticalAlignment',...
    'bottom', 'HorizontalAlignment','center', 'FontSize',8,...
    'Interpreter','latex');
    
    plotName = fullfile(imgfolder1,iFileName);
%     plotName = fullfile(imgfolder1,imgfolder);
    
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