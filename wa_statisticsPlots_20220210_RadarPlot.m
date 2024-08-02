
clc;clear all;close all;
dice =[115;125]; %[115 115 115 115 115;...
%             125 125 125 125 125]; 
dantec = [211;221];%[410 411 412 413 414;...
          %     420 421 422 423 424]; %group 3 system1 and 2 Dantec 
% matchID = [610];
lavision = [311;321];%[510,511,512 513 514;...
            %   520,521 522 523 524]; % LaVision
matchid = [411;421];%[610 611 612 613 614;...
           % 620 621 622 623 624];
csi = [511;521];%[710 711 712 713 714; %CSI
         %    720 721 722 723 724];

 vend = {dice,dantec,lavision,matchid,csi};

 %% Number of plots for legend

 grpdataset = 0;
for ven = 1:length(vend)
    sysgroups = vend{ven};
    for iSys = 1:size(sysgroups,1)
        groups = sysgroups(iSys,:);
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
marker = ["o","s","d","<",">"];
dispVar = ["U","V","W","A"];
meandir = 'H:\DIC\stepsdMeanData6a.mat';
outputfile = 'H:\DIC\Statistics Radar4';
venNum = [4,5,6,7];
load(meandir)
steps(:,4) = sqrt(steps(:,1).^2 + steps(:,2).^2 + steps(:,3).^2);
steps = steps';
rng(5)
fileFor = 'eps';
% fig = figure("Position",[481.8,166.2,566.2,595.8],'Color','w');
fig = figure("Position",[475.4,159.8,579.2,579.2],'Color','w');

absType = false;

data = wa_spiderPlotRanges_v4(meanPerFrame,vend,steps,absType);



for disp = 1:4 % 1=U, 2=V, 3=W, 4,Abs displacement
     clrCounter = 0;
     meanMinL = data.mean(disp,1);
     meanMaxL = data.mean(disp,2);
     stdMinL = 0;%data.std(disp,1);
     stdMaxL = data.std(disp,2);
     if absType == 1
        meanMinL = 0;%data.mean(disp,1);
        meanMaxL = data.mean(disp,2);
        stdMinL = 0;%data.std(disp,1);
        stdMaxL = data.std(disp,2);
     else
         meanMinL = data.mean(disp,1);
         meanMaxL = data.mean(disp,2);
         stdMinL = data.std(disp,1);
         stdMaxL = data.std(disp,2);
     end
   for iSys = 1:2%:size(sysgroups,1)
        for iDataset= 1:size(vend{1},2) %5
            sd_m = NaN(3,18);
            sdd_std = NaN(3,18);
            for vn = 1:length(vend)
                sysgroups = vend{vn};
%     groupID = grpid(vn);
       
                curMark = marker(vn);
            
                    mpfvg = squeeze(meanPerFrame(vn,iSys,:)); %number of datasets
                    temp = mpfvg{iDataset}; %frames
                    meanData = squeeze(temp(:,1,:));
                    stdData = squeeze(temp(:,2,:));
                    minData = squeeze(temp(:,3,:));
                    maxData = squeeze(temp(:,4,:));
                    meanDif = meanData-steps;
%                     sd_m(vn,grp,:) = 1000*meanDif(disp,:);
%                     sdd_std(vn,grp,:) = 1000*stdData(disp,:);
                    sd_m(vn,:) = 1000*meanDif(disp,:);
                    sdd_std(vn,:) = 1000*stdData(disp,:);
%                     meanData'

            end
            %Plotting 

                clf;
                statsSpiderPlot_v2(sd_m,meanMinL,meanMaxL,stdMaxL,absType);
                if absType == 1
                    titStr = sprintf('Abs($\\bar{%s}_{DIC}-%s_{stage}$)',dispVar(disp),dispVar(disp));
                else
                    titStr = sprintf('$\\bar{%s}_{DIC}-%s_{stage}$',dispVar(disp),dispVar(disp));
                end
                tit = title(titStr,'Interpreter','latex');
                tit.FontSize = 16;
                lgdStr = {'1','2','3','4','5'};
                lgd = legend(lgdStr);
                htitle = get(lgd,'Title');
                set(htitle,'String','Participant:','FontSize',14)
                lgd.Location = 'southoutside';
                lgd.Interpreter = 'latex';
                lgd.NumColumns = length(vend);
                lgd.FontSize = 13;
                lgd.Box = 'on';
                if absType == 1
                    meanPlot = sprintf('Abs_meanSys%gDataset%gd%s.%s',iSys,iDataset-1,dispVar(disp),fileFor); 
                else
                    meanPlot = sprintf('meanSys%gDataset%gd%s.%s',iSys,iDataset-1,dispVar(disp),fileFor); 
                end
                
                fullname = fullfile(outputfile,meanPlot);
                exportgraphics(gcf,fullname,'Resolution',600)
                drawnow

                clf

                statsSpiderPlotStd_v2(sdd_std,stdMinL,stdMaxL,absType);
                if absType == 1
                    titStr = sprintf('Abs. Standard Deviation of ($%s_{DIC}$)',dispVar(disp));
                else
                    titStr = sprintf('Standard Deviation of ($%s_{DIC}$)',dispVar(disp));
                end
                tit = title(titStr,'Interpreter','latex');
                tit.FontSize = 16;
                lgdStr = {'1','2','3','4','5'};
                lgd = legend(lgdStr);
                htitle = get(lgd,'Title');
                set(htitle,'String','Participant:','FontSize',14)
                lgd.Location = 'southoutside';
                lgd.Interpreter = 'latex';
                lgd.NumColumns = length(vend);
                lgd.FontSize = 15;
                lgd.Box = 'on';
                if absType == 1
                    stdPlot = sprintf('Abs_stdSys%gDataset%gd%s.%s',iSys,iDataset-1,dispVar(disp),fileFor);
                else
                    stdPlot = sprintf('stdSys%gDataset%gd%s.%s',iSys,iDataset-1,dispVar(disp),fileFor);
                end
                fullname = fullfile(outputfile,stdPlot);
                exportgraphics(gcf,fullname,'Resolution',600)
                drawnow

        end

    end
    

