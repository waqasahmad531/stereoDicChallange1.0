% This version uses the same mean value that will be substracted from
% all the vendors based on the first vendor chosen. Benefit of this would
% be that we can compare the plots of different steps at different regions.
% 
% clear all; close all; clc;
close all
lasFil = 'D:\DIC\LaserScan\laserScanRegDataGrid.mat';
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
% % grewer = [310,311,312;...
% %            320,321,322];
% % lava = [210,211,212;...%group 2 system 2 LAVA
% %             220,221,222];  %group 2 system 1
% % sandia = [115;...
% %             125]; % Sandia 
% dice = [115 115 115 115 115;...
%         125 125 125 125 125];
% dantec = [210 211 212 213 214;...
%                220 221 222 223 224]; %group 3 system1 and 2 Dantec 
% % matchID = [610];
% lavision = [310,311,312 313 314;...
%                320,321 322 323 324]; % LaVision
% matchid = [410 411 412 413 414;...
%             420 421 422 423 424];
% csi = [510 511 512 513 514; %CSI
%              520 521 522 523 524];
grpid = [1,2,3,4,5];

 vend = {dice,dantec,lavision,matchid,csi};
% vend = {matchID};

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

linclr = turbo(grpdataset);%parula(length(vend));
% linclr = [0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250];
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
    sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER
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
%     if ven == 4 && sys == 2 && iGroupNum == 5
%         "yahan par ruk"
%     end
                %Get the filenames for the test
                [fileNames, testDir,~, baseDir]=DicDataFileNames_v3(groupNum);  
%                 appliedStep = strrep(appliedStep,'=>',' : ');
                stepNames = strcat(fileNames,'_RegGrid.mat');
        
                maindir = fullfile(baseDir,testDir);
                frameNames = fullfile(maindir,stepNames);
                stepFiles{ven,sys,iGroupNum} = frameNames;
                u = zeros(601,601,18);
                v = u;
                w = u;
                for iFile = 13
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
%                     if ven==3 && grp==2
%                         Znums(iFile,grp) = NaN;
%                     end
%                     
                end  
                dispFieldsU{ven,sys,iGroupNum} = u;
                dispFieldsV{ven,sys,iGroupNum} = v;
                dispFieldsW{ven,sys,iGroupNum} = w;
%                 if ven==3
%                     teranaam = 'waqas';
%                 end
%                 if ~(ven == 3 && grp == 2)
                    if sys == 1
                        gr1c = gr1c + 1;
                        figure(2)
                        hold on 
                        clrcount = clrcount + 1;  
                        plot(xVal,Z(xLen(xVal==lincutLoc),:),linPro,'Color',linclr(clrcount,:),'LineWidth',linThi(venc));
                        ylim([-0.2 7])
%                         axis equal
                        lgstr = sprintf('Gr: %g-%g',grpid(ven),iGroupNum-1);
                        cmplgd = [cmplgd,string(lgstr)];
                        recColor(gr1c,:) = linclr(clrcount,:);

                        figure(4)
                        hold on 
%                         clrcount = clrcount + 1;  
                        plot(xVal,(Z(xLen(xVal==lincutLoc),:)-ZZ(xLen(xVal==lincutLoc),:))*1e3,linPro,'Color',linclr(clrcount,:),'LineWidth',linThi(venc));
%                         ylim([-0.2 7])
%                         axis equal
                        lgstr = sprintf('Gr: %g-%g',grpid(ven),iGroupNum-1);
                        cmplgdDiff1 = [cmplgdDiff1,string(lgstr)];
                        recColor(gr1c,:) = linclr(clrcount,:);




                    elseif sys == 2
                        figure(3)
                        hold on 
                        
                        plot(xVal,Z(xLen(xVal==lincutLoc),:),linPro,'Color',recColor(gr2c,:),'LineWidth',linThi(venc));
                        ylim([-0.2 7])
                        lgstr = sprintf('Gr: %g-%g',grpid(ven),iGroupNum-1);
                        cmplgd2 = [cmplgd2,string(lgstr)];

                        figure(5)
                        hold on 
%                         clrcount = clrcount + 1;  
                        plot(xVal,(Z(xLen(xVal==lincutLoc),:)-ZZ(xLen(xVal==lincutLoc),:))*1e3,linPro,'Color',linclr(clrcount,:),'LineWidth',linThi(venc));
%                         ylim([-0.2 7])
%                         axis equal
                        lgstr = sprintf('Gr: %g-%g',grpid(ven),iGroupNum-1);
                        cmplgdDiff2 = [cmplgdDiff2,string(lgstr)];
                        %recColor(gr1c,:) = linclr(clrcount,:);
