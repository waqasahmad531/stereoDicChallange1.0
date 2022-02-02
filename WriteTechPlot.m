function WriteTechPlot(techPlotData, gridData, auxZoneNames, auxVals)

fileID = fopen(techPlotData.file, 'wt');
pLine = ['TITLE = ' convertStringsToChars(techPlotData.title) '\n'];
fprintf(fileID, pLine);
pLine = ['VARIABLES = ' techPlotData.vars '\n'];
fprintf(fileID, pLine);
pLine = 'ZONE\n';
fprintf(fileID, pLine);
pLine = ['T = ' techPlotData.zoneTitle '\n'];
fprintf(fileID, pLine);
if exist('auxZoneNames','var')
  for iVal = 1:size(auxZoneNames,2)
    pLine = ['AUXDATA ' convertStringsToChars(auxZoneNames(iVal)) ' = "' convertStringsToChars(auxVals(iVal)) '"\n'];
    fprintf(fileID, pLine);
  end
end
pLine = ['I = ' int2str(size(gridData,1)) ', J = ' int2str(size(gridData,2)) ', K=1' '\n'];
fprintf(fileID, pLine);
pLine = ['DATAPACKING = BLOCK \n'];
fprintf(fileID, pLine);
fprintf(fileID,'%11.5f\n', gridData);
fclose(fileID);

end

