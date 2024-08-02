%%
% This version uses the same mean value that will be substracted from
% all the vendors based on the first vendor chosen. Benefit of this would
% be that we can compare the plots of different steps at different regions.
%
clear all; close all; clc;
format compact
lasFil = 'D:\DIC\LaserScan\laserScanRegDataGrid.mat';
lasData_0 = load(lasFil);
lasData = lasData_0(1).regGridData;
XX = lasData(:,:,1);
YY = lasData(:,:,2);
ZZ = lasData(:,:,3);

[finalMask,totalAoi] = scoringSytem(ZZ,1);
%%
dice = [115;125];
dantec = [210;220];
lavision = [310;320]; % LaVision
matchid = [410;420];
csi = [510;520];
grpid = [1,2,3,4,5];
vend = {dice,dantec,lavision,matchid,csi};
%% Removing hiden data from mesa corner
localMask = zeros(46,206);%finalMask(75:120,125:330);

for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER

    for grp = 1:size(sysgroups,1)
        groups = sysgroups(grp,:);
        for iGroupNum = 1:size(groups,2)
            groupNum = groups(iGroupNum);

            %Get the filenames for the test
            [fileNames, testDir, sysNum, baseDir,...
                appliedStep, dataSet, groupID, stepVals]=...
                                            DicDataFileNames_v3(groupNum);
            appliedStep = strrep(appliedStep,'=>',' : ');
            stepNames = strcat(fileNames,'_RegGrid.mat');

            maindir = fullfile(baseDir,testDir);
            frameNames = fullfile(maindir,stepNames);
            for iFile = 1:size(stepNames,1) %[16 17]%
                load(frameNames(iFile));
                zSubmitted = regGridData(:,:,3);
                z_selected = zSubmitted(75:120,125:330);
                localMask(z_selected==0) = 1;
                subplot(1,3,1)
                imshow(localMask,[-0.2,1])
                localMask(localMask~=0 & localMask~=1) = 0;
                subplot(1,3,2)
                imshow(localMask,[-0.2,1])
                
                finalMask(75:120,125:330) = localMask;
                subplot(1,3,3)
                imshow(finalMask,[-0.2,1])
                drawnow
            end

        end
    end
end
close all
%% Calculating euclidian distances of missing data
cntr = 0;
for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER

    for grp = 1:size(sysgroups,1)
        groups = sysgroups(grp,:);
        for iGroupNum = 1:size(groups,2)
            groupNum = groups(iGroupNum);

            %Get the filenames for the test
            [fileNames, testDir, sysNum, baseDir,...
                appliedStep, dataSet, groupID, stepVals]=...
                                            DicDataFileNames_v3(groupNum);
            appliedStep = strrep(appliedStep,'=>',' : ');
            stepNames = strcat(fileNames,'_RegGrid.mat');

            maindir = fullfile(baseDir,testDir);
            frameNames = fullfile(maindir,stepNames);
            for iFile = 1:size(stepNames,1) %[16 17]%
                cntr = cntr + 1;
                load(frameNames(iFile));
                zSubmitted = regGridData(:,:,3);
                temp = finalMask;
                tempScorer = bwdist(temp);
                finalScorer = zeros(size(finalMask));
                finalScorer(zSubmitted==0) = tempScorer(zSubmitted==0);
                finalScorer(~totalAoi) = 0;
                finalScorer(finalScorer==0) = NaN;
                p = pcolor(XX,YY,finalScorer);
                p.EdgeColor = 'None';
                colormap(parula(7));view(2);cb = colorbar;
                clim([0 35])
                axis ij equal tight
                xlim([XX(53,53),XX(552,552)])
                ylim([XX(53,53),XX(552,552)])
                set(gcf,'color','w')
                set(gca,'FontSize',12)
                xlabel("X[mm]",'Interpreter','latex')
                ylabel("Y[mm]",'Interpreter','latex')
                colorTitleHandle = get(cb,'Title');
                set(colorTitleHandle ,'String',...
                    "Euclidean distance (Units: pixels)",...
                                                'Interpreter','latex');
                set(colorTitleHandle,"Rotation",270,'FontSize',12)
                set(colorTitleHandle,'HorizontalAlignment','left')
                set(colorTitleHandle,'VerticalAlignment','baseline')
                set(colorTitleHandle,'Position',[36.5 222,0])
                maximumCoverage(ven,grp,iFile) = ...
                    100*numel(zSubmitted(zSubmitted~=0))/numel(totalAoi(totalAoi==1));

                drawnow
%                 fprintf("Total points %d \n",numel(finalScorer))
                rmsVals(ven,grp,iFile) = rms(finalScorer,'all','omitnan'); %sum(finalScorer,"all","omitnan")./numel(finalScorer);%
                if (ven==3 && grp == 2 && iFile == 1) || ...
                                (ven == 2 && grp == 1 && iFile == 15)
                    "ruk yahan";
                end
            end

        end
    end
end

for i = 1:5
    for j = 1:2
        meanScores(i,j) = mean(rmsVals(i,j,:));
    end
end

[minC,mincId] = min(maximumCoverage,[],3);
[maxC,maxcId] = max(maximumCoverage,[],3);
[minVals,minId] = min(rmsVals,[],3);
[maxVals,maxId] = max(rmsVals,[],3);
