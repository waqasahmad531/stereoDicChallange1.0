clc; close all; clearvars;
format compact
cd('\\teamwork.org.aalto.fi\T20403-IceFrac\1.0 StereoDIC Challenge Project\DIC\Matlab_Git')
mainDir = "\\teamwork.org.aalto.fi\T20403-IceFrac\1.0 StereoDIC Challenge Project\DIC";
testDir = fullfile(mainDir,"testing");
%%
tic
% profile on
deadZone = 0.3;  %dead area around discontinuities for registration (mm)
fDoRegistration = false; %register the data (otherwise read from parm file)
fSubDispFromProfile = false; %subtract the displacement data from the profile to keep profiles at 0,0
fRemoveOutliers = false; %remove data with displacements greater than numStdDev from the mean
numStdDev = 3;
fSaveRegData = true; %save the registered data
fSaveRegGrid_w = true;%true; added these to avoid saving files
fSaveRegGrid = true; %create and save a regular grid of registered data
fSaveTPlotGrid = false;  %save a regular grid of data for techplot
fCalcProfileNoise = false;%calculate the noise in the profile from the 5 samples
fSaveGlobalStats = true; %save the global stats to the excel sheet
fExitOnEnd = false; %exit the program at the end
mapper = true;
%setup the grid parameters
%%
[gridParms,minCounts] = GetGridParms;

%setup the output matricies for the EXCEL sheet
outputIdx = 0;
outputNumData = [];
outputTextData = strings([1,4]);

%select the groups to work on
% There are 5 frames captured at each step, named dataSet. The two systems
% are number 1 and 2. Each row in sysgroups is for them respectively.
sysgroups = [0,4;%[10, 11, 12, 13, 14;         
             0,3]; %20, 21, 22, 23, 24]; 


figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w')

% sysgroups = [210 211 212 213 214];  %group 3 system 1 GREWER
datasetim = [0 1 2 3 4];
stepVals = [0 0 0; 0 0 -10;0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0;...
    -10 0 0; -20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10;...
    20 0 -20; -10 0 10; -20 0 20; 0 0 0];

absVal = sqrt(sum(stepVals.^2,2));