%                         clrcount
%                         axis equal
                    end
%                   clrcount = clrcount + 1;  
                    
%                     hold on 
%                     plot(xVal,Z(xLen(xVal==lincutLoc),:),linPro(venc),'LineWidth',1);
%                 end
%                 lgstr = sprintf('Gr: %g- S%g(%g)',ven,grp,iGroupNum);
%  cmplgd = [cmplgd,string(lgstr)];
            end
            
             
    end
     Znum{ven} = Znums;
   
end
%%
figure(2)
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,341.6]);
set(gcf,'InnerPosition',[295,333,655,184.8])

lgd = legend(cmplgd);
% lgd = legend('Laser','Group: 1','Group: 2', 'Group: 3');
lgd.Interpreter = 'latex';
% lgd.Orientation = 'horizontal';
% lgd.NumColumns = 2;
lgd.Box = 'off';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
% ylabel('Features dimension (mm)','Interpreter','latex','FontSize',12)
ylabel('[mm]','Interpreter','latex','FontSize',12)
%title('Features comparison b/w DIC and laser scan (35mm lens)','Interpreter','latex','FontSize',13)
fieldP = "D:\DIC\LineCuts\lineCutSys12.eps";
set(gca,'XTick',-50:25:50); grid off; 
% set(gca,'YTick',[0,6])
% axis equal tight
exportgraphics(gcf,fieldP,'Resolution',600) %U Disp

figure(3)
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,341.6]);%245,335.8,809.5999999999999,341.6000000000001
set(gcf,'InnerPosition',[295,333,655,184.8])
lgd = legend(cmplgd2);
% lgd = legend('Laser','Group: 1','Group: 2');
lgd.Interpreter = 'latex';
lgd.Box = 'off';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
% ylabel('Features dimension (mm)','Interpreter','latex','FontSize',12)
ylabel('[mm]','Interpreter','latex','FontSize',12)
%title('Features comparison b/w DIC and laser scan (16mm lens)','Interpreter','latex','FontSize',13)
fieldP = "D:\DIC\LineCuts\lineCutSys22.eps";
set(gca,'XTick',-50:25:50); grid off;%legend('off')
exportgraphics(gcf,fieldP,'Resolution',600) %U Disp

figure(4)
box on; grid on
 ylim([-175 175])
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,501.5]);
set(gcf,'InnerPosition',[234.6,342,715.4000000000001,348.2])
lgd = legend(cmplgdDiff1);
lgd.Box = 'off';
% lgd = legend('Laser','Group: 1','Group: 2');
lgd.Interpreter = 'latex';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
ylabel('Features difference($\mu$m)','Interpreter','latex','FontSize',12)
%title('Difference b/w laser scan and DIC (35mm lens)','Interpreter','latex','FontSize',14)
fieldP = "D:\DIC\LineCuts\lineCutSys1df2.eps";
set(gca,'XTick',-50:25:50); grid off;
exportgraphics(gcf,fieldP,'Resolution',600) %U Disp

figure(5)
 ylim([-175 175])
box on; grid on
set(gcf,'color','w')
set(gcf,'OuterPosition',[245,335.8,809.6,501.5]);
set(gcf,'InnerPosition',[234.6,342,715.4000000000001,348.2])
lgd = legend(cmplgdDiff2);
% lgd = legend('Laser','Group: 1','Group: 2');
lgd.Interpreter = 'latex';
lgd.Box = 'off';
lgd.Location = 'northwest';%'best';%'eastoutside';
xlabel('Y-axis','Interpreter','latex','FontSize',12)
ylabel('Features difference($\mu$m)','Interpreter','latex','FontSize',12)
%title('Difference b/w laser scan and DIC (16mm lens)','Interpreter','latex','FontSize',14)
fieldP = "D:\DIC\LineCuts\lineCutSys2df2.eps";
set(gca,'XTick',-50:25:50);grid off;
exportgraphics(gcf,fieldP,'Resolution',600) %U Disp


Zt = [];
for iGr = 1:length(Znum)
    temp = Znum{iGr};
    Zt = [Zt,temp];
end

[~,idx] = min(Zt,[],2,'omitnan');
venInd = ceil(idx/2);
% Z = NaN(size(regGridData(:,:,3)));

%%

