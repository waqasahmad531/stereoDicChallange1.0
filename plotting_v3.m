% This version uses the same mean value that will be substracted from
% all the vendors based on the first vendor chosen. Benefit of this would
% be that we can compare the plots of different steps at different regions.
% 
clear all; close all; clc;
grewer = [310 311 312 313 314;
           320 321 322 323 324];
lava = [220 221 222 223 224;...%group 2 system 2 LAVA
            210 211 212 213 214];  %group 2 system 1
sandia = [115;125]; % Sandia 

vend = {lava,sandia,grewer};
cLimLo = zeros(18,4);
cLimHi = cLimLo;
cLimAvgLo = cLimLo;
cLimAvgHi = cLimLo;
meanval = cLimLo;
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
                    avgFlag = 1;
                    scale = 1;
                    rmnan = 1;
                    fileext = '.png';
                    for avgFlag = 1%0:1
                        if iFile > 1
                            rmnan = 1;
                        end
                        sbt = sprintf('Group %s,  %s, Sys : %g, Dataset : %s',groupID,appliedStep(iFile),sysNum,dataSet);
                        [stU,stV,stW,st] = post_statsPara(regGridData,iFile);
                        for disp = 1 : 4
                            if ven == 1 && grp == 1 && (iGroupNum == 1 || iGroupNum == 2)
                                storeLim = true;
                                if avgFlag == 0
                                    [fieldP,cLim] = post_plot_v2(regGridData,...
                                    rmnan,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    stU,stV,stW,[cLimLo(iFile,disp),cLimHi(iFile,disp)]);
                                    if iGroupNum ==  1
                                        cLimLo(iFile,disp) = cLim(1);
                                        cLimHi(iFile,disp) = cLim(2);
                                    end
                                    
                            
                                else
                                    
                                    [fieldP,cLim,meanval(iFile,disp)] = post_plot_v3(regGridData,meanval(iFile,disp),...
                                    rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                    stU,stV,stW,[cLimAvgLo(iFile,disp),cLimAvgHi(iFile,disp)]);
                                    if ven == 1 && iGroupNum ==  1
                                        cLimAvgLo(iFile,disp) = cLim(1);
                                        cLimAvgHi(iFile,disp) = cLim(2);
                                    end
                                    
                                end
                            
                           
                            elseif avgFlag == 0
                                 storeLim = false;

                                [fieldP,cLim] = post_plot_v2(regGridData,...
                                rmnan,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                stU,stV,stW,[cLimLo(iFile,disp),cLimHi(iFile,disp)]);
                            elseif avgFlag == 1
                                storeLim = false;
                                
                                [fieldP,cLim,meanval(iFile,disp)] = post_plot_v3(regGridData,meanval(iFile,disp),...
                                rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                                stU,stV,stW,[cLimAvgLo(iFile,disp),cLimAvgHi(iFile,disp)]);
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
                            clf;
                        end
                    end
                end        
            end
    end
end
