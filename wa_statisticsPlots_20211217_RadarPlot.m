
clc;clear all;close all;
dantec = [410 411 412 413 414;...
               420 421 422 423 424]; %group 3 system1 and 2 Dantec 
% matchID = [610];
lavision = [510,511,512 513 514;...
               520,521 522 523 524]; % LaVision
matchid = [610 611 612 613 614];

 vend = {dantec,lavision,matchid};

 %% Number of plots for legend

 grpdataset = 0;
for ven = 1:length(vend)
    sysgroups = vend{ven};
    for grp = 1:size(sysgroups,1)
        groups = sysgroups(grp,:);
        grpdataset = grpdataset + length(groups);
    end
    
end
        
%%
% linclr = jet(grpdataset);%parula(length(vend));
% linclr = [0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250];
linPro = "-.";%,"-.","-."];

%%
linclr = [0.8500 0.3250 0.0980;
            0 0.4470 0.7410;
            0.9290 0.6940 0.1250;
            0.4940 0.1840 0.5560;
            0.6350 0.0780 0.1840;
            0.4660 0.6740 0.1880];
marker = ["o","s","d"];
dispVar = ["U","V","W","A"];
meandir = 'D:\DIC\stepsdMeanData.mat';
venNum = [4,5,6];
load(meandir)
steps(:,4) = sqrt(steps(:,1).^2 + steps(:,2).^2 + steps(:,3).^2);
steps = steps';
rng(5)
fileFor = 'eps';
for disp = 1%:4
     clrCounter = 0;
    for vn = 1:length(vend)
        sysgroups = vend{vn};
%     groupID = grpid(vn);
       
        curMark = marker(vn);
        for grp = 1%:size(sysgroups,1)
            if ~(vn==3 && grp==2)
             mpfvg = squeeze(meanPerFrame(vn,grp,:)); %number of datasets
            
%              clrind = randi(length(linclr),1,5);
              for igroupNum= 1
                  
                  temp = mpfvg{igroupNum}; %frames
                  meanData = squeeze(temp(:,1,:));
                  stdData = squeeze(temp(:,2,:));
                  minData = squeeze(temp(:,3,:));
                  maxData = squeeze(temp(:,4,:));
                  meanDif = steps-meanData;
                  sd_m(vn,grp,:) = 1000*meanDif(disp,:);
                  sdd_std(vn,grp,:) = 1000*stdData(disp,:);
%                      figure(1)
%                      hold on
%                      clrCounter = clrCounter + 1;
% %                      plot(1:18,1000*meanDif(disp,:),curMark,'Color',linclr(clrind(igroupNum),:),'MarkerFaceColor',linclr(clrind(igroupNum),:),'MarkerEdgeColor','k')
%                     % plot(1:18,1000*meanDif(disp,:),curMark,'Color',linclr(clrCounter,:),'MarkerFaceColor',linclr(clrCounter,:),'MarkerEdgeColor','k')
%                      hold on
%                      drawnow

%                      figure(2)
%                      hold on
% %                      clrCounter = clrCounter + 1;
%                      plot(1:18,1000*stdData(disp,:),curMark,'Color',linclr(clrCounter,:),'MarkerFaceColor',linclr(clrCounter,:),'MarkerEdgeColor','k') 
%                      hold on
%                      drawnow        
              end  

            end
        end
    end
    