for iSys = 1:size(sysgroups,1)
    datasets = sysgroups(iSys,:);
    for iDataset = 1:size(datasets,2)
        curDataset = datasets(iDataset);

        %Get the filenames for the test
        groupID = "6";
        steps = [1 2 6 9 12 17 18];
        [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, stepVals, stepNum] = ...
                        DicDataFileNamesForTesting(testDir, iSys,curDataset);
        % [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames_v3(groupNum);

        % %setup the filenames for the analysis
        % testName = strrep(testDir,'\','_');
        % testDir = strcat(testDir, '\');

        %get the parameters that describe the surface
        [theoBoundries,theoCorners,fitBoundries,areaCoef] = FillFitParms(sysNum, deadZone);

        imgfolder = 'Plots';
        % ntestdir = strcat(baseDir,testDir);
        imgfolder1 = fullfile(testDir,strcat(imgfolder,'(',string(datetime("today")),')'));

        if ~isfolder(imgfolder1)
            mkdir(imgfolder1)
        end

        DICFileLoc = strcat(imgfolder1,'\');%baseDir, testDir);
        fileext = '.eps';

        %Make regular grid data from all the files
        for iFile = 1:size(fileNames,1)

            if iSys == 1
                imdir = strcat(mainDir,'\Translate\35-mm\*');
                fildir = sprintf('%s%g_0.tif',imdir,datasetim(1));
                imname = dir(fildir);
            elseif iSys == 2
                imdir = strcat(mainDir,'\Translate\16-mm\*');
                fildir = sprintf('%s%g_0.tif',imdir,datasetim(1));
                imname = dir(fildir);
            end

            im = imread(fullfile(imname(1).folder,imname(1).name));
            im = repmat(im,1,1,3);

            %setup the input file name
            disp('******************************************************');
            disp(strcat('working on file: ',fileNames(iFile)));
            fileBase = fileNames(iFile);
            DICFileBase = strcat(baseDir, testDir, fileBase);
            DICInputFile = strcat(DICFileBase, '.mat');
            zoneName = strcat(fileBase, ' ');  %%move to techplot area

            %Read the data and then seperate into the sepaerate areas
            whos('-file', DICInputFile);
            fLoad = load(DICInputFile);

            %Adding lines to analyze the codes which have columns data instead of
            %rows: Specifically for LaVision
            if isfield(fLoad,'hdfData')
                fLoad.hdfData = fLoad.hdfData';
            end
            A_1 = double(fLoad.(cell2mat(fieldnames(fLoad))));
            %     dicmat = A_1;
            A_131 = A_1;
            if fSubDispFromProfile == true
                A_131(:,3:5) = A_131(:,3:5)-A_131(:,6:8);
            end

            %strip out any nan entries
            disp(strcat('-rows before StripNan', num2str(size(A_1,1))));
            initRows = size(A_1, 1);
            NaNRows = size(A_1,1);
            A_1 = rmmissing(A_1);
            NaNRows = NaNRows - size(A_1,1);
            disp(strcat('-rows after StripNan', num2str(size(A_1,1))));

            %fill the world and image data arrays
            imgData = A_1(:,1:2);
            profData = A_1(:,3:5);
            dispData = A_1(:,6:8);

            %remove the displacement from data where it is added to the profile
            if fSubDispFromProfile == true
                disp('subtracting displacements from the profile');
                profData = profData - dispData;
            end

            %if it is the first file either do the registration or get the parms
            if iFile == 1 %&& iGroupNum == 1
                RegParmsFile = strcat(DICFileBase, '_RegParms.dat');
                if fDoRegistration == true
                    disp('calculating the registration parameters');
                    %seperate the data into the registration areas
                    [areas, areaPnts]=SeperateFitAreas(imgData, profData, fitBoundries);
                    %register and return the optimized transform values
                    optVals = RegisterPlate(areas, areaPnts, areaCoef, 3);
                    %save the parameters
                    csvwrite(RegParmsFile, optVals);
                else
                    assert(isfile(RegParmsFile),'Parameter file not found');
                    disp('reading the registration parameters from file');
                    %read the saved parameters
                    optVals = csvread(RegParmsFile);
                end
            end

            alpha = -0.0001;
            beta = -0.0099;
            gamma = -0.0042;
            rotx = [1,0,0,0;0,cos(alpha),-sin(alpha),0;0,sin(alpha),cos(alpha),0;0,0,0,1];
            roty = [cos(beta),0,sin(beta),0;0,1,0,0;-sin(beta),0,cos(beta),0;0,0,0,1];
            rotz = [cos(gamma),-sin(gamma),0,0;sin(gamma),cos(gamma),0,0;0,0,1,0;0,0,0,1];
            rotno = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
            rot = rotx*roty*rotz*rotno;


            %%apply the transformation to the full data set
            disp('applying the registraion transformation to the data');
            rotArrReg = RotArray(optVals(1), optVals(2), optVals(3));
            transArrReg = [optVals(4) optVals(5) optVals(6)];
            regProfData = profData*rotArrReg+transArrReg;
            regDispData = dispData*rotArrReg;

            %Calculate the raw data statistics
            disp('calculating global stats');
            regData = [imgData regProfData regDispData];
            aveVals = mean(regData(:,3:8));
            stdDev = std(regData(:,3:8));
            minVals = min(regData(:,3:8));
            maxVals = max(regData(:,3:8));
            allVals = [aveVals; minVals; maxVals; stdDev];
            allVals = reshape(allVals,1,[]);

            A_132 = regData;

            outlierRows = 0.0;
            if fRemoveOutliers == true
                disp('removing outlier data');
                disp(strcat('-rows before removing outliers', num2str(size(regData,1))));
                outlierRows = size(regData,1);
                regData(regData(:,6)<(aveVals(4)-numStdDev*stdDev(4)),6)= NaN;
                regData(regData(:,7)<(aveVals(5)-numStdDev*stdDev(5)),7)= NaN;
                regData(regData(:,8)<(aveVals(6)-numStdDev*stdDev(6)),8)= NaN;
                regData(regData(:,6)>(aveVals(4)+numStdDev*stdDev(4)),6)= NaN;
                regData(regData(:,7)>(aveVals(5)+numStdDev*stdDev(5)),7)= NaN;
                regData(regData(:,8)>(aveVals(6)+numStdDev*stdDev(6)),8)= NaN;
                regData = rmmissing(regData);
                outlierRows = outlierRows - size(regData,1);
                disp(strcat('-rows after removing outliers', num2str(size(regData,1))));

                %recalculate the data statistics
                disp('recalculating global stats');
                aveVals = mean(regData(:,3:8));
                stdDev = std(regData(:,3:8));
                minVals = min(regData(:,3:8));
                maxVals = max(regData(:,3:8));
                allVals = [aveVals; minVals; maxVals; stdDev];
                allVals = reshape(allVals,1,[]);
            end
            A_133 = regData;
            pltfield = ["U","V","W","A"];
            for field = 1:4
                if mapper == true
                    %subplot(1,3,3)
                    ind = sub2ind([size(im,1) size(im,2)],round(A_133(:,2)),round(A_133(:,1)));
                    Zp = NaN([size(im,1) size(im,2)]);
                    if field>3
                        Zp(ind) = sqrt(A_133(:,6).^2 + A_133(:,7).^2 + A_133(:,8).^2);
                    else
                        Zp(ind) = A_133(:,field+5);%A_133(:,5);%
                    end

                    figure(1)
                    subplot(1,2,2)
                    imshow(im)
                    hold on
                    p = pcolor(Zp);
                    lims = [mean(Zp,'all','omitnan')-2*std(Zp,[],'all','omitnan') ...
                        mean(Zp,'all','omitnan')+2*std(Zp,[],'all','omitnan')];
                    colorbar
                    if iFile>1
                        clim(lims)
                    else
                        clim('auto')
                    end
                    hold off
                    p.LineStyle = 'none';p.EdgeColor = 'flat';p.FaceColor = 'flat';
                    title('Transformed (Outliers removed)','Interpreter','latex')
                    %         clear dicmat
                    %subplot(1,3,1)
                    %         dicmat = A_1;
                    ind = sub2ind([size(im,1) size(im,2)],round(A_131(:,2)),round(A_131(:,1)));
                    Zp = NaN([size(im,1) size(im,2)]);
                    if field>3
                        Zp(ind) = sqrt(A_131(:,6).^2 + A_131(:,7).^2 + A_131(:,8).^2);
                    else
                        Zp(ind) = A_131(:,field+5);%A_131(:,5);%
                    end
                    %         Zp(ind) = dicmat(:,5);
                    figure(1)
                    subplot(1,2,1)
                    imshow(im)
                    hold on
                    p = pcolor(Zp);
                    colorbar
                    if iFile>1
                        clim(lims)
                    else
                        clim('auto')
                    end
                    hold off
                    p.LineStyle = 'none';p.EdgeColor = 'flat';p.FaceColor = 'flat';
                    title('Complete Data','Interpreter','latex')
                    %         clear dicmat
                    %subplot(1,3,2)

                    %         dicmat = A_2;
                    ind = sub2ind([size(im,1) size(im,2)],round(A_132(:,2)),round(A_132(:,1)));
                    Zp = NaN([size(im,1) size(im,2)]);
                    if field>3
                        Zp(ind) = sqrt(A_132(:,6).^2 + A_132(:,7).^2 + A_132(:,8).^2);
                    else
                        Zp(ind) = A_132(:,field+5);
                    end


                    figure(1)
                    fieldP = sprintf('%sDataset%gStep%g%s%s',DICFileLoc,dataSet,iFile,pltfield(field),fileext);
                    %             sgtitle(sprintf('Dataset: %g, Step : %g, Z',iGroupNum,iFile))
                    sgtitle(sprintf('Dataset: %g, Step : %g, %s',iDataset,iFile,pltfield(field)))
                    %     fieldP = post_plot(regGridData,flag,labn,1,DICFileLoc,avgFlag,scale,fileext);
                    exportgraphics(gcf,fieldP,'Resolution',600) %U Disp
                    drawnow
                    clf

                end
            end


            %Save the stats to the overall output matrix
            outputIdx = outputIdx + 1;
            outputNumData(outputIdx,:) = [initRows, NaNRows, outlierRows, stepVals(iFile,:) allVals];
            outputTextData(outputIdx,:) = [groupID; num2str(sysNum); appliedStep(iFile); dataSet];

            %save the img and profile data for the profile noise analysis
            if fCalcProfileNoise == true && iFile ==1
                switch iDataset
                    case 1
                        profile1 = regData(:,1:6);
                    case 2
                        profile2 = regData(:,1:6);
                    case 3
                        profile3 = regData(:,1:6);
                    case 4
                        profile4 = regData(:,1:6);
                    case 5
                        profile5 = regData(:,1:6);
                end
            end

            if fSaveRegData == true
                %Save the registered data for the profile
                regMatFile = strcat(DICFileBase, '_Reg.mat');
                %Save the registered data
                disp(strcat('Writing RegMatFile => ',regMatFile));
                %regData = CalcPntErrs(areaCoef, regData, theoCorners);
                save(regMatFile,'regData');
            end

            if fSaveRegGrid_w == true || fSaveTPlotGrid == true
                %Save a grid of the data
                disp('Creating grid data ');
                regGridData=DataGrid2(regData(:,3:5), regData(:,6:8), gridParms, minCounts);

                %save the registered grid of data
                if fSaveRegGrid == true
                    regGridMatFile = strcat(DICFileBase, '_RegGrid.mat');
                    disp(strcat('Writing RegGridFile => ',regGridMatFile));
                    save(regGridMatFile,'regGridData');
                end

                %save the registered grid of data for plotting
                if fSaveTPlotGrid == true
                    disp('save techplot file');
                    disp('subtract mean displacements for plotting');
                    for ix = 1:size(regGridData,1)
                        for iy = 1:size(regGridData,2)
                            regGridData(ix,iy,4) = regGridData(ix,iy,4) - aveVals(4);
                            regGridData(ix,iy,5) = regGridData(ix,iy,5) - aveVals(5);
                            regGridData(ix,iy,6) = regGridData(ix,iy,6) - aveVals(6);
                            if regGridData(ix,iy,7)<4
                                regGridData(ix,iy,4) = 0;
                                regGridData(ix,iy,5) = 0;
                                regGridData(ix,iy,6) = 0;
                            end
                        end
                    end
                    disp('end techplot subtract mean');

                    %Save TechPlot formatted grid data
                    regTPlotDatFile = strcat(DICFileBase, '_TPlotGrid.dat');
                    disp(strcat('Writing Techplot RegTPlotFile => ',regTPlotDatFile));
                    zoneName = strcat(fileBase, ' ');
                    techPlotData.file = regTPlotDatFile;
                    techPlotData.title = strcat('"', strcat('Group_', groupID, ' System_', num2str(sysNum), ' Dataset_', dataSet, '"'));
                    techPlotData.vars = '"X(mm)" "Y(mm)" "Z(mm)" "U-aveU(mm)" "V-aveV(mm)" "W-aveW(mm)" "Count"';
                    techPlotData.zoneTitle = char(strcat('"', zoneName, '"'));
                    [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);
                    WriteTechPlot(techPlotData, regGridData,auxZoneNames, auxZoneVals);
                    disp(strcat('End => ' ,zoneName));
                end


            end
            %WAQAS: Added code for plotting
            avgFlag = 0;
            scale = 0;
            if avgFlag == 1
                regGridData(:,:,4) = regGridData(:,:,4) - aveVals(4);
                regGridData(:,:,5) = regGridData(:,:,5) - aveVals(5);
                regGridData(:,:,6) = regGridData(:,:,6) - aveVals(6);
            end

            if  iDataset == 1 && iFile == 1

                flag = 1;
            else
                flag = 0;
            end
            %    p = profile('info')
            [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);
            labn = [auxZoneNames;auxZoneVals]';
            figure(2)
            clf;
            fieldP = initPlot(regGridData,flag,labn,1,DICFileLoc,avgFlag,scale,1,fileext);
            drawnow
            exportgraphics(gcf,fieldP,'Resolution',300) %V Disp
            clf;
            fieldP = initPlot(regGridData,flag,labn,2,DICFileLoc,avgFlag,scale,2,fileext);
            drawnow
            exportgraphics(gcf,fieldP,'Resolution',300) %V Disp
            clf;
            fieldP = initPlot(regGridData,flag,labn,3,DICFileLoc,avgFlag,scale,3,fileext);
            drawnow
            exportgraphics(gcf,fieldP,'Resolution',300) %W Disp
            clf;
            fieldP = initPlot(regGridData,flag,labn,4,DICFileLoc,avgFlag,scale,4,fileext);
            drawnow
            exportgraphics(gcf,fieldP,'Resolution',300) %Abs Disp
            clf;

        end
    end
    if fSaveGlobalStats == true
        disp('Saving global stats');
        %Save the stats to the spreadsheet
        outputFile = strcat(baseDir, 'GlobalDataStatistics.xlsx');
        headder = ["groupID" "system" "step" "series" "init rows" "NaN rows" "outlier rows" "disp1" "disp2" "x ave" "x min" "x max" "x stdev" "y ave" "y min" "y max" "y stdev" "z ave" "z min" "z max" "z stdev"  "u ave" "u min" "u max" "u stdev"  "v ave" "v min" "v max" "v stdev"  "w ave" "w min" "w max" "w stdev"];
        sheetName = char(strcat('Group_', groupID, '_System_', num2str(sysNum)));
        writematrix(outputTextData,outputFile,'sheet',sheetName,'Range','A5');
        writematrix(outputNumData,outputFile,'sheet',sheetName,'Range','E5');
        writematrix(headder,outputFile,'sheet',sheetName,'Range','A4');

        if fCalcProfileNoise == true
            disp('calculating profile noise');
            [numProfPts, minDiffProf, maxDiffProf, stdDiffProf] = calcProfileNoise(profile1, profile2, profile3, profile4, profile5);
            outputVals = [numProfPts minDiffProf maxDiffProf stdDiffProf];
            headder = ["Profile Noise" "num Points" "min dev x" "min dev y" "min dev z" "max dev x" "max dev y" "max dev z" "std dev x" "std dev y" "std dev z"];
            writematrix(headder,outputFile,'sheet',sheetName,'Range','A1');
            writematrix(outputVals,outputFile,'sheet',sheetName,'Range','B2');
        end

    end
end
toc
if fExitOnEnd == true
    exit;
end
