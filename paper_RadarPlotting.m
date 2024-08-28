
clc;clearvars;close all;
di =[115;125]; %[115 115 115 115 115;...
%             125 125 125 125 125];
dan = [211;221];
lav = [311;321];
mid = [411;421];
csi = [511;521];
vend = {di,dan,lav,mid,csi};

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
linPro = "-.";%,"-.","-."];
linclr = [0.8500 0.3250 0.0980;
    0 0.4470 0.7410;
    0.9290 0.6940 0.1250;
    0.4940 0.1840 0.5560;
    0.6350 0.0780 0.1840;
    0.4660 0.6740 0.1880];
marker = ["o","s","d","<",">"];
dispVar = ["U","V","W","A"];
meandir = 'J:\DIC\stepsdMeanData7a.mat';
outputfile = 'J:\DIC\Statistics Radar4';
venNum = [4,5,6,7];
load(meandir)
steps(4,:) = sqrt(steps(1,:).^2 + steps(2,:).^2 + steps(3,:).^2);
% steps = steps';
rng(5)
fileFor = 'eps';
% fig = figure("Position",[481.8,166.2,566.2,595.8],'Color','w');
fig = figure("Position",[475.4,159.8,579.2,579.2],'Color','w');

absType = false;

data = wa_spiderPlotRanges(meanPerFrame,vend,steps,absType);



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
                curMark = marker(vn);
                mpfvg = squeeze(meanPerFrame(vn,iSys,:)); %number of datasets
                temp = mpfvg{iDataset}; %frames
                meanData = squeeze(temp(:,1,:));
                stdData = squeeze(temp(:,2,:));
                minData = squeeze(temp(:,3,:));
                maxData = squeeze(temp(:,4,:));
                meanDif = meanData-steps;
                sd_m(vn,:) = 1000*meanDif(disp,:);
                sdd_std(vn,:) = 1000*stdData(disp,:);
            end
            clf;
            statsSpiderPlot(sd_m,meanMinL,meanMaxL,stdMaxL,absType);
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
            set(htitle,'String','Group:','FontSize',14)
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

            statsSpiderPlotStd(sdd_std,stdMinL,stdMaxL,absType);
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
            set(htitle,'String','Group:','FontSize',14)
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

