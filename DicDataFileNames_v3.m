function [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupNum, stepVals] = DicDataFileNames_v3(baseDir,testNum)
%Fills the filenames for the selected test set
%testNum = 0 -> model
%testNum = 1 -> laser scan
%testNum = xx#a
%xx1a,xx2a for system 1 and 2. xx = 06 Testing
%a = 0-4 for individual data sets, 5 for averaged data set


  %Directory information
  fileNames=repmat(" ",1,1);
  testDir = " ";
  sysNum = 0;
  appliedStep(1) = "Step 01=>  00,  00,  00";
  appliedStep(2) = "Step 02=>  00,  00, -10";
  appliedStep(3) = "Step 03=>  00,  00, -20";
  appliedStep(4) = "Step 04=>  00,  00,  10";
  appliedStep(5) = "Step 05=>  00,  00,  20";
  appliedStep(6) = "Step 06=>  10,  00,  00";
  appliedStep(7) = "Step 07=>  20,  00,  00";
  appliedStep(8) = "Step 08=> -10,  00,  00";
  appliedStep(9) = "Step 09=> -20,  00,  00";
  appliedStep(10) = "Step 10=>  10,  00,  10";
  appliedStep(11) = "Step 11=>  20,  00,  20";
  appliedStep(12) = "Step 12=> -10,  00, -10";
  appliedStep(13) = "Step 13=> -20,  00, -20";
  appliedStep(14) = "Step 14=>  10,  00, -10";
  appliedStep(15) = "Step 15=>  20,  00, -20";
  appliedStep(16) = "Step 16=> -10,  00,  10";
  appliedStep(17) = "Step 17=> -20,  00,  20";
  appliedStep(18) = "Step 18=>  00,  00,  00";
  stepVals = [0 0; 0 -10;0 -20; 0 10; 0 20; 10 0; 20 0; -10 0; -20 0; 10 10; 20 20; -10 -10; -20 -20; 10 -10; 20 -20; -10 10; -20 20; 0 0];
  
  switch testNum
    case 0
      testDir = 'Model';
      sysNum = 0;
      fileNames=repmat(" ",1,1);
      fileNames(1)="Model";
      dataSet = "-1";
      groupNum = "00";
     
      %% Testing
      case 610  %Testing system 1-0000
      testDir = fullfile(baseDir,'\35mm\Dataset 0');
      sysNum = 1;
      fileNames=repmat(" ",2,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';     
      dataSet = "0";
      groupNum = "06";
      
      case 611  %Testing system 1-0001
      testDir = fullfile(baseDir,'\35mm\Dataset 1');
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';     
      dataSet = "1";
      groupNum = "06";
      
      case 612  %Testing system 1-0002
      testDir = fullfile(baseDir,'\35mm\Dataset 2');
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';       
      dataSet = "2";
      groupNum = "06";
      
      case 613  %Testing system 1-0003
      testDir = fullfile(baseDir,'\35mm\Dataset 3');
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';        
      dataSet = "3";
      groupNum = "06";
      
      case 614  %Testing system 1-0004
      testDir = fullfile(baseDir,'\35mm\Dataset 4');
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';        
      dataSet = "4";
      groupNum = "06";
      
      
     case 620  %Testing system 2-0000
      testDir = fullfile(baseDir,'\16mm\Dataset 0');
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step06';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';       
      dataSet = "0";
      groupNum = "06";
      
      case 621  %Testing system 2-0001
      testDir = fullfile(baseDir,'\16mm\Dataset 1');
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';       
      dataSet = "1";
      groupNum = "06";
      
      case 622  %Testing system 2-0002
      testDir = fullfile(baseDir,'\16mm\Dataset 2');
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';       
      dataSet = "2";
      groupNum = "06";
      
      case 623  %Testing system 2-0003
      testDir = fullfile(baseDir,'\16mm\Dataset 3');
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';     
      dataSet = "3";
      groupNum = "06";
      
      case 624  %Testing system 2-0004
      testDir = fullfile(baseDir,'\16mm\Dataset 4');
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='step00';
      fileNames(2)='step01';
      fileNames(3)='step02';
      fileNames(4)='step03';
      fileNames(5)='step04';
      fileNames(6)='step05';
      fileNames(7)='step06';
      fileNames(8)='step07';
      fileNames(9)='step08';
      fileNames(10)='step09';
      fileNames(11)='step10';
      fileNames(12)='step11';
      fileNames(13)='step12';
      fileNames(14)='step13';
      fileNames(15)='step14';
      fileNames(16)='step15';
      fileNames(17)='step16';
      fileNames(18)='step17';      
      dataSet = "4";
      groupNum = "06";
      
      
      %% Simulated Data
      case 910  %Testing system 1-0000
      testDir = 'simulatedData';
      sysNum = 1;
      fileNames=repmat(" ",2,1);
      fileNames(1)='step00';
      fileNames(2)='step06';
      fileNames(3)='step08';
      dataSet = "0";
      groupNum = "09";
      
      

      
  end
  
end