%     figure(1)
%     set(gcf,'color','w')
%     f = gca;
% % f.View = [30,30];
%        f.TickDir = 'in';
% %        f.XMinorTick = 'on';
%        f.YMinorTick = 'on';
%        f.XGrid = "on";
%        f.YGrid = "on";
% % f.ZMinorTick = 'on';
%        f.Box = 'on';
%        f.BoxStyle = 'back';
% %        f.XMinorGrid = 'on';
%        f.YMinorGrid = 'on';
%        titStr = sprintf("${%s_{stage_{mean}} - %s_{DIC_{mean}}} [\\mu m]$",dispVar(disp),dispVar(disp));
% %        tit = title(titStr,'Interpreter','latex'); tit.FontSize = 13;
%        xlabel('Frame Number','Interpreter','latex','FontSize',13)
%        ylabStr = sprintf("${%s_{stage_{mean}} - %s_{DIC_{mean}}} [\\mu m]$",dispVar(disp),dispVar(disp));
%        ylabel(ylabStr,'Interpreter','latex','FontSize',13)
%         
% %        lgd = legend('4 (sys:1)','4 (sys:2)','5 (sys:1)','5 (sys:2)','6 (sys:1)');
% %        htitle = get(lgd,'Title');
% %        set(htitle,'String','Participant:')
% % %        lgd.Title = 
% %        lgd.Location = 'best';
% %        lgd.Interpreter = 'latex';
%        framename = sprintf('mean_d%s.%s',dispVar(disp),fileFor);
%         framename = framename(~isspace(framename));
%         fieldP = fullfile('D:\DIC\Statistics',framename);
% %         exportgraphics(gcf,fieldP,'Resolution',600)
%         clf
%        figure(2)
%        set(gcf,'color','w')
%         f = gca;
% % f.View = [30,30];
%        f.TickDir = 'in';
% %        f.XMinorTick = 'on';
%        f.YMinorTick = 'on';
%        f.XGrid = "on";
%        f.YGrid = "on";
% % f.ZMinorTick = 'on';
%        f.Box = 'on';
%        f.BoxStyle = 'back';
% %        f.XMinorGrid = 'on';
%        f.YMinorGrid = 'on';
%        titStr = sprintf("${%s_{stage_{mean}} - %s_{DIC_{mean}}} [\\mu m]$",dispVar(disp),dispVar(disp));
% %        tit = title(titStr,'Interpreter','latex'); tit.FontSize = 13;
%        xlabel('Frame Number','Interpreter','latex','FontSize',13)
%        ylabStr = sprintf("${%s_{stage_{mean}} - %s_{DIC_{mean}}} [\\mu m]$",dispVar(disp),dispVar(disp));
%        ylabel('Standard Deviation [$\mu m$]','Interpreter','latex','FontSize',13)
% 
%        lgd = legend('4 (sys:1)','4 (sys:2)','5 (sys:1)','5 (sys:2)','6 (sys:1)');
%        htitle = get(lgd,'Title');
%        set(htitle,'String','Participant:')
%        lgd.Location = 'best';
%        lgd.Interpreter = 'latex';
%        framename = sprintf('standardDeviation_d%s.%s',dispVar(disp),fileFor);
%         framename = framename(~isspace(framename));
%         fieldP = fullfile('D:\DIC\Statistics',framename);
% %         exportgraphics(gcf,fieldP,'Resolution',600)
%         clf
end

close all;


d1 = squeeze(sd_m(1,1,:));
d2 = squeeze(sd_m(2,1,:));
d3 = squeeze(sd_m(3,1,:));
P = [d1,d2,d3]';
p = [1 2 3 6 7 10 11 14 15 18 4 5 8 9 12 13 16 17 ];
% minl = min(P(1,p)); maxl = max(P(1,p));
minl = min(P(:)); maxl = max(P(:));
axl = [repmat(-max([abs([minl,maxl])]),1,18);repmat(max([abs([minl,maxl])]),1,18)];
figure(1)

subplot(1,3,1)
spider_plot(P(:,p),...
'AxesLabels', {'S1', 'S2', 'S3', 'S6', 'S7','S10', 'S11', 'S14', 'S15', 'S18','S4', 'S5', 'S8', 'S9', 'S12','S13', 'S16', 'S17'},...
'AxesInterval', 4,...
'AxesPrecision', 0,...
'AxesLimits', axl,...
'AxesLabelsOffset', 0.1,...
'AxesDisplay', 'one',...
'AxesScaling', 'linear',...
'AxesColor', [0.8, 0.8, 0.8],...
'AxesDirection', {'normal', 'normal', 'normal', 'normal', 'normal','reverse','reverse','normal', 'normal', 'normal','reverse','reverse','normal', 'normal', 'normal', 'normal','reverse','reverse'},...
'FillOption', {'on'},...
'AxesFontSize', 12,...
'AxesOffset', 1,...
    'AxesZoom', 0.7,...
    'AxesHorzAlign', 'center',...
    'AxesVertAlign', 'middle',...
'LineStyle', {'--','--','--'},...
'LineWidth', [0.5,0.7,1],...
 'LineTransparency', 0.5,...
 'Marker', {'o', 'd', 's'},...
'LabelFontSize', 13,...
'FillTransparency', [0.05 0.075 0.06]);
title('Axes inverted for negative','Interpreter','latex')

