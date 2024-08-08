function  [plotName,caxisLim,meanVal,stat] = fieldsAndResidualPlots(regData,Z,meanVal,rmNaNFlag,iGroupNum,...
    labn,n,testfolder,avgFlag,storeLim,fileext,lims,fixedmean,pltflag,viewDir)
%post_plot(regData,baseDir) post_plot gets registered data and plots them.
%baseDir should a folder for every vendor so that we do not mix the plots
%   Value of n would define which type of plot is required. If n=1, U
%   displacement is plotted. For n=2, V displacement is plotted and for n=3
%   W displacement is plotted. However, for n=4, we get the absolute
%   displacement. Default value of n=4.

%COLORBARLIMS
% colorbarlims calculates the limits of the colorbars that are eventually
% used to make the tables and figures published in the paper.
% regData: is the registered data loaded from *_reg.mat of each file
% Z: is the minimum area where all the codes have a provided data.
% meanVal: is used in particular when a fixed mean is to be subtracted from
% all the groups.
% rmNaNFlag: (flag) Main intention was to replace the 0s with nan to
% improve plots
% iGroupNum: Related to meanVal. Depending on the group number and avgFlag
% the value will be stored will be different.
% n: 1 for U,2 for V,3 for W or 4 for magnitude (Abs).
% avgFlag: (flag) Removes the meanvalue to get the residual fields instead
% storeLim: (flag) To store the lims calculated upto 2 standard deviations
% fixedmean: (flag) Taking mean value from first vendor in the analysis
%to be subtracted from all of the related steps of other
%vendors too

if avgFlag == 0
    stat = [];
end
X = regData(:,:,1);
Y = regData(:,:,2);
if n == 1
    temp = regData(:,:,4);
    figtit = 'U Displacement';
elseif n == 2
    temp = regData(:,:,5);
    figtit = 'V Displacement';
elseif n == 3
    temp = regData(:,:,6);
    figtit = 'W Displacement';
elseif n == 4
    temp= sqrt(regData(:,:,4).^2 + regData(:,:,5).^2 + regData(:,:,6).^2);
    figtit = 'Abs Displacement';
end

if rmNaNFlag == 1
    [~,~,idx] = unique(temp);
    Ncount = accumarray(idx(:),1);
    tn = size(temp,1)*size(temp,2);
    if max(Ncount)/tn > 0.25
        Z(Z==0) = NaN;
        temp(isnan(Z)) = NaN;
    end
end
stat(1) =  mean(temp,'all','omitnan');
stat(2) = std(temp(:),'omitnan');
stat(3) = min(temp,[],'all','omitnan');
stat(4) = max(temp,[],'all','omitnan');
if avgFlag
    if storeLim
        if iGroupNum == 1
            meanVal = mean(temp,'all','omitnan');
        elseif isnan(meanVal) && iGroupNum ~=1
            meanVal = mean(temp,'all','omitnan');
        end
        if fixedmean %Taking mean value from first vendor in the analysis
            %to be subtracted from all of the related steps of other
            %vendors too
            temp = 1000*(temp-meanVal);
        else
            meanVal = mean(temp,'all','omitnan');
            temp = 1000*(temp-meanVal);
        end
    else
        if fixedmean
            temp = 1000*(temp-meanVal);
        else
            meanVal = mean(temp,'all','omitnan');
            temp = 1000*(temp-meanVal);
        end
    end
else %For the plotting of actual data without mean subtraction
    if storeLim
        if iGroupNum == 1
            meanVal = mean(temp,'all','omitnan');
        elseif isnan(meanVal) && iGroupNum ~=1
            meanVal = mean(temp,'all','omitnan');
        end
    end
end

if pltflag
    set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
        'Outerposition',[0.4982,0.3079,0.3461,0.4625]);
    ax = surf(X,Y,Z,temp);
    colormap((hsv(20)));
    ax.LineStyle = 'none';ax.EdgeColor = 'flat';ax.FaceColor = 'flat';
    axis xy tight equal
    f = gca;
    if strcmp(viewDir, "miniAOI(view2)v2") || strcmp(viewDir, "miniAOI(view2)")
        f.View = [0,90];
    end
    grid off;
    f.TickDir = 'in';
    f.XMinorTick = 'on';
    f.YMinorTick = 'on';
    f.ZMinorTick = 'on';
    f.Box = 'on';
    f.BoxStyle = 'back';
    f.ZTick = [min(Z,[],'all'),max(Z,[],'all')];
    f.ZTickLabel = {[round(min(Z,[],'all')),round(max(Z,[],'all'))]};
    f.TickLabelInterpreter = 'latex';
    xlabel('X (mm)','Interpreter','latex','FontSize',13);
    ylabel('Y (mm)','Interpreter','latex','FontSize',13);
end
if lims(1) ~= lims(2)
    clim(lims);
else
    clim('auto');
end
caxisLim = lims;

imgfolder = 'Plots';
imgfolder1 = fullfile(testfolder,strcat(imgfolder,'(',date,')'),viewDir);

if ~isfolder(imgfolder1)
    mkdir(imgfolder1)
end
if avgFlag ~= 1
    st = strrep(labn,':','');
    st = strrep(st,',','_');
    st = strcat(st(1:8),st(36:42),st(45:54),st(11:18));
    iFileName = strcat(st,' ',figtit(1),fileext);
    iFileName = iFileName(~isspace(iFileName));
else
    figtit = strcat(figtit,'(Error)');
    st = strrep(labn,':','');
    st = strrep(st,',','_');
    st = strcat(st(1:8),st(36:42),st(45:54),st(11:18));
    iFileName = strcat(st,' ','d',figtit(1),fileext);
    iFileName = iFileName(~isspace(iFileName));
end
plotName = fullfile(imgfolder1,iFileName);
end