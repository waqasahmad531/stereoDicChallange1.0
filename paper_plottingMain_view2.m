close all;
dirFolder = "\\teamwork.org.aalto.fi\T20403-IceFrac\1.0 StereoDIC Challenge Project\DIC";
testingDir = fullfile(dirFolder,"testing");
lasFil = fullfile(dirFolder,'\LaserScan\laserScanRegDataGrid.mat');
lasData_0 = load(lasFil);
lasData = lasData_0(1).regGridData;
lincutLoc = -30;
XX = lasData(:,:,1);
YY = lasData(:,:,2);
ZZ = lasData(:,:,3);
ZZ(ZZ==0) = NaN;
xVal = XX(:,1);
xLen = 1:size(ZZ,1);
ax = surf(XX,YY,ZZ); colormap(parula(50)); %caxis([30 50])
colorbar
ax.LineStyle = 'none';ax.EdgeColor = 'flat';
ax.FaceColor = 'flat';
ax.FaceAlpha = 0.5;
axis tight
axis equal
set(gcf,'color','w')
grid off
%%
figure(2)
plot(xVal,ZZ(xLen(xVal==lincutLoc),:),'r','LineWidth',1);
figure(3)
plot(xVal,ZZ(xLen(xVal==lincutLoc),:),'r','LineWidth',1);
%%
testing = [610;...
    620];
grpid = 6;%[1,2,3,4,5];
vend = {testing};

%% Number of plots for legend
grpdataset = 0;
for ven = 1:length(vend)
    sysgroups = vend{ven};
    for sys = 1%:size(sysgroups,1)
        groups = sysgroups(sys,:);
        grpdataset = grpdataset + length(groups);
    end
end

%%
linclr = turbo(grpdataset);
linPro = "-.";%,"-.","-."];
linThi = linspace(1.5,1,length(vend));%[2.5,1.5,1];
venc = 0;
cmplgd = 'Laser';
cmplgd2 = 'Laser';
cmplgdDiff1 = [];
cmplgdDiff2 = [];
% dispFields = cell(2,3);
% Change in this version to find the minimum area for each frame.
clrcount = 0;

for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];
    venc = venc + 1;
    recColor = zeros(size(sysgroups,2),3);
    for sys = 1:size(sysgroups,1)
        gr1c = 0;
        gr2c = 0;
        groups = sysgroups(sys,:);
        for iGroupNum = 1:size(groups,2)
            if sys==2
                gr2c = gr2c + 1;
            end

            groupNum = groups(iGroupNum);
            %Get the filenames for the test
            [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(testingDir,groupNum);
            appliedStep = strrep(appliedStep,'=>',' : ');
            stepNames = strcat(fileNames,'_RegGrid.mat');
            frameNames = fullfile(testDir,stepNames);
            stepFiles{ven,sys,iGroupNum} = frameNames;
            u = zeros(601,601,18);
            v = u;
            w = u;
            for iFile = 17
                load(frameNames(iFile))
                X = regGridData(:,:,1);
                Y = regGridData(:,:,2);
                Z = regGridData(:,:,3);
                U = regGridData(:,:,4);
                V = regGridData(:,:,5);
                W = regGridData(:,:,6);
                Z(U==0) = NaN;
                u(:,:,iFile) = U;
                v(:,:,iFile) = V;
                w(:,:,iFile) = W;
                Znums(iFile,sys) =sum(Z(:)~=0);
            end
            dispFieldsU{ven,sys,iGroupNum} = u;
            dispFieldsV{ven,sys,iGroupNum} = v;
            dispFieldsW{ven,sys,iGroupNum} = w;

            if sys == 1
                gr1c = gr1c + 1;
                figure(2)
                hold on
                clrcount = clrcount + 1;
                plot(xVal,Z(xLen(xVal==lincutLoc),:),linPro,'Color',linclr(clrcount,:),'LineWidth',linThi(venc));
                ylim([-0.2 7])
                lgstr = sprintf('Gr: %g',grpid(ven));
                cmplgd = [cmplgd,string(lgstr)];
                recColor(gr1c,:) = linclr(clrcount,:);

                figure(4)
                hold on
                plot(xVal,(Z(xLen(xVal==lincutLoc),:)-ZZ(xLen(xVal==lincutLoc),:))*1e3,linPro,'Color',linclr(clrcount,:),'LineWidth',linThi(venc));
                lgstr = sprintf('Gr: %g',grpid(ven));
                cmplgdDiff1 = [cmplgdDiff1,string(lgstr)];
                recColor(gr1c,:) = linclr(clrcount,:);
            elseif sys == 2
                figure(3)
                hold on

                plot(xVal,Z(xLen(xVal==lincutLoc),:),linPro,'Color',recColor(gr2c,:),'LineWidth',linThi(venc));
                ylim([-0.2 7])
                lgstr = sprintf('Gr: %g',grpid(ven));
                cmplgd2 = [cmplgd2,string(lgstr)];

                figure(5)
                hold on
                plot(xVal,(Z(xLen(xVal==lincutLoc),:)-ZZ(xLen(xVal==lincutLoc),:))*1e3,linPro,'Color',linclr(clrcount,:),'LineWidth',linThi(venc));

                lgstr = sprintf('Gr: %g',grpid(ven));
                cmplgdDiff2 = [cmplgdDiff2,string(lgstr)];
            end
        end
    end
    Znum{ven} = Znums;

end
%%
figure(2)
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,501.5]);

