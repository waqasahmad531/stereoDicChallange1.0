function [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, stepVals, fileNumbers] = ...
                    DicDataFileNamesForTesting(baseDir, sysNum, datasetNum)
% Generates the filenames for the selected test set based on inputs
% baseDir: The base directory for the data
% sysNum: The system number (1, 2, etc.)
% datasetNum: which frame of each step 0,1,2,3,4

% Initialize variables

sysName = systemFolders(baseDir);
% fileNames = repmat(" ", length(steps), 1);
testDir = fullfile(baseDir,sysName(sysNum));
[datasetDir, datasetInDir] = datasetFolder(testDir);
dataSet = find(datasetInDir==datasetNum);
locFolder = datasetDir(datasetNum==datasetInDir);
testDir = fullfile(testDir,locFolder);
matFiles = fullfile(testDir,'step*.mat');
[fileNames,fileNumbers] = imgFilesPath(matFiles); % extracting frame name and number

stepVals = [
    0, 0; 0, -10; 0, -20; 0, 10; 0, 20; 10, 0; 20, 0; -10, 0; -20, 0;
    10, 10; 20, 20; -10, -10; -20, -20; 10, -10; 20, -20; -10, 10; -20, 20; 0, 0
];

% Define step descriptions
stepDescriptions = [
    "Step 01=>  00,  00,  00", "Step 02=>  00,  00, -10", "Step 03=>  00,  00, -20",...
    "Step 04=>  00,  00,  10", "Step 05=>  00,  00,  20", "Step 06=>  10,  00,  00",...
    "Step 07=>  20,  00,  00", "Step 08=> -10,  00,  00", "Step 09=> -20,  00,  00",...
    "Step 10=>  10,  00,  10", "Step 11=>  20,  00,  20", "Step 12=> -10,  00, -10",...
    "Step 13=> -20,  00, -20", "Step 14=>  10,  00, -10", "Step 15=>  20,  00, -20",...
    "Step 16=> -10,  00,  10", "Step 17=> -20,  00,  20", "Step 18=>  00,  00,  00"
];

% Populate appliedStep with descriptions
appliedStep = stepDescriptions(fileNumbers + 1);
stepVals = stepVals(fileNumbers + 1,:);
end


% Uses following functions to get the files and numbers
function subfolderNames = systemFolders(baseDir)
% Get directory contents
dirContents = dir(baseDir);

% Filter out the subfolders
isSubfolder = [dirContents.isdir]; % Logical array indicating folders
subfolderNames = {dirContents(isSubfolder).name}; % Cell array of subfolder names

% Remove '.' and '..' which represent the current and parent folder
subfolderNames = subfolderNames(~ismember(subfolderNames, {'.', '..'}));
subfolderNames = string(cat(1,subfolderNames{:}));
subfolderNames = flip(subfolderNames);
end

function [datasets, datasetsNum] = datasetFolder(sysDir)
dirContents = dir(sysDir);
% Filter out the subfolders
isSubfolder = [dirContents.isdir]; % Logical array indicating folders
datasets = {dirContents(isSubfolder).name}; % Cell array of subfolder names

% Remove '.' and '..' which represent the current and parent folder
datasets = datasets(~ismember(datasets, {'.', '..'}));
datasets = string(cat(1,datasets{:}));
temp = regexp(datasets,'\d','match');
datasetsNum = str2double(cat(1,temp{:}));
end

function [imgsPath, frames] = imgFilesPath(testImgsDir)
imgs = dir(testImgsDir);
folder = {imgs.folder};
name = {imgs.name};
imgsPath = cellfun(@fullfile,folder,name,'UniformOutput',false);
imgsPath = string(cat(1,imgsPath{:}));
a = regexp(name,'\d*','match');
frames = str2double(cat(1,a{:}));
end