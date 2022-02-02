
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
outputfile = 'D:\DIC\Statistics Radar';
venNum = [4,5,6];
load(meandir)
steps(:,4) = sqrt(steps(:,1).^2 + steps(:,2).^2 + steps(:,3).^2);
steps = steps';
rng(5)
fileFor = 'pdf';
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
      
              end  

            end

        end

    end
    

end

close all;


d1 = squeeze(sd_m(1,1,:));
d2 = squeeze(sd_m(2,1,:));
d3 = squeeze(sd_m(3,1,:));
P = [d1,d2,d3]';

d1s = squeeze(sdd_std(1,1,:));
d2s = squeeze(sdd_std(2,1,:));
d3s = squeeze(sdd_std(3,1,:));
Ps = [d1s,d2s,d3s]';

p = [1 2 3 6 7 10 11 14 15 18 4 5 8 9 12 13 16 17 ];
% minl = min(P(1,p)); maxl = max(P(1,p));
minl = min(P(:)); maxl = max(P(:));
axl = [repmat(-max([abs([minl,maxl])]),1,18);
    repmat(max([abs([minl,maxl])]),1,18)];
figure(1)


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
'FillTransparency', [0.01 0.05 0.075]);
title('Abs($U_{stage}-U_{DIC}$)','Interpreter','latex')

lgd = legend('4 (sys:1)','5 (sys:1)','6 (sys:1)');
       htitle = get(lgd,'Title');
       set(htitle,'String','Participant:','FontSize',14)
       lgd.Location = 'best';
       lgd.Interpreter = 'latex';
       lgd.FontSize = 13;
       lgd.Box = 'off';


%%
figure(2)
p = [1 2 3 6 7 10 11 14 15 18 4 5 8 9 12 13 16 17 ];



minl = min(abs(Ps(:))); maxl = max(Ps(:));
axl = [repmat(minl,1,18);repmat(maxl,1,18)];

spider_plot(abs(Ps(:,p)),...
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
'FillTransparency', [0.01 0.05 0.075]);
title('Standard Deviation of ($U_{DIC}$)','Interpreter','latex')

lgd = legend('4 (sys:1)','5 (sys:1)','6 (sys:1)');
       htitle = get(lgd,'Title');
       set(htitle,'String','Participant:','FontSize',14)
       lgd.Location = 'best';
       lgd.Interpreter = 'latex';
       lgd.FontSize = 13;
       lgd.Box = 'off';

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