% dice = [115 115 115 115 115;...
%         125 125 125 125 125];
% dantec = [210 211 212 213 214;...
%                220 221 222 223 224]; %group 3 system1 and 2 Dantec 
% % matchID = [610];
% lavision = [310,311,312 313 314;...
%                320,321 322 323 324]; % LaVision
% matchid = [410 411 412 413 414;...
%             420 421 422 423 424];
% csi = [510 511 512 513 514; %CSI
%              520 521 522 523 524];
grpid = [1,2,3,4,5];

 vend = {dice,dantec,lavision,matchid,csi};


% grewer = [310 311 312 313 314;
%            320 321 322 323 324];
% lava = [220 221 222 223 224;...%group 2 system 2 LAVA
%             210 211 212 213 214];  %group 2 system 1
% sandia = [115;125]; % Sandia 
% 
% vend = {lava,sandia,grewer};


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
         [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames_v3(groupNum);  
         appliedStep = strrep(appliedStep,'=>',' : ');
         stepNames = strcat(fileNames,'_RegGrid.mat');
        
         maindir = fullfile(baseDir,testDir);
         frameNames = fullfile(maindir,stepNames);
         for iFile = 1:size(stepNames,1)   
                    
           
            
    %%FOR VERSION 4
%             if mod(idx(iFile),2)==1
%                sfloc = 1;
%             elseif mod(idx(iFile),2) == 0
%                sfloc = 2;
%             end
%         if ven == 1 && grp == 1 && iGroupNum == 1  && iFile == 1
%                load(frameNames(iFile));
%                Z = regGridData(:,:,3);
%         end
        countr = 0;
           if ven == 1 && sys == 1 && iGroupNum == 1  && iFile == 1
               load(frameNames(iFile));
               Z = regGridData(:,:,3);
             for iven = 1:size(stepFiles,1)
               for isys = 1: size(stepFiles,2)
%                    if ~(iven==3 && isys==2)%iven~=3 && isys ~= 2
                       for idatset = 1:size(stepFiles,3)
                            idxfile = stepFiles{iven,isys,idatset};
                           for file = 1:18 
    %                           if iv~=3 || isys~=2
                                load(idxfile(file))
                                zz = regGridData(:,:,3);
                                Z(zz==0) = 0;
                                countr = countr + 1;
                           end
    %                                 sum(Z(:)~=0)
    %                    end
%     countr
                       end
%                    end
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
%                    if  grp == 1 && (iGroupNum == 1 || iGroupNum == 2)
                      storeLim = true;
                      if avgFlag == 0
                         [cLim,meanvalB(iFile,disp,ven)] = post_plot_v6(regGridData,Z,meanvalB(iFile,disp,ven),...
                          rmnan,iGroupNum,disp,maindir,avgFlag,storeLim,...
                          fixedmean);
%                          if iGroupNum ==  1
                            cLimLo(iFile,disp) = cLim(1);
                            cLimHi(iFile,disp) = cLim(2);
%                          end
                                    
                            
                      else
                                    
                         [cLim,meanvalB(iFile,disp,ven),stat,tmean] = post_plot_v6(regGridData,Z,meanvalB(iFile,disp,ven),...
                         rmnan,iGroupNum,disp,maindir,avgFlag,storeLim,...
                         fixedmean);
%                          if iGroupNum ==  1
                           cLimAvgLo(iFile,disp) = cLim(1);
                           cLimAvgHi(iFile,disp) = cLim(2);
%                          end
                           
%                           [cLim(1) cLim(2) tmean]          
                      end
                       if any([cLim(1) cLim(2) tmean]>50) 
                           error('yahan masla hai')
                       end
                           

                 stepStat(disp,:) = stat'; 
                end
%                 stepStat
             end
                    filestat(1:4,1:4,iFile) = stepStat;
         end  
                climAL{ven,sys,iGroupNum} = cLimAvgLo;
                climAH{ven,sys,iGroupNum} = cLimAvgHi;
                meanPerFrame{ven,sys,iGroupNum} = filestat;
      end
  end
end

% X,Y and Z of the stage movement
steps = [0 0 0; 0 0 -10; 0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0; -10 0 0;
-20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10; 20 0 -20; -10 0 10;
-20 0 20; 0 0 0];

alpha = -0.0001;
beta = -0.0099;
gamma = -0.0042;

rotx = [1,0,0,0;0,cos(alpha),-sin(alpha),0;0,sin(alpha),cos(alpha),0;0,0,0,1];
roty = [cos(beta),0,sin(beta),0;0,1,0,0;-sin(beta),0,cos(beta),0;0,0,0,1];
rotz = [cos(gamma),-sin(gamma),0,0;sin(gamma),cos(gamma),0,0;0,0,1,0;0,0,0,1];
rot = rotx*roty*rotz;

% Transforming from stage coordinates to plate coordinates.
% Results in [Xn,Yn,Zn,1] matching [U,V,W,1]

plateMovement = rot\steps';
steps = plateMovement;


% stepmeandir = strcat(baseDir,'stepsdMeanData.mat');
% save(stepmeandir,'meanPerFrame','steps')

%% Fixed Limit
close all;
% [cLimHM,idM] = max(cLimAvgHi);
% cLimHM = squeeze(cLimHM)';
% cLimLm = min(cLimAvgLo);
% cLimLM = squeeze(cLimLm)';%cLimAvgLo(idM(1),:);
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

%% Same as version 3

%vend = {lava,sandia,grewer};
% vend = {matchid};
%cLimLo = zeros(18,4);
%cLimHi = cLimLo;
%cLimAvgLo = cLimLo;
%cLimAvgHi = cLimLo;
meanval = zeros(18,4);
fixedmean = false;
for ven = 1: length(vend)
  sysgroups = vend{ven};%[210 211 212 213 214];  %group 3 system 1 GREWER

  for sys = 1:size(sysgroups,1)
      groups = sysgroups(sys,:);
      for iGroupNum = 1:size(groups,2)
         groupNum = groups(iGroupNum);
    
                %Get the filenames for the test
         [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames_v3(groupNum);  
         appliedStep = strrep(appliedStep,'=>',' : ');
         stepNames = strcat(fileNames,'_RegGrid.mat');
        
         maindir = fullfile(baseDir,testDir);
         frameNames = fullfile(maindir,stepNames);
%          cll = climAL(ven,sys,:);
%          clh = climAH(ven,sys,:);
%           for i= 1:5
%               tmpL(1:18,1:4,i) = cell2mat(cll(1,1,i));
%               tmpH(1:18,1:4,i) = cell2mat(clh(1,1,i));
%           end  
%           cLimHM = max(max(tmpH,[],3),[],1);
%           cLimLM = min(min(tmpL,[],3),[],1);
%           [cLimHM;cLimLM];

         for iFile = 1:size(stepNames,1)   
            %giving displacement values
             %for a particular frame for all the vendors and datasets and
             %both systems
             tmpH = squeeze(abcH(iFile,:,:)); 
             tmpL = squeeze(abcL(iFile,:,:));
             cLimHM = max(max(abcH,[],3),[],1);%max(tmpH,[],2)';
             cLimLM = min(min(abcL,[],3),[],1);%min(tmpL,[],2)';

             load(frameNames(iFile));
       
             avgFlag = 1;
             scale = 1;
             rmnan = 1;
             pltflag = true;
             fileext = '.eps';
             for avgFlag = 1
                if iFile > 1
                  rmnan = 1;
                end
                sbt = sprintf('Group %s,  %s, Sys : %g, Dataset : %s',groupID,appliedStep(iFile),sysNum,dataSet);
                [stU,stV,stW,st] = post_statsPara(regGridData,iFile);
                for disp = 1 : 4
                   if ven == 1 && sys == 1 && (iGroupNum == 1 || iGroupNum == 2)
%                       storeLim = true;
                      if avgFlag == 0
                         [fieldP,cLim,meanval(iFile,disp)] = post_plot_A220209Mv2(regGridData,Z,meanval(iFile,disp),...
                          rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                          stU,stV,stW,[cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag);
%                          if iGroupNum ==  1
%                             cLimLo(iFile,disp) = cLim(1);
%                             cLimHi(iFile,disp) = cLim(2);
%                          end
                                    
                            
                      else
                                    
                         [fieldP,cLim,meanval(iFile,disp),stat] = post_plot_A220209Mv2(regGridData,Z,meanval(iFile,disp),...
                         rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                         stU,stV,stW,[cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag);
%                          if ven == 1 && iGroupNum ==  1
%                            cLimAvgLo(iFile,disp) = cLim(1);
%                            cLimAvgHi(iFile,disp) = cLim(2);
%                          end
                                    
                      end
                            
                           
                    elseif avgFlag == 0
                          storeLim = false;

                          [fieldP,cLim,meanval(iFile,disp)] = post_plot_A220209Mv2(regGridData,Z,meanval(iFile,disp),...
                          rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                          stU,stV,stW,[cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag);
                    elseif avgFlag == 1
                          storeLim = false;
                                
                          [fieldP,cLim,meanval(iFile,disp),stat] = post_plot_A220209Mv2(regGridData,Z,meanval(iFile,disp),...
                           rmnan,iGroupNum,sbt,disp,maindir,avgFlag,storeLim,fileext,...
                          stU,stV,stW,[cLimLM(:,disp),cLimHM(:,disp)],fixedmean,pltflag);
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
%                   colorbar;   
%                   drawnow;
                 exportgraphics(gcf,fieldP,'Resolution',600) %U Disp
                 stepStat(disp,:) = stat'; 
                 clf;
                end
             end
%                     filestat{iFile} = stepStat;
         end  
%                 meanPerFrame{ven,grp,iGroupNum} = filestat;
      end
  end
end

%%
% gcf
% fv = ["U","V","W","A"];
% close all;
% grpid = [1,2,3,4,5];
% for iFile = 1:18
% %     groupID = grpid(vn);
% %    for sys = 1:size(sysgroups,1)
% %         if ~(vn==3 && grp==2)
%              tmpH = squeeze(abcH(iFile,:,:)); 
%              tmpL = squeeze(abcL(iFile,:,:));
%              cLimHM = max(tmpH,[],2)';
%              cLimLM = min(tmpL,[],2)';
% %               [cLimHM;cLimLM]
%             for cm = 1:4
%                 fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
%                 'Outerposition',[0.152,0.1644,0.5021,0.7625]);
%                 cb = colorbar;
%                 colormap((hsv(20)))
%                 if cLimLM(cm) ~= cLimHM(cm)
%                     caxis([cLimLM(cm),cLimHM(cm)])
%                 else
%                     caxis('auto')
%                 end
%                 set(gca,'Visible','off');
% %                 cb.Location = 'southoutside';
%                 cb.Title.String = '[\mum]';
%                 cb.TickLabelInterpreter = 'latex';
% %                 cb.Title.Position = [308.55,-30.65, 0];
%                 cb.FontSize = 13;
%                 cb.Title.FontSize = 13;
%                 cb.Title.HorizontalAlignment = 'center';
% 
%                 mfloc = strfind(fieldP,'\');
%                 figfold = mfloc(end)-1;
%                 tm = "D:\DIC\colorbar\vertical";%char(fieldP);
%                 figfin = tm;%string(tm(1:figfold));
%                 clbr = sprintf('Step%02dd%s%s',iFile,fv(cm),fileext);
%                 clbrfile = fullfile(figfin,clbr);
%                 drawnow;
% %                 [vn,grp,cm]
%                 exportgraphics(gcf,clbrfile,'Resolution',600) %U Disp
%                 clf
%             end
% %         end
% %    end
%     
% end
% %     OuterPosition = 211,429.8,391.6,207.9999999999999
gcf
fv = ["U","V","W","A"];
close all;
grpid = [1,2,3,4,5];
% for iFile = 1:18
%     groupID = grpid(vn);
%    for sys = 1:size(sysgroups,1)
%         if ~(vn==3 && grp==2)
%              tmpH = squeeze(abcH(iFile,:,:)); 
%              tmpL = squeeze(abcL(iFile,:,:));
cLimHM = max(max(abcH,[],3),[],1);%max(tmpH,[],2)';
cLimLM = min(min(abcL,[],3),[],1);%min(tmpL,[],2)';
%              cLimHM = max(tmpH,[],2)';
%              cLimLM = min(tmpL,[],2)';
%               [cLimHM;cLimLM]
for cm = 1:4
    fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
        'Outerposition',[0.152,0.1644,0.5021,0.7625]);
    cb = colorbar;
    colormap((hsv(20)))
    caxis([cLimLM(cm) cLimHM(cm)])
    set(gca,'Visible','off');
    %                 cb.Location = 'southoutside';
    cb.Title.String = '[\mum]';
    cb.TickLabelInterpreter = 'latex';
    %                 cb.Title.Position = [308.55,-30.65, 0];
    cb.FontSize = 13;
    cb.Title.FontSize = 13;
    cb.Title.HorizontalAlignment = 'center';

    mfloc = strfind(fieldP,'\');
    figfold = mfloc(end)-1;
    tm = "D:\DIC\colorbar\vertical";%char(fieldP);
    figfin = tm;%string(tm(1:figfold));
    clbr = sprintf('colorMapd%s%s',fv(cm),fileext);
    clbrfile = fullfile(figfin,clbr);
    drawnow;
    %                 [vn,grp,cm]
    exportgraphics(gcf,clbrfile,'Resolution',600) %U Disp
    clf
end
%         end
%    end
    
% end


% steps = [0 0 0; 0 0 -10; 0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0; -10 0 0;
% -20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10; 20 0 -20; -10 0 10;
% -20 0 20; 0 0 0];

stepmeandir = strcat(baseDir,'stepsdMeanData7.mat');
 save(stepmeandir,'meanPerFrame','steps')
