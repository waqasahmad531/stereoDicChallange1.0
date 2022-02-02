function [compData] = CompareGridData(data1, data2)
 compData=data1;
 blankVal = data1(:,:,7).*data2(:,:,7);
 blankVal(blankVal(:,:)>0)=1;
 compData(:,:,7) = blankVal(:,:);
 compData(:,:,3) = (data1(:,:,3)-data2(:,:,3)).*compData(:,:,7);
 compData(:,:,4) = (data1(:,:,4)-data2(:,:,4)).*compData(:,:,7);
 compData(:,:,5) = (data1(:,:,5)-data2(:,:,5)).*compData(:,:,7);
 compData(:,:,6) = (data1(:,:,6)-data2(:,:,6)).*compData(:,:,7);
end

