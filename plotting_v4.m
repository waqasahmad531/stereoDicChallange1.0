% This version uses the same mean value that will be substracted from
% all the vendors based on the first vendor chosen. Benefit of this would
% be that we can compare the plots of different steps at different regions.
% 
clear all; close all; clc;

grewer = [314;
           324];
lava = [214;...%group 2 system 2 LAVA
            224];  %group 2 system 1
sandia = [115;...
            125]; % Sandia 

vend = {lava,sandia,grewer};

% Change in this version to find the minimum area for each frame.
for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER

    for grp = 1:size(sysgroups,1)
        groups = sysgroups(grp,:);
            for iGroupNum = 1:size(groups,2)
                groupNum = groups(iGroupNum);
    
                %Get the filenames for the test
                [fileNames, testDir,~, baseDir]=DicDataFileNames(groupNum);  
%                 appliedStep = strrep(appliedStep,'=>',' : ');
                stepNames = strcat(fileNames,'_RegGrid.mat');
        
                maindir = fullfile(baseDir,testDir);
                frameNames = fullfile(maindir,stepNames);
                stepFiles{ven,grp,iGroupNum} = frameNames;
                for iFile = 1:18
                    load(frameNames(iFile))
                    Z = regGridData(:,:,3);
                    Znums(iFile,grp) =sum(Z(:)~=0);
                    if ven==3 && grp==2
                        Znums(iFile,grp) = NaN;
                    end
                end          
            end
            
    end
     Znum{ven} = Znums;
end
Zt = [];
for iGr = 1:length(Znum)
    temp = Znum{iGr};
    Zt = [Zt,temp];
end

[~,idx] = min(Zt,[],2,'omitnan');
venInd = ceil(idx/2);
% Z = NaN(size(regGridData(:,:,3)));
%%




% grewer = [310 311 312 313 314;
%            320 321 322 323 324];
% lava = [220 221 222 223 224;...%group 2 system 2 LAVA
%             210 211 212 213 214];  %group 2 system 1
% sandia = [115;125]; % Sandia 
% 
% vend = {lava,sandia,grewer};

%% Same as version 3

vend = {lava,sandia,grewer};
cLimLo = zeros(18,4);
cLimHi = cLimLo;
cLimAvgLo = cLimLo;
cLimAvgHi = cLimLo;
meanval = cLimLo;
fixedmean = false;
for ven = 1: length(vend)
    sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER

    for grp = 1:size(sysgroups,1)
        groups = sysgroups(grp,:);
            for iGroupNum = 1:size(groups,2)
                groupNum = groups(iGroupNum);
    
                %Get the filenames for the test
                [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(groupNum);  
                appliedStep = strrep(appliedStep,'=>',' : ');
                stepNames = strcat(fileNames,'_RegGrid.mat');
        
                maindir = fullfile(baseDir,testDir);
                frameNames = fullfile(maindir,stepNames);
                for iFile = 1:size(stepNames,1)
                    
                    
                   
                    
                    
                    load(frameNames(iFile));
                    Z = regGridData(:,:,3);
                    
                     %%FOR VERSION 4
                    if mod(idx(iFile),2)==1
                        sfloc = 1;
                    elseif mod(idx(iFile),2) == 0
                        sfloc = 2;
                    end
                    
                    for iv = 1:size(stepFiles,1)
                        for isys = 1: size(stepFiles,2)
                            idxfile = stepFiles{iv,isys};
                            if iv~=3 || isys~=2
                                load(idxfile(iFile))
                                zz = regGridData(:,:,3);
                                Z(zz==0) = 0;
%                                 sum(Z(:)~=0)
                            end
                        end
                    end
                    
                    load(frameNames(iFile));
                    
%                     idxfile = stepFiles{venInd(iFile),sfloc};
%                     load(idxfile(iFile))
%                     Z = regGridData(:,:,3);
%                     
                    %%FOR VERSION 4
                    

                    
                    avgFlag = 1;
                    scale = 1;
                    rmnan = 1;
                    fileext = '.pdf';
                    for avgFlag = 1
                        if iFile > 1
                            rmnan = 1;
                        end
                        sbt = sprintf('Group %s,  %s, Sys : %g, Dataset : %s',groupID,appliedStep(iFile),sysNum,dataSet);
                        [stU,stV,stW,st] = post_statsPara(regGridData,iFile);
                        for disp = 1 : 4
                            if ven == 1 && grp == 1 && (iGroupNum == 1 || iGroupNum == 2)
                                storeLim = true;
                                if avgFlag == 0
                                    [fieldP,cLim,meanval(iFile,disp)] = post_plot_v4(regGridData,Z,meanval(iFile,disp),...
                                    rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    stU,stV,stW,[cLimLo(iFile,disp),cLimHi(iFile,disp)],fixedmean);
                                    if iGroupNum ==  1
                                        cLimLo(iFile,disp) = cLim(1);
                                        cLimHi(iFile,disp) = cLim(2);
                                    end
                                    
                            
                                else
                                    
                                    [fieldP,cLim,meanval(iFile,disp),stat] = post_plot_v4(regGridData,Z,meanval(iFile,disp),...
                                    rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    stU,stV,stW,[cLimAvgLo(iFile,disp),cLimAvgHi(iFile,disp)],fixedmean);
                                    if ven == 1 && iGroupNum ==  1
                                        cLimAvgLo(iFile,disp) = cLim(1);
                                        cLimAvgHi(iFile,disp) = cLim(2);
                                    end
                                    
                                end
                            
                           
                            elseif avgFlag == 0
                                 storeLim = false;

                                [fieldP,cLim,meanval(iFile,disp)] = post_plot_v4(regGridData,Z,meanval(iFile,disp),...
                                    rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    stU,stV,stW,[cLimLo(iFile,disp),cLimHi(iFile,disp)],fixedmean);
                            elseif avgFlag == 1
                                storeLim = false;
                                
                                [fieldP,cLim,meanval(iFile,disp),stat] = post_plot_v4(regGridData,Z,meanval(iFile,disp),...
                                rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                stU,stV,stW,[cLimAvgLo(iFile,disp),cLimAvgHi(iFile,disp)],fixedmean);
                            end
%                            [fieldP,cLim,ax,ax1,cb] = post_plot_v2(regGridData,...
%                                 rmnan,sbt,disp,maindir,avgFlag,storeLim,fileext,...
%                                 stU,stV,stW);
%                             
%                             [fieldP,cLim,ax,ax1,cb] = post_plot_v2(regGridData,...
%                                 rmnan,sbt,disp,maindir,avgFlag,storeLim,fileext,...
%                                 stU,stV,stW);
%                             export_fig(fieldP,'-m1.5')
                            
%                             fig = gcf;
%                             fig.CurrentAxes = ax;
%                             if avgFlag == 0
%                                
%                                 caxis([cLimLo(iFile,disp),cLimHi(iFile,disp)])
%                             else
%                                 caxis([cLimAvgLo(iFile,disp),cLimAvgHi(iFile,disp)])
%                             end
                               
                            exportgraphics(gcf,fieldP,'Resolution',600) %U Disp
                            stepStat(disp,:) = stat'; 
                            clf;
                        end
                    end
                    filestat{iFile} = stepStat;
                end  
                meanPerFrame{ven,grp,iGroupNum} = filestat;
            end
    end
end

steps = [0 0 0; 0 0 -10; 0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0; -10 0 0;
-20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10; 20 0 -20; -10 0 10;
-20 0 20; 0 0 0];

stepmeandir = strcat(baseDir,'stepsdMeanData.mat');
save(stepmeandir,'meanPerFrame','steps')
