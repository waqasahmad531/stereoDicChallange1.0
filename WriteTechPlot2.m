function WriteTechPlot2(techPlotData, gridData)

fileID = fopen(techPlotData.file, 'wt');
pLine = ['TITLE = ' techPlotData.title '\n'];
fprintf(fileID, pLine);
pLine = ['VARIABLES = ' techPlotData.vars '\n'];
fprintf(fileID, pLine);
pLine = 'ZONE\n';
fprintf(fileID, pLine);
pLine = ['T = ' techPlotData.zoneTitle '\n'];
fprintf(fileID, pLine);
pLine = ['I = ' int2str(size(gridData,1))  '\n'];
fprintf(fileID, pLine);
pLine = ['DATAPACKING = BLOCK \n'];
fprintf(fileID, pLine);
fprintf(fileID,'%10.4f\n', gridData);
fclose(fileID);

end