subplot(1,3,2)
spider_plot(P(:,p),...
'AxesLabels', {'S1', 'S2', 'S3', 'S6', 'S7','S10', 'S11', 'S14', 'S15', 'S18','S4', 'S5', 'S8', 'S9', 'S12','S13', 'S16', 'S17'},...
'AxesInterval', 4,...
'AxesPrecision', 0,...
'AxesLimits', axl,...
'AxesLabelsOffset', 0.1,...
'AxesDisplay', 'one',...
'AxesScaling', 'linear',...
'AxesColor', [0.8, 0.8, 0.8],...
'FillOption', {'on'},...
'AxesFontSize', 12,...
'AxesOffset', 1,...
    'AxesZoom', 0.7,...
    'AxesHorzAlign', 'center',...
    'AxesVertAlign', 'middle',...
'LineStyle', {'--','--','--'},...
'LineWidth', [0.5,0.7,1],...
 'LineTransparency', 0.5,...
 'Marker', {'o', 'd', 's'},...
'LabelFontSize', 13,...
'FillTransparency', [0.05 0.075 0.06]);
title('Original Limits','Interpreter','latex')

% figure;
% % subplot(1,3,3)
% minl = min(abs(P(:))); maxl = max(P(:));
% axl = [repmat(minl-5,1,18);repmat(maxl+10,1,18)];
% subplot(1,3,2)
% spider_plot(abs(P(:,p)),...
% 'AxesLabels', {'S1', 'S2', 'S3', 'S6', 'S7','S10', 'S11', 'S14', 'S15', 'S18','S4', 'S5', 'S8', 'S9', 'S12','S13', 'S16', 'S17'},...
% 'AxesInterval', 4,...
% 'AxesLimits', axl);

% figure;
subplot(1,3,3)
minl = min(abs(P(:))); maxl = max(P(:));
axl = [repmat(minl,1,18);repmat(maxl+10,1,18)];

spider_plot(abs(P(:,p)),...
'AxesLabels', {'S1', 'S2', 'S3', 'S6', 'S7','S10', 'S11', 'S14', 'S15', 'S18','S4', 'S5', 'S8', 'S9', 'S12','S13', 'S16', 'S17'},...
'AxesInterval', 4,...
'AxesPrecision', 0,...
'AxesLimits', axl,...
'AxesLabelsOffset', 0.1,...
'AxesDisplay', 'one',...
'AxesScaling', 'linear',...
'AxesColor', [0.8, 0.8, 0.8],...
'FillOption', {'on'},...
'AxesFontSize', 12,...
'AxesOffset', 1,...
    'AxesZoom', 0.7,...
    'AxesHorzAlign', 'center',...
    'AxesVertAlign', 'middle',...
'LineStyle', {'--','--','--'},...
'LineWidth', [0.5,0.7,1],...
 'LineTransparency', 0.5,...
 'Marker', {'o', 'd', 's'},...
'LabelFontSize', 13,...
'FillTransparency', [0.05 0.1 0.15]);
title('Abs($U_{stage}-U_{DIC}$)','Interpreter','latex')

lgd = legend('4 (sys:1)','5 (sys:1)','6 (sys:1)');
       htitle = get(lgd,'Title');
       set(htitle,'String','Participant:','FontSize',14)
       lgd.Location = 'best';
       lgd.Interpreter = 'latex';
       lgd.FontSize = 13;
       lgd.Box = 'off';