end

% close all;




% legendmarkeradjust(20)

% spider_plot(abs(P(:,p)),...
% 'AxesLabels', {'S1', 'S2', 'S3', 'S6', 'S7','S10', 'S11', 'S14', 'S15', 'S18','S4', 'S5', 'S8', 'S9', 'S12','S13', 'S16', 'S17'},...
% 'AxesInterval', 4,...
% 'AxesPrecision', 0,...
% 'AxesLimits', axl,...
% 'AxesLabelsOffset', 0.1,...
% 'AxesDisplay', 'one',...
% 'AxesScaling', 'linear',...
% 'AxesColor', [0.8, 0.8, 0.8],...
% 'FillOption', {'on'},...
% 'AxesFontSize', 12,...
% 'AxesOffset', 1,...
% 'AxesZoom', 0.7,...
% 'AxesHorzAlign', 'center',...
% 'AxesVertAlign', 'middle',...
% 'LineStyle', {'--','--','--'},...
% 'LineWidth', [0.5,0.7,1],...
% 'LineTransparency', 0.5,...
% 'Marker', {'o', 'd', 's'},...
% 'MarkerSize', [8, 10, 12],...
% 'MarkerTransparency', 1,...
% 'LabelFontSize', 13,...
% 'FillTransparency', [0.01 0.05 0.075]);
% titStr = sprintf('Abs($%s_{stage}-%s_{DIC}$)',dispVar(1),dispVar(1));
% tit = title(titStr,'Interpreter','latex');
% tit.FontSize = 14;
% lgdStr = {'4','5','6'};
% lgd = legend(lgdStr);
%        htitle = get(lgd,'Title');
%        set(htitle,'String','Participant:','FontSize',14)
%        lgd.Location = 'southoutside';
%        lgd.Interpreter = 'latex';
%        lgd.NumColumns = length(vend);
%        lgd.FontSize = 13;
%        lgd.Box = 'on';
% % s.LegendLabels = {'4','5','6'};
% % s.LegendHandle.Location = 'northeastoutside';
% 
% 
% % legendmarkeradjust(20)
%%
% Ps = [ sdd_std];


% figure(2)
% p = [1 2 3 6 7 10 11 14 15 18 4 5 8 9 12 13 16 17 ];
% 
% 
% 
% minl = min(abs(Ps(:))); maxl = max(Ps(:));
% axl = [repmat(minl,1,18);repmat(maxl,1,18)];
% 
% spider_plot(abs(Ps(:,p)),...
% 'AxesLabels', {'S1', 'S2', 'S3', 'S6', 'S7','S10', 'S11', 'S14', 'S15', 'S18','S4', 'S5', 'S8', 'S9', 'S12','S13', 'S16', 'S17'},...
% 'AxesInterval', 4,...
% 'AxesPrecision', 0,...
% 'AxesLimits', axl,...
% 'AxesLabelsOffset', 0.1,...
% 'AxesDisplay', 'one',...
% 'AxesScaling', 'linear',...
% 'AxesColor', [0.8, 0.8, 0.8],...
% 'FillOption', {'on'},...
% 'AxesFontSize', 12,...
% 'AxesOffset', 1,...
% 'AxesZoom', 0.7,...
% 'AxesHorzAlign', 'center',...
% 'AxesVertAlign', 'middle',...
% 'LineStyle', {'--','--','--'},...
% 'LineWidth', [0.5,0.7,1],...
% 'LineTransparency', 0.5,...
% 'Marker', {'o', 'd', 's'},...
% 'LabelFontSize', 13,...
% 'FillTransparency', [0.01 0.05 0.075]);
% title('Standard Deviation of ($U_{DIC}$)','Interpreter','latex')
% 
% lgd = legend('4 (sys:1)','5 (sys:1)','6 (sys:1)');
%        htitle = get(lgd,'Title');
%        set(htitle,'String','Participant:','FontSize',14)
%        lgd.Location = 'best';
%        lgd.Interpreter = 'latex';
%        lgd.FontSize = 13;
%        lgd.Box = 'off';

% % [Xr,Yr] = pol2cart(linspace(0,2*pi - 2*pi/nPoints,nPoints),repmat(rhoMax/nRing*n,1,nPoints));
%     
% % close all;clc;clearvars;
% figure
% N = 160;
% M = 18;
% Data = 18+1*randn(1,M) + 2.*randn(N,M);
% 
% % Example 1
% subplot(121);
% spiderPlot(Data)
% 
% % Example 2
% subplot(122);
% param.plotDots = false;
% param.superior = 90;
% param.inferior = 10;
% spiderPlot(Data,param)