lgd = legend(cmplgd);
% lgd = legend('Laser','Group: 1','Group: 2', 'Group: 3');
lgd.Interpreter = 'latex';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
ylabel('Plate features dimension (mm)','Interpreter','latex','FontSize',12)
title('Features comparison b/w DIC and laser scan (35mm lens)','Interpreter','latex','FontSize',13)
fieldP = fullfile(dirFolder,"LineCuts\lineCutSys12.eps");
% exportgraphics(gcf,fieldP,'Resolution',600) %U Disp

figure(3)
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,501.5]);

lgd = legend(cmplgd2);
% lgd = legend('Laser','Group: 1','Group: 2');
lgd.Interpreter = 'latex';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
ylabel('Plate features dimension (mm)','Interpreter','latex','FontSize',12)
title('Features comparison b/w DIC and laser scan (16mm lens)','Interpreter','latex','FontSize',13)
fieldP = fullfile(dirFolder,"LineCuts\lineCutSys22.eps");
% exportgraphics(gcf,fieldP,'Resolution',600) %U Disp

figure(4)
box on; grid on
ylim([-175 175])
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,501.5]);

lgd = legend(cmplgdDiff1);
% lgd = legend('Laser','Group: 1','Group: 2');
lgd.Interpreter = 'latex';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
ylabel('Features difference($\mu$m)','Interpreter','latex','FontSize',12)
title('Difference b/w laser scan and DIC (35mm lens)','Interpreter','latex','FontSize',14)
fieldP = fullfile(dirFolder,"LineCuts\lineCutSys1df2.eps");
% exportgraphics(gcf,fieldP,'Resolution',600) %U Disp

figure(5)
ylim([-175 175])
box on; grid on
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,501.5]);

lgd = legend(cmplgdDiff2);
% lgd = legend('Laser','Group: 1','Group: 2');
lgd.Interpreter = 'latex';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
ylabel('Features difference($\mu$m)','Interpreter','latex','FontSize',12)
title('Difference b/w laser scan and DIC (16mm lens)','Interpreter','latex','FontSize',14)
fieldP = fullfile(dirFolder,"LineCuts\lineCutSys2df2.eps");
% exportgraphics(gcf,fieldP,'Resolution',600) %U Disp


Zt = [];
for iGr = 1:length(Znum)
    temp = Znum{iGr};
    Zt = [Zt,temp];
end

