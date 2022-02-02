% Make an avi movie from a collection of PNG images in a folder.
% Specify the folder.
myFolder = 'G:\DIC\Lava\Sys2-16mm\Plots(08-Mar-2021)\miniAOI_variableMean\turbo';
if ~isfolder(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end
% Step 01 _   00,  00_Group _02_ Data Set _0_ System _1Abs. Disp
% Get a directory listing.
filePattern = fullfile(myFolder, 'Group02Sys2Dataset4Step*dW.png');
pngFiles = dir(filePattern);
filename = pngFiles(1).name;
videoname = strcat(filename(1:19),filename(end-1:end),'.avi');

% Open the video writer object.
% vidnam = 'Sandia Residual Sys2 Group 01 Dataset 5 Abs Disp.avi';
vidnam = strcat(filename(1:19),'_',filename(end-5:end-4),'.avi');
% vidnam = 'Sandia Actual Sys2 Group 01 Dataset 5 W Disp.avi';
vidfile = fullfile(myFolder,vidnam);
writerObj = VideoWriter(vidfile);
writerObj.FrameRate = 0.3;
writerObj.Quality = 100;
open(writerObj);
% Go through image by image writing it out to the AVI file.
for frameNumber = 1 : length(pngFiles)
    % Construct the full filename.
    baseFileName = pngFiles(frameNumber).name;
    fullFileName = fullfile(myFolder, baseFileName);
    % Display image name in the command window.
%     fprintf(1, 'Now reading %s\n', fullFileName);
    % Display image in an axes control.
    thisimage = imread(fullFileName);
    if frameNumber>1 
        if any(size(thisimage) ~= b)
            thisimage = imresize(thisimage,b(1:2));
        end
    end
    imshow(thisimage);  % Display image.
    drawnow; % Force display to update immediately.
    % Write this frame out to the AVI file.
    writeVideo(writerObj, thisimage);
    b = size(thisimage);
end
% Close down the video writer object to finish the file.
close(writerObj);