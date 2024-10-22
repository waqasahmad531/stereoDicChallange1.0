clc; close all; clearvars;
format compact
cd('\\teamwork.org.aalto.fi\T20403-IceFrac\1.0 StereoDIC Challenge Project\DIC\Matlab_Git')
mainDir = "\\teamwork.org.aalto.fi\T20403-IceFrac\1.0 StereoDIC Challenge Project\DIC";
testingDir = fullfile(mainDir,"testing");
%%
tic
% profile on
deadZone = 0.3;  %dead area around discontinuities for registration (mm)
fDoRegistration = true; %register the data (otherwise read from parm file)
fSubDispFromProfile = false; %subtract the displacement data from the profile to keep profiles at 0,0
fRemoveOutliers = false; %remove data with displacements greater than numStdDev from the mean
numStdDev = 3;
fSaveRegData = true; %save the registered data
fSaveRegGrid_w = false;%true; added these to avoid saving files
fSaveRegGrid = false; %create and save a regular grid of registered data
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
testing = [610;620];%[613;624];%[610 613;...
    % 620 624];

if mapper == true
    figure('units','normalized','outerposition',[0 0 1 1])
    set(gcf,'color','w')
end

% sysgroups = [210 211 212 213 214];  %group 3 system 1 GREWER
datasetim = [0 1 2 3 4];
stepVals = [0 0 0; 0 0 -10;0 0 -20; 0 0 10; 0 0 20; 10 0 0; 20 0 0;...
    -10 0 0; -20 0 0; 10 0 10; 20 0 20; -10 0 -10; -20 0 -20; 10 0 -10;...
    20 0 -20; -10 0 10; -20 0 20; 0 0 0];

absVal = sqrt(sum(stepVals.^2,2));

for iSys = 1:size(testing,1)
    datasets = testing(iSys,:);
    for iDataset = 1:size(datasets,2)
        curDataset = datasets(iDataset);

        %Get the filenames for the test
        % groupID = "6"; % Hardcoding it as first 5 groups are settled now.
        steps = 1:18;%[1 2 6 9 12 17 18];
        [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupID, stepVals]=DicDataFileNames(testingDir, curDataset);
        appliedStep = strrep(appliedStep,'=>',' : ');
        % [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, stepVals, stepNum] = ...
        %     DicDataFileNamesForTesting(testDir, iSys,curDataset);
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
            fileBase = strcat(fileNames(iFile));
            DICFileBase = fullfile(testDir, fileBase);
            DICInputFile = strcat(DICFileBase, '.mat');

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
                    writematrix(optVals,RegParmsFile);
                else
                    assert(isfile(RegParmsFile),'Parameter file not found');
                    disp('reading the registration parameters from file');
                    %read the saved parameters
                    optVals = readmatrix(RegParmsFile);
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
                regGridMatFile = strcat(DICFileBase, '_RegGrid.mat');
                %Save the registered data
                disp(strcat('Writing RegMatFile => ',regMatFile));
                %regData = CalcPntErrs(areaCoef, regData, theoCorners);
                save(regMatFile,'regData');
                %Save a grid of the data
                disp('Creating grid data ');
                regGridData=DataGrid(regProfData, regDispData, gridParms, minCounts);
                disp(strcat('Writing RegGridFile => ',regGridMatFile));
                save(regGridMatFile,'regGridData');
            end
            clf;
            Z = regGridData(:,:,3);
            p = pcolor(Z);
            p.EdgeColor = 'None';
            colormap(parula(20));colorbar
            axis ij equal tight
            drawnow

            % Plotting to see if transformation worked or not.
            pltfield = ["U","V","W","A"];
            if mapper == true
                plotTransformedData(regData, A_131, A_132, im, iFile, DICFileLoc, dataSet, pltfield, fileext)
            end

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