[~,idx] = min(Zt,[],2,'omitnan');
venInd = ceil(idx/2);
%%
grpid = [6];
vend = {testing};
%% New Version
participants = [];
% vend = {lava,sandia,grewer};
% vend = {matchid};
cLimLo = zeros(18,4);
cLimHi = cLimLo;
cLimAvgLo = cLimLo;
cLimAvgHi = cLimLo;
meanvalB = zeros(18,4,length(vend));
fixedmean = false;
for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER

    for sys = 1:size(sysgroups,1)
        groups = sysgroups(sys,:);
        for iGroupNum = 1:size(groups,2)
            groupNum = groups(iGroupNum);

            %Get the filenames for the test
            [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(testingDir,groupNum);
            appliedStep = strrep(appliedStep,'=>',' : ');
            stepNames = strcat(fileNames,'_RegGrid.mat');

            % maindir = fullfile(baseDir,testDir);
            frameNames = fullfile(testDir,stepNames);
            for iFile = 1:size(stepNames,1)
                countr = 0;
                if ven == 1 && sys == 1 && iGroupNum == 1  && iFile == 1
                    load(frameNames(iFile));
                    Z = regGridData(:,:,3);
                    for iven = 1:size(stepFiles,1)
                        for isys = 1: size(stepFiles,2)
                            for idatset = 1:size(stepFiles,3)
                                idxfile = stepFiles{iven,isys,idatset};
                                for file = 1:18
                                    load(idxfile(file))
                                    zz = regGridData(:,:,3);
                                    Z(zz==0) = 0;
                                    countr = countr + 1;
                                end
                            end
                        end
                    end
                end

                load(frameNames(iFile));
                avgFlag = 1;
                scale = 1;
                rmnan = 1;
                fileext = '.pdf';
                pltflag = false;
                for avgFlag = 1
                    if iFile > 1
                        rmnan = 1;
                    end
                    sbt = sprintf('Group %s,  %s, Sys : %g, Dataset : %s',groupID,appliedStep(iFile),sysNum,dataSet);
                    [stU,stV,stW,st] = post_statsPara(regGridData,iFile);
                    clc
                    for disp = 1 : 4
                        storeLim = true;
                        if avgFlag == 0
                            [cLim,meanvalB(iFile,disp,ven)] = colorbarLims(regGridData,Z,meanvalB(iFile,disp,ven),...
                                rmnan,iGroupNum,disp,avgFlag,storeLim,...
                                fixedmean);
                            cLimLo(iFile,disp) = cLim(1);
                            cLimHi(iFile,disp) = cLim(2);
                        else

                            [cLim,meanvalB(iFile,disp,ven),stat,tmean] = colorbarLims(regGridData,Z,meanvalB(iFile,disp,ven),...
                                rmnan,iGroupNum,disp,avgFlag,storeLim,...
                                fixedmean);
                            cLimAvgLo(iFile,disp) = cLim(1);
                            cLimAvgHi(iFile,disp) = cLim(2);
                        end
                        stepStat(disp,:) = stat';
                    end
                end
                filestat(1:4,1:4,iFile) = stepStat;
            end
            climAL{ven,sys,iGroupNum} = cLimAvgLo;
            climAH{ven,sys,iGroupNum} = cLimAvgHi;
            meanPerFrame{ven,sys,iGroupNum} = filestat;
        end
    end
end

% Transforming from stage coordinates to plate coordinates.
% Results in [Xn,Yn,Zn,1] matching [U,V,W,1]
steps = [0 0 0; 0 0 -10; 0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0; -10 0 0;
    -20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10; 20 0 -20; -10 0 10;
    -20 0 20; 0 0 0];

alpha = -0.0001;
beta = -0.0099;
gamma = -0.0042;

rotx = [1,0,0;0,cos(alpha),-sin(alpha);0,sin(alpha),cos(alpha)];
roty = [cos(beta),0,sin(beta);0,1,0;-sin(beta),0,cos(beta)];
rotz = [cos(gamma),-sin(gamma),0;sin(gamma),cos(gamma),0;0,0,1];
rot = rotx*roty*rotz;

plateMovement = rot\steps';
steps = plateMovement;

%% Fixed Limit
close all;

%% Limits for table
nSys = size(sysgroups,1);
nGrps = size(sysgroups,2);
nVens = length(vend);
abcH = zeros(18,4,nSys*nGrps*nVens);
abcL = zeros(18,4,nSys*nGrps*nVens);
% climAL;
cntr = 1;
for iven = 1:length(vend)
    for isys=1:2
        for igrp = 1:size(groups,2)

            abcH(:,:,cntr) = cell2mat(climAH(iven,isys,igrp));
            abcL(:,:,cntr) = cell2mat(climAL(iven,isys,igrp));
            cntr = cntr + 1;
        end
    end
end

%%
meanval = zeros(18,4);
fixedmean = false;
for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];

    for sys = 1:size(sysgroups,1)
        groups = sysgroups(sys,:);
        for iGroupNum = 1:size(groups,2)
            groupNum = groups(iGroupNum);

            %Get the filenames for the test
            [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(testingDir,groupNum);
                appliedStep = strrep(appliedStep,'=>',' : ');
                stepNames = strcat(fileNames,'_RegGrid.mat');

                % maindir = fullfile(baseDir,testDir);
                frameNames = fullfile(testDir,stepNames);

            for iFile = 1:size(stepNames,1)
                %giving displacement values
                %for a particular frame for all the vendors and datasets and
                %both systems
                tmpH = squeeze(abcH(iFile,:,:));
                tmpL = squeeze(abcL(iFile,:,:));
                cLimHM = max(tmpH,[],2)';
                cLimLM = min(tmpL,[],2)';

                load(frameNames(iFile));

                avgFlag = 1;
                scale = 1;
                rmnan = 1;
                pltflag = true;
                fileext = '.pdf';
                for avgFlag = 1
                    if iFile > 1
                        rmnan = 1;
                    end
                    sbt = sprintf('Group %s,  %s, Sys : %g, Dataset : %s',groupID,appliedStep(iFile),sysNum,dataSet);
                    [stU,stV,stW,st] = post_statsPara(regGridData,iFile);
                    for disp = 1 : 4
                        if ven == 1 && sys == 1 && (iGroupNum == 1 || iGroupNum == 2)
                            if avgFlag == 0
                                [fieldP,cLim,meanval(iFile,disp)] = fieldsAndResidualPlots(regGridData,Z,meanval(iFile,disp),...
                                    rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    [cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag,"miniAOI(view2)");
                            else
                                [fieldP,cLim,meanval(iFile,disp),stat] = fieldsAndResidualPlots(regGridData,Z,meanval(iFile,disp),...
                                    rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    [cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag,"miniAOI(view2)");
                            end

                        elseif avgFlag == 0
                            storeLim = false;
                            [fieldP,cLim,meanval(iFile,disp)] = fieldsAndResidualPlots(regGridData,Z,meanval(iFile,disp),...
                                rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                [cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag,"miniAOI(view2)");
                        elseif avgFlag == 1
                            storeLim = false;
                            [fieldP,cLim,meanval(iFile,disp),stat] = fieldsAndResidualPlots(regGridData,Z,meanval(iFile,disp),...
                                rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                [cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag,"miniAOI(view2)");
                        end
                        drawnow
                        % exportgraphics(gcf,fieldP,'Resolution',600) %U Disp
                        stepStat(disp,:) = stat';
                        clf;
                    end
                end
            end
        end
    end
end

%%
gcf
fv = ["U","V","W","A"];
close all;
grpid = [1,2,3,4,5];
for iFile = 1:18

    tmpH = squeeze(abcH(iFile,:,:));
    tmpL = squeeze(abcL(iFile,:,:));
    cLimHM = max(tmpH,[],2)';
    cLimLM = min(tmpL,[],2)';
    for cm = 1:4
        fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
            'Outerposition',[0.152,0.1644,0.5021,0.7625]);
        cb = colorbar;
        colormap((hsv(20)))
        if cLimLM(cm) ~= cLimHM(cm)
            clim([cLimLM(cm),cLimHM(cm)])
        else
            clim('auto')
        end
        set(gca,'Visible','off');
        cb.Title.String = '[\mum]';
        cb.TickLabelInterpreter = 'latex';
        cb.FontSize = 13;
        cb.Title.FontSize = 13;
        cb.Title.HorizontalAlignment = 'center';

        mfloc = strfind(fieldP,'\');
        figfold = mfloc(end)-1;
        tm = fullfile(dirFolder,"colorbar\vertical");
        figfin = tm;
        clbr = sprintf('Step%02dd%s%s',iFile,fv(cm),fileext);
        clbrfile = fullfile(figfin,clbr);
        drawnow;
        % exportgraphics(gcf,clbrfile,'Resolution',600) %U Disp
        clf
    end
end

stepmeandir = strcat(baseDir,'stepsdMeanDataTesting_b.mat');
save(stepmeandir,'meanPerFrame','steps')
