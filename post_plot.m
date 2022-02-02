function  plotName = post_plot(regData,rmNaNFlag,labn,n,testfolder,avgFlag,...
                        scale,fileext)
%post_plot(regData,baseDir) post_plot gets registered data and plots them.
%baseDir should a folder for every vendor so that we do not mix the plots
%   Value of n would define which type of plot is required. If n=1, U
%   displacement is plotted. For n=2, V displacement is plotted and for n=3
%   W displacement is plotted. However, for n=4, we get the absolute
%   displacement. Default value of n=4. 

% if nargin < 4
%     n = 4;
%     testfolder = pwd;
%     avgFlag = 0;
%     scale = 0;
% end

X = regData(:,:,1);
Y = regData(:,:,2);
Z = regData(:,:,3);

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
    temp= sqrt(regData(:,:,4).^2+regData(:,:,5).^2+regData(:,:,6).^2);
    figtit = 'Abs. Displacement';
end

idv = strfind(testfolder,'\');
vendor = extractBetween(testfolder,idv(2)+1,idv(3)-1);
% testfolder(():());

if rmNaNFlag ~= 1
%     temp(temp==0) = NaN;

    if strcmp(vendor,'Lava')
%         B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%     loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
            temp(temp==uv(Ncount == max(Ncount))) = NaN;
            Z(Z==0) = NaN;
        end
    end
end


    if strcmp(vendor,'Grewer')
%             B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%       loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
%             temp(temp==uv(Ncount == max(Ncount))) = NaN;
            Z(Z==0) = NaN;
            temp(isnan(Z)) = NaN;
        end
    end
  
if rmNaNFlag ~= 1
    if strcmp(vendor,'Sandia')
%             B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%       loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
%             temp(temp==uv(Ncount == max(Ncount))) = NaN;
            Z(Z==0) = NaN;
            temp(isnan(Z)) = NaN;
        end
    end
end

if rmNaNFlag ~= 1
%     temp(temp==0) = NaN;

%         B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%     loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
            temp(temp==uv(Ncount == max(Ncount))) = NaN;
            Z(Z==0) = NaN;
        end

end

if rmNaNFlag ~= 1
%     temp(temp==0) = NaN;

    if strcmp(vendor,'LaVision')
%         B = unique(temp);
        [uv,~,idx] = unique(temp);
        Ncount = accumarray(idx(:),1);
        tn = size(temp,1)*size(temp,2);
%     loc = find(max(Ncount))
        if max(Ncount)/tn > 0.25
            temp(temp==uv(Ncount == max(Ncount))) = NaN;
            Z(Z==0) = NaN;
        end
    end
end


    

%  figure(1)
fig = set(gcf,'Renderer','opengl','color','white','Units','Normalized',...
       'Outerposition',[0.1,0.0,0.53,0.99]);
   %, 'InnerPosition',[0.2,0.25,0.62,0.62]
    ax1 = axes('Position',[0.2 0.23 0.6 0.6],'Box', 'on');
    ax = surf(X,Y,Z,temp); colormap((hsv(30))); colorbar;

    if strcmp(vendor,'Lava')
        xlim([-80 80])
        ylim([-80 80])
        zlim([-30 30])
        Ux = -160;Uy = 65; Uz = -93;
        Vx = -40; Vy = 10; Vz = -70;
        Wx = 80; Wy = -17; Wz = -50;
        titx = -350; tity = 350; titz = -39;
        if scale == 1
            caxis([mean(temp,'all','omitnan')-2.5*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2.5*std(temp,[],'all','omitnan')]);
        end
    elseif strcmp(vendor,'Grewer')
        xlim('auto')
        ylim('auto')
        zlim('auto')
        Ux = -140;Uy = 80; Uz = -140;
        Vx = -80; Vy = 80; Vz = -122;
        Wx = 50; Wy = -45; Wz = -20;
        titx = -130; tity = 120; titz = -5;
        if scale == 1
            caxis([mean(temp,'all','omitnan')-2*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2*std(temp,[],'all','omitnan')]);
        end
        axis equal tight;
    elseif strcmp(vendor,'Sandia')
        xlim('auto')
        ylim('auto')
        zlim('auto')
        Ux = -140;Uy = 80; Uz = -140;
        Vx = -80; Vy = 80; Vz = -122;
        Wx = 50; Wy = -45; Wz = -20;
        titx = -130; tity = 120; titz = -5;
        if scale == 1
            caxis([mean(temp,'all','omitnan')-2*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2*std(temp,[],'all','omitnan')]);
        end
        axis equal tight;
        
     elseif strcmp(vendor,'Dantec')
        xlim('auto')
        ylim('auto')
        zlim('auto')
        Ux = -140;Uy = 80; Uz = -140;
        Vx = -80; Vy = 80; Vz = -122;
        Wx = 50; Wy = -45; Wz = -20;
        titx = -130; tity = 120; titz = -5;
        if scale == 1
            caxis([mean(temp,'all','omitnan')-2*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2*std(temp,[],'all','omitnan')]);
        end
        axis equal tight;
        
     elseif strcmp(vendor,'LaVision')
        xlim('auto')
        ylim('auto')
        zlim('auto')
        Ux = -140;Uy = 80; Uz = -140;
        Vx = -80; Vy = 80; Vz = -122;
        Wx = 50; Wy = -45; Wz = -20;
        titx = -130; tity = 120; titz = -5;
        if scale == 1
            caxis([mean(temp,'all','omitnan')-2*std(temp,[],'all','omitnan') ...
            mean(temp,'all','omitnan')+2*std(temp,[],'all','omitnan')]);
        end
        axis equal tight;
    else
        xlim('auto')
        ylim('auto')
        zlim('auto')
        Ux = -140;Uy = 80; Uz = -140;
        Vx = -80; Vy = 80; Vz = -122;
        Wx = 50; Wy = -45; Wz = -20;
        titx = -130; tity = 120; titz = -5;
%         if scale == 1
%             caxis([mean(temp,'all','omitnan')-2*std(temp,[],'all','omitnan') ...
%             mean(temp,'all','omitnan')+2*std(temp,[],'all','omitnan')]);
%         end
        axis equal tight;
    end
        

% if scale == 1
% caxis([mean(temp,'all','omitnan')-3*std(temp,[],'all','omitnan') ...
%     mean(temp,'all','omitnan')+3*std(temp,[],'all','omitnan')]);
% end

ax.LineStyle = 'none';ax.EdgeColor = 'flat';ax.FaceColor = 'flat';

axis xy 
f = gca;
f.View = [30,30];
f.TickDir = 'in';
f.XMinorTick = 'on';
f.YMinorTick = 'on';
f.ZMinorTick = 'on';
f.Box = 'on';
f.BoxStyle = 'back';
f.XMinorGrid = 'on';
f.YMinorGrid = 'on';
f.ZMinorGrid = 'on';
view(2)

% f.ZTick = [0,max(Z,[],'all')];
% f.ZTickLabel = {[0,round(max(Z,[],'all'))]};%,[0,round(max(Z,[],'all'))]'],[1,1]);



f.TickLabelInterpreter = 'latex';
xlabel('X (mm)','Interpreter','latex');
ylabel('Y (mm)','Interpreter','latex');
zlabel('Z (mm)','Interpreter','latex');
% labn = [auxZoneNames;auxZoneVals]';
tx = labn(1:6,1);

% tx(2) = '-----';
tx(2) = '-------';
tx(3) = 'avg';
tx(4) = 'min : ';
tx(3) = 'avg : ';
tx(5) = 'max : ';
tx(6) = 'Std : ';

vals = tx;
vals(3:end) = labn(1:4,2);
vals(1) = '';
vals(2) = '-----';

tx(1) = '  U(mm)';
strcat(tx,vals);
l1 = strcat(tx,vals);
t1 = text(Ux,Uy,Uz,l1,'VerticalAlignment','top','Interpreter',"latex");

tx(1) = '  V(mm)';
vals(3:end) = labn(5:8,2);
l2 = strcat(tx,vals);
t2 = text(Vx,Vy,Vz,l2,'VerticalAlignment','top','Interpreter',"latex");

tx(1) = '  W(mm)';
vals(3:end) = labn(9:12,2);
l3 = strcat(tx,vals);
t3 = text(Wx,Wy,Wz,l3,'VerticalAlignment','top','Interpreter',"latex");

gds = strcat('Group : ',labn(14,2),', Data Set : ',labn(16,2),...
                                                ', System : ',labn(15,2) );
st = labn(13,2);
st = strrep(st,'=>',' : ');
%st(st== '>') = ':';
tit = strcat([figtit;gds;st]);
t3 = text(titx,tity,titz,tit,'VerticalAlignment','top','Interpreter',"latex");
t3.FontWeight = 'bold';
t3.FontSize = 12;
% title(figtit,'Interpreter','latex')

imgfolder = 'Plots';
imgfolder1 = fullfile(testfolder,strcat(imgfolder,'(',date,')'));
    
    if ~isfolder(imgfolder1)
        mkdir(imgfolder1)
    end
    
%     [auxZoneNames, auxZoneVals] = fillAuxZoneData(allVals, appliedStep(iFile), sysNum, groupID, dataSet);    
%     labn = [auxZoneNames;auxZoneVals]';
%     field = post_plot(regGridData,iFile,labn,2);
    
    if ~avgFlag
        figtit = figtit(1:(end-8));
        gds = strrep(gds,':','_');
        gds = strrep(gds,',','_');
%         st = st(~isspace(st));
        st = strrep(st,':','_');
        iFileName = strcat(st,'_',gds,figtit,fileext);
    else
        figtit = figtit(1:(end-8));
%         st = st((find(~isspace(st))));
        st = strrep(st,':','_');
        gds = strrep(gds,':','_');
        gds = strrep(gds,',','_');
        iFileName = strcat(st,'_',gds,figtit,'_Avg',fileext);
    end
    plotName = fullfile(imgfolder1,iFileName);

end

