function plotTransformedData(regData, A_131, A_132, im, iFile, DICFileLoc, dataSet, pltfield, fileext)
% Function to plot transformed data
% Inputs:
%   regData     - Registered data (matrix)
%   A_131       - Dataset 1 (matrix)
%   A_132       - Dataset 2 (matrix)
%   im          - Image (matrix)
%   mapper      - Boolean flag for mapping
%   iFile       - Current file index (integer)
%   DICFileLoc  - Directory location for DIC files (string)
%   dataSet     - Dataset number (integer)
%   pltfield    - Fields to plot (cell array of strings)
%   fileext     - File extension for saved figures (string)

A_133 = regData;

for field = 1:4

    % Prepare data for plotting
    ind = sub2ind([size(im, 1), size(im, 2)], round(A_133(:, 2)), round(A_133(:, 1)));
    Zp = NaN([size(im, 1), size(im, 2)]);
    if field > 3
        Zp(ind) = sqrt(A_133(:, 6).^2 + A_133(:, 7).^2 + A_133(:, 8).^2);
    else
        Zp(ind) = A_133(:, field + 5);
    end

    % Plot transformed data (outliers removed)
    figure(1)
    subplot(1, 2, 2)
    imshow(im)
    hold on
    p = pcolor(Zp);
    lims = [mean(Zp, 'all', 'omitnan') - 2 * std(Zp, [], 'all', 'omitnan'), ...
        mean(Zp, 'all', 'omitnan') + 2 * std(Zp, [], 'all', 'omitnan')];
    colorbar
    if iFile > 1
        clim(lims)
    else
        clim('auto')
    end
    hold off
    p.LineStyle = 'none';
    p.EdgeColor = 'flat';
    p.FaceColor = 'flat';
    title('Transformed (Outliers removed)', 'Interpreter', 'latex')

    % Plot complete data
    ind = sub2ind([size(im, 1), size(im, 2)], round(A_131(:, 2)), round(A_131(:, 1)));
    Zp = NaN([size(im, 1), size(im, 2)]);
    if field > 3
        Zp(ind) = sqrt(A_131(:, 6).^2 + A_131(:, 7).^2 + A_131(:, 8).^2);
    else
        Zp(ind) = A_131(:, field + 5);
    end

    figure(1)
    subplot(1, 2, 1)
    imshow(im)
    hold on
    p = pcolor(Zp);
    colorbar
    if iFile > 1
        clim(lims)
    else
        clim('auto')
    end
    hold off
    p.LineStyle = 'none';
    p.EdgeColor = 'flat';
    p.FaceColor = 'flat';
    title('Complete Data', 'Interpreter', 'latex')

    % Plot second dataset
    ind = sub2ind([size(im, 1), size(im, 2)], round(A_132(:, 2)), round(A_132(:, 1)));
    Zp = NaN([size(im, 1), size(im, 2)]);
    if field > 3
        Zp(ind) = sqrt(A_132(:, 6).^2 + A_132(:, 7).^2 + A_132(:, 8).^2);
    else
        Zp(ind) = A_132(:, field + 5);
    end

    figure(1)
    fieldP = sprintf('%sDataset%gStep%g%s%s', DICFileLoc, dataSet, iFile, pltfield{field}, fileext);
    sgtitle(sprintf('Dataset: %g, Step : %g, %s', dataSet, iFile, pltfield{field}), 'Interpreter', 'latex')
    exportgraphics(gcf, fieldP, 'Resolution', 600)
    drawnow
    clf

end

end
