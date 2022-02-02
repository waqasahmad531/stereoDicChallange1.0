function [fileNames, testDir, sysNum, baseDir, appliedStep, dataSet, groupNum, stepVals] = DicDataFileNames(testNum)
%Fills the filenames for the selected test set
%testNum = 0 -> model
%testNum = 1 -> laser scan
%testNum = xx#a
%xx1a,xx2a for system 1 and 2. xx = 01-Sandia, 02-Lava, 03-Grewer
%a = 0-4 for individual data sets, 5 for averaged data set

% sadia 115 125
% Lava 21-
% Grewer 31-

  %Directory information
  fileNames=repmat(" ",1,1);
  testDir = " ";
  sysNum = 0;
  baseDir = "D:\DIC\";%"C:\Users\helmj\Documents\DICe_Challenge\Challenge Data\";
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
     %% Sandia
    case 115   %Sandia system 1 average
      testDir = 'Sandia\Sys1-35mm';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys1-0000-Avg _0';
      fileNames(2)='Step02 00,-10-sys1-0000-Avg _0';
      fileNames(3)='Step03 00,-20-sys1-0000-Avg _0';
      fileNames(4)='Step04 00,10-sys1-0000-Avg _0';
      fileNames(5)='Step05 00,20-sys1-0000-Avg _0';
      fileNames(6)='Step06 10,00-sys1-0000-Avg _0';
      fileNames(7)='Step07 20,00-sys1-0000-Avg _0';
      fileNames(8)='Step08 -10,00-sys1-0000-Avg _0';
      fileNames(9)='Step09 -20,00-sys1-0000-Avg _0';
      fileNames(10)='Step10 10,10-sys1-0000-Avg _0';
      fileNames(11)='Step11 20,20-sys1-0000-Avg _0';
      fileNames(12)='Step12 -10,-10-sys1-0000-Avg _0';
      fileNames(13)='Step13 -20,-20-sys1-0000-Avg _0';
      fileNames(14)='Step14 10,-10-sys1-0000-Avg _0';
      fileNames(15)='Step15 20,-20-sys1-0000-Avg _0';
      fileNames(16)='Step16 -10,10-sys1-0000-Avg _0';
      fileNames(17)='Step17 -20,20-sys1-0000-Avg _0';
      fileNames(18)='Step18 00,00-sys1-0000-Avg _0';
      dataSet = "4";
      groupNum = "01";

    case 125   %Sandia system 2 average
      testDir = 'Sandia\Sys2-16mm';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys2-0000-Avg _0';
      fileNames(2)='Step02 00,-10-sys2-0000-Avg _0';
      fileNames(3)='Step03 00,-20-sys2-0000-Avg _0';
      fileNames(4)='Step04 00,10-sys2-0000-Avg _0';
      fileNames(5)='Step05 00,20-sys2-0000-Avg _0';
      fileNames(6)='Step06 10,00-sys2-0000-Avg _0';
      fileNames(7)='Step07 20,00-sys2-0000-Avg _0';
      fileNames(8)='Step08 -10,00-sys2-0000-Avg _0';
      fileNames(9)='Step09 -20,00-sys2-0000-Avg _0';
      fileNames(10)='Step10 10,10-sys2-0000-Avg _0';
      fileNames(11)='Step11 20,20-sys2-0000-Avg _0';
      fileNames(12)='Step12 -10,-10-sys2-0000-Avg _0';
      fileNames(13)='Step13 -20,-20-sys2-0000-Avg _0';
      fileNames(14)='Step14 10,-10-sys2-0000-Avg _0';
      fileNames(15)='Step15 20,-20-sys2-0000-Avg _0';
      fileNames(16)='Step16 -10,10-sys2-0000-Avg _0';
      fileNames(17)='Step17 -20,20-sys2-0000-Avg _0';
      fileNames(18)='Step18 00,00-sys2-0000-Avg _0';
      dataSet = "4";
      groupNum = "01";
  %% Lava MatchID
    case 210  %Lava system 1-0000
      testDir = 'Lava\Sys1-35mm';
      sysNum = 1;
      fileNames=repmat(" ",18,1);      
      fileNames(1)='Step01 00,00-sys1-0000_0';      
      fileNames(2)='Step02 00,-10-sys1-0000_0';
      fileNames(3)='Step03 00,-20-sys1-0000_0';
      fileNames(4)='Step04 00,10-sys1-0000_0';
      fileNames(5)='Step05 00,20-sys1-0000_0';
      fileNames(6)='Step06 10,00-sys1-0000_0';
      fileNames(7)='Step07 20,00-sys1-0000_0';
      fileNames(8)='Step08 -10,00-sys1-0000_0';
      fileNames(9)='Step09 -20,00-sys1-0000_0';
      fileNames(10)='Step10 10,10-sys1-0000_0';
      fileNames(11)='Step11 20,20-sys1-0000_0';
      fileNames(12)='Step12 -10,-10-sys1-0000_0';
      fileNames(13)='Step13 -20,-20-sys1-0000_0';
      fileNames(14)='Step14 10,-10-sys1-0000_0';
      fileNames(15)='Step15 20,-20-sys1-0000_0';
      fileNames(16)='Step16 -10,10-sys1-0000_0';
      fileNames(17)='Step17 -20,20-sys1-0000_0';
      fileNames(18)='Step18 00,00-sys1-0000_0';
      dataSet = "0";
      groupNum = "02";
      
    case 211  %Lava system 1-0001
      testDir = 'Lava\Sys1-35mm';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys1-0001_0';
      fileNames(2)='Step02 00,-10-sys1-0001_0';
      fileNames(3)='Step03 00,-20-sys1-0001_0';
      fileNames(4)='Step04 00,10-sys1-0001_0';
      fileNames(5)='Step05 00,20-sys1-0001_0';
      fileNames(6)='Step06 10,00-sys1-0001_0';
      fileNames(7)='Step07 20,00-sys1-0001_0';
      fileNames(8)='Step08 -10,00-sys1-0001_0';
      fileNames(9)='Step09 -20,00-sys1-0001_0';
      fileNames(10)='Step10 10,10-sys1-0001_0';
      fileNames(11)='Step11 20,20-sys1-0001_0';
      fileNames(12)='Step12 -10,-10-sys1-0001_0';
      fileNames(13)='Step13 -20,-20-sys1-0001_0';
      fileNames(14)='Step14 10,-10-sys1-0001_0';
      fileNames(15)='Step15 20,-20-sys1-0001_0';
      fileNames(16)='Step16 -10,10-sys1-0001_0';
      fileNames(17)='Step17 -20,20-sys1-0001_0';
      fileNames(18)='Step18 00,00-sys1-0001_0';      
      dataSet = "1";
      groupNum = "02";

    case 212  %Lava system 1-0002
      testDir = 'Lava\Sys1-35mm';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys1-0002_0';
      fileNames(2)='Step02 00,-10-sys1-0002_0';
      fileNames(3)='Step03 00,-20-sys1-0002_0';
      fileNames(4)='Step04 00,10-sys1-0002_0';
      fileNames(5)='Step05 00,20-sys1-0002_0';
      fileNames(6)='Step06 10,00-sys1-0002_0';
      fileNames(7)='Step07 20,00-sys1-0002_0';
      fileNames(8)='Step08 -10,00-sys1-0002_0';
      fileNames(9)='Step09 -20,00-sys1-0002_0';
      fileNames(10)='Step10 10,10-sys1-0002_0';
      fileNames(11)='Step11 20,20-sys1-0002_0';
      fileNames(12)='Step12 -10,-10-sys1-0002_0';
      fileNames(13)='Step13 -20,-20-sys1-0002_0';
      fileNames(14)='Step14 10,-10-sys1-0002_0';
      fileNames(15)='Step15 20,-20-sys1-0002_0';
      fileNames(16)='Step16 -10,10-sys1-0002_0';
      fileNames(17)='Step17 -20,20-sys1-0002_0';
      fileNames(18)='Step18 00,00-sys1-0002_0';   
      dataSet = "2";
      groupNum = "02";
      
    case 213  %Lava system 1-0003
      testDir = 'Lava\Sys1-35mm';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys1-0003_0';
      fileNames(2)='Step02 00,-10-sys1-0003_0';
      fileNames(3)='Step03 00,-20-sys1-0003_0';
      fileNames(4)='Step04 00,10-sys1-0003_0';
      fileNames(5)='Step05 00,20-sys1-0003_0';
      fileNames(6)='Step06 10,00-sys1-0003_0';
      fileNames(7)='Step07 20,00-sys1-0003_0';
      fileNames(8)='Step08 -10,00-sys1-0003_0';
      fileNames(9)='Step09 -20,00-sys1-0003_0';
      fileNames(10)='Step10 10,10-sys1-0003_0';
      fileNames(11)='Step11 20,20-sys1-0003_0';
      fileNames(12)='Step12 -10,-10-sys1-0003_0';
      fileNames(13)='Step13 -20,-20-sys1-0003_0';
      fileNames(14)='Step14 10,-10-sys1-0003_0';
      fileNames(15)='Step15 20,-20-sys1-0003_0';
      fileNames(16)='Step16 -10,10-sys1-0003_0';
      fileNames(17)='Step17 -20,20-sys1-0003_0';
      fileNames(18)='Step18 00,00-sys1-0003_0'; 
      dataSet = "3";
      groupNum = "02";
      
    case 214  %Lava system 1-0004
      testDir = 'Lava\Sys1-35mm';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys1-0004_0';
      fileNames(2)='Step02 00,-10-sys1-0004_0';
      fileNames(3)='Step03 00,-20-sys1-0004_0';
      fileNames(4)='Step04 00,10-sys1-0004_0';
      fileNames(5)='Step05 00,20-sys1-0004_0';
      fileNames(6)='Step06 10,00-sys1-0004_0';
      fileNames(7)='Step07 20,00-sys1-0004_0';
      fileNames(8)='Step08 -10,00-sys1-0004_0';
      fileNames(9)='Step09 -20,00-sys1-0004_0';
      fileNames(10)='Step10 10,10-sys1-0004_0';
      fileNames(11)='Step11 20,20-sys1-0004_0';
      fileNames(12)='Step12 -10,-10-sys1-0004_0';
      fileNames(13)='Step13 -20,-20-sys1-0004_0';
      fileNames(14)='Step14 10,-10-sys1-0004_0';
      fileNames(15)='Step15 20,-20-sys1-0004_0';
      fileNames(16)='Step16 -10,10-sys1-0004_0';
      fileNames(17)='Step17 -20,20-sys1-0004_0';
      fileNames(18)='Step18 00,00-sys1-0004_0';            
      dataSet = "4";
      groupNum = "02";
      
    case 220  %Lava system 2-0000
      testDir = 'Lava\Sys2-16mm';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys2-0000_0';
      fileNames(2)='Step02 00,-10-sys2-0000_0';
      fileNames(3)='Step03 00,-20-sys2-0000_0';
      fileNames(4)='Step04 00,10-sys2-0000_0';
      fileNames(5)='Step05 00,20-sys2-0000_0';
      fileNames(6)='Step06 10,00-sys2-0000_0';
      fileNames(7)='Step07 20,00-sys2-0000_0';
      fileNames(8)='Step08 -10,00-sys2-0000_0';
      fileNames(9)='Step09 -20,00-sys2-0000_0';
      fileNames(10)='Step10 10,10-sys2-0000_0';
      fileNames(11)='Step11 20,20-sys2-0000_0';
      fileNames(12)='Step12 -10,-10-sys2-0000_0';
      fileNames(13)='Step13 -20,-20-sys2-0000_0';
      fileNames(14)='Step14 10,-10-sys2-0000_0';
      fileNames(15)='Step15 20,-20-sys2-0000_0';
      fileNames(16)='Step16 -10,10-sys2-0000_0';
      fileNames(17)='Step17 -20,20-sys2-0000_0';
      fileNames(18)='Step18 00,00-sys2-0000_0';
      dataSet = "0";
      groupNum = "02";
      
    case 221  %Lava system 2-0001
      testDir = 'Lava\Sys2-16mm';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys2-0001_0';
      fileNames(2)='Step02 00,-10-sys2-0001_0';
      fileNames(3)='Step03 00,-20-sys2-0001_0';
      fileNames(4)='Step04 00,10-sys2-0001_0';
      fileNames(5)='Step05 00,20-sys2-0001_0';
      fileNames(6)='Step06 10,00-sys2-0001_0';
      fileNames(7)='Step07 20,00-sys2-0001_0';
      fileNames(8)='Step08 -10,00-sys2-0001_0';
      fileNames(9)='Step09 -20,00-sys2-0001_0';
      fileNames(10)='Step10 10,10-sys2-0001_0';
      fileNames(11)='Step11 20,20-sys2-0001_0';
      fileNames(12)='Step12 -10,-10-sys2-0001_0';
      fileNames(13)='Step13 -20,-20-sys2-0001_0';
      fileNames(14)='Step14 10,-10-sys2-0001_0';
      fileNames(15)='Step15 20,-20-sys2-0001_0';
      fileNames(16)='Step16 -10,10-sys2-0001_0';
      fileNames(17)='Step17 -20,20-sys2-0001_0';
      fileNames(18)='Step18 00,00-sys2-0001_0';      
      dataSet = "1";
      groupNum = "02";

    case 222  %Lava system 2-0002
      testDir = 'Lava\Sys2-16mm';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys2-0002_0';
      fileNames(2)='Step02 00,-10-sys2-0002_0';
      fileNames(3)='Step03 00,-20-sys2-0002_0';
      fileNames(4)='Step04 00,10-sys2-0002_0';
      fileNames(5)='Step05 00,20-sys2-0002_0';
      fileNames(6)='Step06 10,00-sys2-0002_0';
      fileNames(7)='Step07 20,00-sys2-0002_0';
      fileNames(8)='Step08 -10,00-sys2-0002_0';
      fileNames(9)='Step09 -20,00-sys2-0002_0';
      fileNames(10)='Step10 10,10-sys2-0002_0';
      fileNames(11)='Step11 20,20-sys2-0002_0';
      fileNames(12)='Step12 -10,-10-sys2-0002_0';
      fileNames(13)='Step13 -20,-20-sys2-0002_0';
      fileNames(14)='Step14 10,-10-sys2-0002_0';
      fileNames(15)='Step15 20,-20-sys2-0002_0';
      fileNames(16)='Step16 -10,10-sys2-0002_0';
      fileNames(17)='Step17 -20,20-sys2-0002_0';
      fileNames(18)='Step18 00,00-sys2-0002_0';   
      dataSet = "2";
      groupNum = "02";
      
    case 223  %Lava system 2-0003
      testDir = 'Lava\Sys2-16mm';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys2-0003_0';
      fileNames(2)='Step02 00,-10-sys2-0003_0';
      fileNames(3)='Step03 00,-20-sys2-0003_0';
      fileNames(4)='Step04 00,10-sys2-0003_0';
      fileNames(5)='Step05 00,20-sys2-0003_0';
      fileNames(6)='Step06 10,00-sys2-0003_0';
      fileNames(7)='Step07 20,00-sys2-0003_0';
      fileNames(8)='Step08 -10,00-sys2-0003_0';
      fileNames(9)='Step09 -20,00-sys2-0003_0';
      fileNames(10)='Step10 10,10-sys2-0003_0';
      fileNames(11)='Step11 20,20-sys2-0003_0';
      fileNames(12)='Step12 -10,-10-sys2-0003_0';
      fileNames(13)='Step13 -20,-20-sys2-0003_0';
      fileNames(14)='Step14 10,-10-sys2-0003_0';
      fileNames(15)='Step15 20,-20-sys2-0003_0';
      fileNames(16)='Step16 -10,10-sys2-0003_0';
      fileNames(17)='Step17 -20,20-sys2-0003_0';
      fileNames(18)='Step18 00,00-sys2-0003_0'; 
      dataSet = "3";
      groupNum = "02";
      
    case 224  %Lava system 2-0004
      testDir = 'Lava\Sys2-16mm';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step01 00,00-sys2-0004_0';
      fileNames(2)='Step02 00,-10-sys2-0004_0';
      fileNames(3)='Step03 00,-20-sys2-0004_0';
      fileNames(4)='Step04 00,10-sys2-0004_0';
      fileNames(5)='Step05 00,20-sys2-0004_0';
      fileNames(6)='Step06 10,00-sys2-0004_0';
      fileNames(7)='Step07 20,00-sys2-0004_0';
      fileNames(8)='Step08 -10,00-sys2-0004_0';
      fileNames(9)='Step09 -20,00-sys2-0004_0';
      fileNames(10)='Step10 10,10-sys2-0004_0';
      fileNames(11)='Step11 20,20-sys2-0004_0';
      fileNames(12)='Step12 -10,-10-sys2-0004_0';
      fileNames(13)='Step13 -20,-20-sys2-0004_0';
      fileNames(14)='Step14 10,-10-sys2-0004_0';
      fileNames(15)='Step15 20,-20-sys2-0004_0';
      fileNames(16)='Step16 -10,10-sys2-0004_0';
      fileNames(17)='Step17 -20,20-sys2-0004_0';
      fileNames(18)='Step18 00,00-sys2-0004_0';      
      dataSet = "4";
      groupNum = "02";
      
      %% Grewer     
  case 310  %Grewer system 1-0000
      testDir = 'Grewer\Export_35mm_sub21_st1_2ndOrder_Set0_Matlab';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "0";
      groupNum = "03";
      
    case 311  %Grewer system 1-0001
      testDir = 'Grewer\Export_35mm_sub21_st1_2ndOrder_Set1_Matlab';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "1";
      groupNum = "03";
      
    case 312  %Grewer system 1-0002
      testDir = 'Grewer\Export_35mm_sub21_st1_2ndOrder_Set2_Matlab';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "2";
      groupNum = "03";
      
    case 313  %Grewer system 1-0003
      testDir = 'Grewer\Export_35mm_sub21_st1_2ndOrder_Set3_Matlab';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "3";
      groupNum = "03";
      
    case 314  %Grewer system 1-0004
      testDir = 'Grewer\Export_35mm_sub21_st1_2ndOrder_Set4_Matlab';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "4";
      groupNum = "03";
      
      
      %%%%% Added by Waqas
      
      
  case 320  %Grewer system 2-0000
      testDir = 'Grewer\Export_16mm_sub21_st1_2ndOrder_Set0_Matlab';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "0";
      groupNum = "03";
      
    case 321  %Grewer system 2-0001
      testDir = 'Grewer\Export_16mm_sub21_st1_2ndOrder_Set1_Matlab';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "1";
      groupNum = "03";
      
    case 322  %Grewer system 2-0002
      testDir = 'Grewer\Export_16mm_sub21_st1_2ndOrder_Set2_Matlab';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "2";
      groupNum = "03";
      
    case 323  %Grewer system 2-0003
      testDir = 'Grewer\Export_16mm_sub21_st1_2ndOrder_Set3_Matlab';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "3";
      groupNum = "03";
      
    case 324  %Grewer system 2-0004
      testDir = 'Grewer\Export_16mm_sub21_st1_2ndOrder_Set4_Matlab';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step1';
      fileNames(2)='Step2';
      fileNames(3)='Step3';
      fileNames(4)='Step4';
      fileNames(5)='Step5';
      fileNames(6)='Step6';
      fileNames(7)='Step7';
      fileNames(8)='Step8';
      fileNames(9)='Step9';
      fileNames(10)='Step10';
      fileNames(11)='Step11';
      fileNames(12)='Step12';
      fileNames(13)='Step13';
      fileNames(14)='Step14';
      fileNames(15)='Step15';
      fileNames(16)='Step16';
      fileNames(17)='Step17';
      fileNames(18)='Step18';      
      dataSet = "4";
      groupNum = "03";
      
      
     %% DenTec
      case 410  %DenTec system 1-0000
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 0';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_1';
      fileNames(2)='Dantec_16mm_1pixel_step_2';
      fileNames(3)='Dantec_16mm_1pixel_step_3';
      fileNames(4)='Dantec_16mm_1pixel_step_4';
      fileNames(5)='Dantec_16mm_1pixel_step_5';
      fileNames(6)='Dantec_16mm_1pixel_step_6';
      fileNames(7)='Dantec_16mm_1pixel_step_7';
      fileNames(8)='Dantec_16mm_1pixel_step_8';
      fileNames(9)='Dantec_16mm_1pixel_step_9';
      fileNames(10)='Dantec_16mm_1pixel_step_10';
      fileNames(11)='Dantec_16mm_1pixel_step_11';
      fileNames(12)='Dantec_16mm_1pixel_step_12';
      fileNames(13)='Dantec_16mm_1pixel_step_13';
      fileNames(14)='Dantec_16mm_1pixel_step_14';
      fileNames(15)='Dantec_16mm_1pixel_step_15';
      fileNames(16)='Dantec_16mm_1pixel_step_16';
      fileNames(17)='Dantec_16mm_1pixel_step_17';
      fileNames(18)='Dantec_16mm_1pixel_step_18';      
      dataSet = "1";
      groupNum = "04";
      
      case 411  %DenTec system 1-0001
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 1';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_19';
      fileNames(2)='Dantec_16mm_1pixel_step_20';
      fileNames(3)='Dantec_16mm_1pixel_step_21';
      fileNames(4)='Dantec_16mm_1pixel_step_22';
      fileNames(5)='Dantec_16mm_1pixel_step_23';
      fileNames(6)='Dantec_16mm_1pixel_step_24';
      fileNames(7)='Dantec_16mm_1pixel_step_25';
      fileNames(8)='Dantec_16mm_1pixel_step_26';
      fileNames(9)='Dantec_16mm_1pixel_step_27';
      fileNames(10)='Dantec_16mm_1pixel_step_28';
      fileNames(11)='Dantec_16mm_1pixel_step_29';
      fileNames(12)='Dantec_16mm_1pixel_step_30';
      fileNames(13)='Dantec_16mm_1pixel_step_31';
      fileNames(14)='Dantec_16mm_1pixel_step_32';
      fileNames(15)='Dantec_16mm_1pixel_step_33';
      fileNames(16)='Dantec_16mm_1pixel_step_34';
      fileNames(17)='Dantec_16mm_1pixel_step_35';
      fileNames(18)='Dantec_16mm_1pixel_step_36';      
      dataSet = "2";
      groupNum = "04";
      
      case 412  %DenTec system 1-0002
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 2';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_37';
      fileNames(2)='Dantec_16mm_1pixel_step_38';
      fileNames(3)='Dantec_16mm_1pixel_step_39';
      fileNames(4)='Dantec_16mm_1pixel_step_40';
      fileNames(5)='Dantec_16mm_1pixel_step_41';
      fileNames(6)='Dantec_16mm_1pixel_step_42';
      fileNames(7)='Dantec_16mm_1pixel_step_43';
      fileNames(8)='Dantec_16mm_1pixel_step_44';
      fileNames(9)='Dantec_16mm_1pixel_step_45';
      fileNames(10)='Dantec_16mm_1pixel_step_46';
      fileNames(11)='Dantec_16mm_1pixel_step_47';
      fileNames(12)='Dantec_16mm_1pixel_step_48';
      fileNames(13)='Dantec_16mm_1pixel_step_49';
      fileNames(14)='Dantec_16mm_1pixel_step_50';
      fileNames(15)='Dantec_16mm_1pixel_step_51';
      fileNames(16)='Dantec_16mm_1pixel_step_52';
      fileNames(17)='Dantec_16mm_1pixel_step_53';
      fileNames(18)='Dantec_16mm_1pixel_step_54';      
      dataSet = "3";
      groupNum = "04";
      
      case 413  %DenTec system 1-0003
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 3';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_55';
      fileNames(2)='Dantec_16mm_1pixel_step_56';
      fileNames(3)='Dantec_16mm_1pixel_step_57';
      fileNames(4)='Dantec_16mm_1pixel_step_58';
      fileNames(5)='Dantec_16mm_1pixel_step_59';
      fileNames(6)='Dantec_16mm_1pixel_step_60';
      fileNames(7)='Dantec_16mm_1pixel_step_61';
      fileNames(8)='Dantec_16mm_1pixel_step_62';
      fileNames(9)='Dantec_16mm_1pixel_step_63';
      fileNames(10)='Dantec_16mm_1pixel_step_64';
      fileNames(11)='Dantec_16mm_1pixel_step_65';
      fileNames(12)='Dantec_16mm_1pixel_step_66';
      fileNames(13)='Dantec_16mm_1pixel_step_67';
      fileNames(14)='Dantec_16mm_1pixel_step_68';
      fileNames(15)='Dantec_16mm_1pixel_step_69';
      fileNames(16)='Dantec_16mm_1pixel_step_70';
      fileNames(17)='Dantec_16mm_1pixel_step_71';
      fileNames(18)='Dantec_16mm_1pixel_step_72';      
      dataSet = "4";
      groupNum = "04";
      
      case 414  %DenTec system 1-0004
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 4';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_73';
      fileNames(2)='Dantec_16mm_1pixel_step_74';
      fileNames(3)='Dantec_16mm_1pixel_step_75';
      fileNames(4)='Dantec_16mm_1pixel_step_76';
      fileNames(5)='Dantec_16mm_1pixel_step_77';
      fileNames(6)='Dantec_16mm_1pixel_step_78';
      fileNames(7)='Dantec_16mm_1pixel_step_79';
      fileNames(8)='Dantec_16mm_1pixel_step_80';
      fileNames(9)='Dantec_16mm_1pixel_step_81';
      fileNames(10)='Dantec_16mm_1pixel_step_82';
      fileNames(11)='Dantec_16mm_1pixel_step_83';
      fileNames(12)='Dantec_16mm_1pixel_step_84';
      fileNames(13)='Dantec_16mm_1pixel_step_85';
      fileNames(14)='Dantec_16mm_1pixel_step_86';
      fileNames(15)='Dantec_16mm_1pixel_step_87';
      fileNames(16)='Dantec_16mm_1pixel_step_88';
      fileNames(17)='Dantec_16mm_1pixel_step_89';
      fileNames(18)='Dantec_16mm_1pixel_step_90';      
      dataSet = "5";
      groupNum = "04";
      
      
     case 420  %DenTec system 2-0000
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 0';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_1';
      fileNames(2)='Dantec_16mm_1pixel_step_2';
      fileNames(3)='Dantec_16mm_1pixel_step_3';
      fileNames(4)='Dantec_16mm_1pixel_step_4';
      fileNames(5)='Dantec_16mm_1pixel_step_5';
      fileNames(6)='Dantec_16mm_1pixel_step_6';
      fileNames(7)='Dantec_16mm_1pixel_step_7';
      fileNames(8)='Dantec_16mm_1pixel_step_8';
      fileNames(9)='Dantec_16mm_1pixel_step_9';
      fileNames(10)='Dantec_16mm_1pixel_step_10';
      fileNames(11)='Dantec_16mm_1pixel_step_11';
      fileNames(12)='Dantec_16mm_1pixel_step_12';
      fileNames(13)='Dantec_16mm_1pixel_step_13';
      fileNames(14)='Dantec_16mm_1pixel_step_14';
      fileNames(15)='Dantec_16mm_1pixel_step_15';
      fileNames(16)='Dantec_16mm_1pixel_step_16';
      fileNames(17)='Dantec_16mm_1pixel_step_17';
      fileNames(18)='Dantec_16mm_1pixel_step_18';      
      dataSet = "1";
      groupNum = "04";
      
      
      
      
      case 421  %DenTec system 2-0001
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 1';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_19';
      fileNames(2)='Dantec_16mm_1pixel_step_20';
      fileNames(3)='Dantec_16mm_1pixel_step_21';
      fileNames(4)='Dantec_16mm_1pixel_step_22';
      fileNames(5)='Dantec_16mm_1pixel_step_23';
      fileNames(6)='Dantec_16mm_1pixel_step_24';
      fileNames(7)='Dantec_16mm_1pixel_step_25';
      fileNames(8)='Dantec_16mm_1pixel_step_26';
      fileNames(9)='Dantec_16mm_1pixel_step_27';
      fileNames(10)='Dantec_16mm_1pixel_step_28';
      fileNames(11)='Dantec_16mm_1pixel_step_29';
      fileNames(12)='Dantec_16mm_1pixel_step_30';
      fileNames(13)='Dantec_16mm_1pixel_step_31';
      fileNames(14)='Dantec_16mm_1pixel_step_32';
      fileNames(15)='Dantec_16mm_1pixel_step_33';
      fileNames(16)='Dantec_16mm_1pixel_step_34';
      fileNames(17)='Dantec_16mm_1pixel_step_35';
      fileNames(18)='Dantec_16mm_1pixel_step_36';      
      dataSet = "2";
      groupNum = "04";
      
      case 422  %DenTec system 2-0002
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 2';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_37';
      fileNames(2)='Dantec_16mm_1pixel_step_38';
      fileNames(3)='Dantec_16mm_1pixel_step_39';
      fileNames(4)='Dantec_16mm_1pixel_step_40';
      fileNames(5)='Dantec_16mm_1pixel_step_41';
      fileNames(6)='Dantec_16mm_1pixel_step_42';
      fileNames(7)='Dantec_16mm_1pixel_step_43';
      fileNames(8)='Dantec_16mm_1pixel_step_44';
      fileNames(9)='Dantec_16mm_1pixel_step_45';
      fileNames(10)='Dantec_16mm_1pixel_step_46';
      fileNames(11)='Dantec_16mm_1pixel_step_47';
      fileNames(12)='Dantec_16mm_1pixel_step_48';
      fileNames(13)='Dantec_16mm_1pixel_step_49';
      fileNames(14)='Dantec_16mm_1pixel_step_50';
      fileNames(15)='Dantec_16mm_1pixel_step_51';
      fileNames(16)='Dantec_16mm_1pixel_step_52';
      fileNames(17)='Dantec_16mm_1pixel_step_53';
      fileNames(18)='Dantec_16mm_1pixel_step_54';      
      dataSet = "3";
      groupNum = "04";
      
      case 423  %DenTec system 2-0003
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 3';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_55';
      fileNames(2)='Dantec_16mm_1pixel_step_56';
      fileNames(3)='Dantec_16mm_1pixel_step_57';
      fileNames(4)='Dantec_16mm_1pixel_step_58';
      fileNames(5)='Dantec_16mm_1pixel_step_59';
      fileNames(6)='Dantec_16mm_1pixel_step_60';
      fileNames(7)='Dantec_16mm_1pixel_step_61';
      fileNames(8)='Dantec_16mm_1pixel_step_62';
      fileNames(9)='Dantec_16mm_1pixel_step_63';
      fileNames(10)='Dantec_16mm_1pixel_step_64';
      fileNames(11)='Dantec_16mm_1pixel_step_65';
      fileNames(12)='Dantec_16mm_1pixel_step_66';
      fileNames(13)='Dantec_16mm_1pixel_step_67';
      fileNames(14)='Dantec_16mm_1pixel_step_68';
      fileNames(15)='Dantec_16mm_1pixel_step_69';
      fileNames(16)='Dantec_16mm_1pixel_step_70';
      fileNames(17)='Dantec_16mm_1pixel_step_71';
      fileNames(18)='Dantec_16mm_1pixel_step_72';      
      dataSet = "4";
      groupNum = "04";
      
      case 424  %DenTec system 2-0004
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 4';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_73';
      fileNames(2)='Dantec_16mm_1pixel_step_74';
      fileNames(3)='Dantec_16mm_1pixel_step_75';
      fileNames(4)='Dantec_16mm_1pixel_step_76';
      fileNames(5)='Dantec_16mm_1pixel_step_77';
      fileNames(6)='Dantec_16mm_1pixel_step_78';
      fileNames(7)='Dantec_16mm_1pixel_step_79';
      fileNames(8)='Dantec_16mm_1pixel_step_80';
      fileNames(9)='Dantec_16mm_1pixel_step_81';
      fileNames(10)='Dantec_16mm_1pixel_step_82';
      fileNames(11)='Dantec_16mm_1pixel_step_83';
      fileNames(12)='Dantec_16mm_1pixel_step_84';
      fileNames(13)='Dantec_16mm_1pixel_step_85';
      fileNames(14)='Dantec_16mm_1pixel_step_86';
      fileNames(15)='Dantec_16mm_1pixel_step_87';
      fileNames(16)='Dantec_16mm_1pixel_step_88';
      fileNames(17)='Dantec_16mm_1pixel_step_89';
      fileNames(18)='Dantec_16mm_1pixel_step_90';      
      dataSet = "5";
      groupNum = "04";
      
     %% LaVision
      case 510  %LaVision system 1-0000
      testDir = 'LaVision\LV_35mm_Step-01_MAT\dataset0';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_0';
      fileNames(2)='Step_1';
      fileNames(3)='Step_2';
      fileNames(4)='Step_3';
      fileNames(5)='Step_4';
      fileNames(6)='Step_5';
      fileNames(7)='Step_6';
      fileNames(8)='Step_7';
      fileNames(9)='Step_8';
      fileNames(10)='Step_9';
      fileNames(11)='Step_10';
      fileNames(12)='Step_11';
      fileNames(13)='Step_12';
      fileNames(14)='Step_13';
      fileNames(15)='Step_14';
      fileNames(16)='Step_15';
      fileNames(17)='Step_16';
      fileNames(18)='Step_17';      
      dataSet = "0";
      groupNum = "05";
      
      case 511  %LaVision system 1-0004
      testDir = 'LaVision\LV_35mm_Step-01_MAT\dataset1';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_18';
      fileNames(2)='Step_19';
      fileNames(3)='Step_20';
      fileNames(4)='Step_21';
      fileNames(5)='Step_22';
      fileNames(6)='Step_23';
      fileNames(7)='Step_24';
      fileNames(8)='Step_25';
      fileNames(9)='Step_26';
      fileNames(10)='Step_27';
      fileNames(11)='Step_28';
      fileNames(12)='Step_29';
      fileNames(13)='Step_30';
      fileNames(14)='Step_31';
      fileNames(15)='Step_32';
      fileNames(16)='Step_33';
      fileNames(17)='Step_34';
      fileNames(18)='Step_35';      
      dataSet = "1";
      groupNum = "05";
      
      case 512  %LaVision system 1-0002
      testDir = 'LaVision\LV_35mm_Step-01_MAT\dataset2';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_36';
      fileNames(2)='Step_37';
      fileNames(3)='Step_38';
      fileNames(4)='Step_39';
      fileNames(5)='Step_40';
      fileNames(6)='Step_41';
      fileNames(7)='Step_42';
      fileNames(8)='Step_43';
      fileNames(9)='Step_44';
      fileNames(10)='Step_45';
      fileNames(11)='Step_46';
      fileNames(12)='Step_47';
      fileNames(13)='Step_48';
      fileNames(14)='Step_49';
      fileNames(15)='Step_50';
      fileNames(16)='Step_51';
      fileNames(17)='Step_52';
      fileNames(18)='Step_53';      
      dataSet = "2";
      groupNum = "05";
      
      
      case 513  %LaVision system 1-0003
      testDir = 'LaVision\LV_35mm_Step-01_MAT\dataset3';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_54';
      fileNames(2)='Step_55';
      fileNames(3)='Step_56';
      fileNames(4)='Step_57';
      fileNames(5)='Step_58';
      fileNames(6)='Step_59';
      fileNames(7)='Step_60';
      fileNames(8)='Step_61';
      fileNames(9)='Step_62';
      fileNames(10)='Step_63';
      fileNames(11)='Step_64';
      fileNames(12)='Step_65';
      fileNames(13)='Step_66';
      fileNames(14)='Step_67';
      fileNames(15)='Step_68';
      fileNames(16)='Step_69';
      fileNames(17)='Step_70';
      fileNames(18)='Step_71';      
      dataSet = "3";
      groupNum = "05";
      
      case 514  %LaVision system 1-0004
      testDir = 'LaVision\LV_35mm_Step-01_MAT\dataset4';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_72';
      fileNames(2)='Step_73';
      fileNames(3)='Step_74';
      fileNames(4)='Step_75';
      fileNames(5)='Step_76';
      fileNames(6)='Step_77';
      fileNames(7)='Step_78';
      fileNames(8)='Step_79';
      fileNames(9)='Step_80';
      fileNames(10)='Step_81';
      fileNames(11)='Step_82';
      fileNames(12)='Step_83';
      fileNames(13)='Step_84';
      fileNames(14)='Step_85';
      fileNames(15)='Step_86';
      fileNames(16)='Step_87';
      fileNames(17)='Step_88';
      fileNames(18)='Step_89';      
      dataSet = "4";
      groupNum = "05";
      
      
      case 520  %LaVision system 2-0000
      testDir = 'LaVision\LV_16mm_Step-01_MAT\dataset0';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_0';
      fileNames(2)='Step_1';
      fileNames(3)='Step_2';
      fileNames(4)='Step_3';
      fileNames(5)='Step_4';
      fileNames(6)='Step_5';
      fileNames(7)='Step_6';
      fileNames(8)='Step_7';
      fileNames(9)='Step_8';
      fileNames(10)='Step_9';
      fileNames(11)='Step_10';
      fileNames(12)='Step_11';
      fileNames(13)='Step_12';
      fileNames(14)='Step_13';
      fileNames(15)='Step_14';
      fileNames(16)='Step_15';
      fileNames(17)='Step_16';
      fileNames(18)='Step_17';      
      dataSet = "0";
      groupNum = "05";
      
      case 521  %LaVision system 2-0004
      testDir = 'LaVision\LV_16mm_Step-01_MAT\dataset1';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_18';
      fileNames(2)='Step_19';
      fileNames(3)='Step_20';
      fileNames(4)='Step_21';
      fileNames(5)='Step_22';
      fileNames(6)='Step_23';
      fileNames(7)='Step_24';
      fileNames(8)='Step_25';
      fileNames(9)='Step_26';
      fileNames(10)='Step_27';
      fileNames(11)='Step_28';
      fileNames(12)='Step_29';
      fileNames(13)='Step_30';
      fileNames(14)='Step_31';
      fileNames(15)='Step_32';
      fileNames(16)='Step_33';
      fileNames(17)='Step_34';
      fileNames(18)='Step_35';      
      dataSet = "1";
      groupNum = "05";
      
      case 522  %LaVision system 2-0002
      testDir = 'LaVision\LV_16mm_Step-01_MAT\dataset2';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_36';
      fileNames(2)='Step_37';
      fileNames(3)='Step_38';
      fileNames(4)='Step_39';
      fileNames(5)='Step_40';
      fileNames(6)='Step_41';
      fileNames(7)='Step_42';
      fileNames(8)='Step_43';
      fileNames(9)='Step_44';
      fileNames(10)='Step_45';
      fileNames(11)='Step_46';
      fileNames(12)='Step_47';
      fileNames(13)='Step_48';
      fileNames(14)='Step_49';
      fileNames(15)='Step_50';
      fileNames(16)='Step_51';
      fileNames(17)='Step_52';
      fileNames(18)='Step_53';      
      dataSet = "2";
      groupNum = "05";
      
      case 523  %LaVision system 2-0003
      testDir = 'LaVision\LV_16mm_Step-01_MAT\dataset3';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_54';
      fileNames(2)='Step_55';
      fileNames(3)='Step_56';
      fileNames(4)='Step_57';
      fileNames(5)='Step_58';
      fileNames(6)='Step_59';
      fileNames(7)='Step_60';
      fileNames(8)='Step_61';
      fileNames(9)='Step_62';
      fileNames(10)='Step_63';
      fileNames(11)='Step_64';
      fileNames(12)='Step_65';
      fileNames(13)='Step_66';
      fileNames(14)='Step_67';
      fileNames(15)='Step_68';
      fileNames(16)='Step_69';
      fileNames(17)='Step_70';
      fileNames(18)='Step_71';      
      dataSet = "3";
      groupNum = "05";
      
      case 524  %LaVision system 2-0004
      testDir = 'LaVision\LV_16mm_Step-01_MAT\dataset4';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Step_72';
      fileNames(2)='Step_73';
      fileNames(3)='Step_74';
      fileNames(4)='Step_75';
      fileNames(5)='Step_76';
      fileNames(6)='Step_77';
      fileNames(7)='Step_78';
      fileNames(8)='Step_79';
      fileNames(9)='Step_80';
      fileNames(10)='Step_81';
      fileNames(11)='Step_82';
      fileNames(12)='Step_83';
      fileNames(13)='Step_84';
      fileNames(14)='Step_85';
      fileNames(15)='Step_86';
      fileNames(16)='Step_87';
      fileNames(17)='Step_88';
      fileNames(18)='Step_89';      
      dataSet = "4";
      groupNum = "05";


      %% MatchID
      case 610  %MatchID system 1-0000
      testDir = 'MatchID\35mm\dataset0';
      sysNum = 1;
      fileNames=repmat(" ",2,1);
      fileNames(1)='Step01';
      fileNames(2)='Step15';
%       fileNames(3)='Dantec_16mm_1pixel_step_3';
%       fileNames(4)='Dantec_16mm_1pixel_step_4';
%       fileNames(5)='Dantec_16mm_1pixel_step_5';
%       fileNames(6)='Dantec_16mm_1pixel_step_6';
%       fileNames(7)='Dantec_16mm_1pixel_step_7';
%       fileNames(8)='Dantec_16mm_1pixel_step_8';
%       fileNames(9)='Dantec_16mm_1pixel_step_9';
%       fileNames(10)='Dantec_16mm_1pixel_step_10';
%       fileNames(11)='Dantec_16mm_1pixel_step_11';
%       fileNames(12)='Dantec_16mm_1pixel_step_12';
%       fileNames(13)='Dantec_16mm_1pixel_step_13';
%       fileNames(14)='Dantec_16mm_1pixel_step_14';
%       fileNames(15)='Dantec_16mm_1pixel_step_15';
%       fileNames(16)='Dantec_16mm_1pixel_step_16';
%       fileNames(17)='Dantec_16mm_1pixel_step_17';
%       fileNames(18)='Dantec_16mm_1pixel_step_18';      
      dataSet = "1";
      groupNum = "06";
      
      case 611  %DenTec system 1-0001
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 1';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_19';
      fileNames(2)='Dantec_16mm_1pixel_step_20';
      fileNames(3)='Dantec_16mm_1pixel_step_21';
      fileNames(4)='Dantec_16mm_1pixel_step_22';
      fileNames(5)='Dantec_16mm_1pixel_step_23';
      fileNames(6)='Dantec_16mm_1pixel_step_24';
      fileNames(7)='Dantec_16mm_1pixel_step_25';
      fileNames(8)='Dantec_16mm_1pixel_step_26';
      fileNames(9)='Dantec_16mm_1pixel_step_27';
      fileNames(10)='Dantec_16mm_1pixel_step_28';
      fileNames(11)='Dantec_16mm_1pixel_step_29';
      fileNames(12)='Dantec_16mm_1pixel_step_30';
      fileNames(13)='Dantec_16mm_1pixel_step_31';
      fileNames(14)='Dantec_16mm_1pixel_step_32';
      fileNames(15)='Dantec_16mm_1pixel_step_33';
      fileNames(16)='Dantec_16mm_1pixel_step_34';
      fileNames(17)='Dantec_16mm_1pixel_step_35';
      fileNames(18)='Dantec_16mm_1pixel_step_36';      
      dataSet = "2";
      groupNum = "06";
      
      case 612  %DenTec system 1-0002
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 2';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_37';
      fileNames(2)='Dantec_16mm_1pixel_step_38';
      fileNames(3)='Dantec_16mm_1pixel_step_39';
      fileNames(4)='Dantec_16mm_1pixel_step_40';
      fileNames(5)='Dantec_16mm_1pixel_step_41';
      fileNames(6)='Dantec_16mm_1pixel_step_42';
      fileNames(7)='Dantec_16mm_1pixel_step_43';
      fileNames(8)='Dantec_16mm_1pixel_step_44';
      fileNames(9)='Dantec_16mm_1pixel_step_45';
      fileNames(10)='Dantec_16mm_1pixel_step_46';
      fileNames(11)='Dantec_16mm_1pixel_step_47';
      fileNames(12)='Dantec_16mm_1pixel_step_48';
      fileNames(13)='Dantec_16mm_1pixel_step_49';
      fileNames(14)='Dantec_16mm_1pixel_step_50';
      fileNames(15)='Dantec_16mm_1pixel_step_51';
      fileNames(16)='Dantec_16mm_1pixel_step_52';
      fileNames(17)='Dantec_16mm_1pixel_step_53';
      fileNames(18)='Dantec_16mm_1pixel_step_54';      
      dataSet = "3";
      groupNum = "06";
      
      case 613  %DenTec system 1-0003
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 3';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_55';
      fileNames(2)='Dantec_16mm_1pixel_step_56';
      fileNames(3)='Dantec_16mm_1pixel_step_57';
      fileNames(4)='Dantec_16mm_1pixel_step_58';
      fileNames(5)='Dantec_16mm_1pixel_step_59';
      fileNames(6)='Dantec_16mm_1pixel_step_60';
      fileNames(7)='Dantec_16mm_1pixel_step_61';
      fileNames(8)='Dantec_16mm_1pixel_step_62';
      fileNames(9)='Dantec_16mm_1pixel_step_63';
      fileNames(10)='Dantec_16mm_1pixel_step_64';
      fileNames(11)='Dantec_16mm_1pixel_step_65';
      fileNames(12)='Dantec_16mm_1pixel_step_66';
      fileNames(13)='Dantec_16mm_1pixel_step_67';
      fileNames(14)='Dantec_16mm_1pixel_step_68';
      fileNames(15)='Dantec_16mm_1pixel_step_69';
      fileNames(16)='Dantec_16mm_1pixel_step_70';
      fileNames(17)='Dantec_16mm_1pixel_step_71';
      fileNames(18)='Dantec_16mm_1pixel_step_72';      
      dataSet = "4";
      groupNum = "06";
      
      case 614  %DenTec system 1-0004
      testDir = 'Dantec\35mm_Matdata_1pixels_all_steps\Dataset 4';
      sysNum = 1;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_73';
      fileNames(2)='Dantec_16mm_1pixel_step_74';
      fileNames(3)='Dantec_16mm_1pixel_step_75';
      fileNames(4)='Dantec_16mm_1pixel_step_76';
      fileNames(5)='Dantec_16mm_1pixel_step_77';
      fileNames(6)='Dantec_16mm_1pixel_step_78';
      fileNames(7)='Dantec_16mm_1pixel_step_79';
      fileNames(8)='Dantec_16mm_1pixel_step_80';
      fileNames(9)='Dantec_16mm_1pixel_step_81';
      fileNames(10)='Dantec_16mm_1pixel_step_82';
      fileNames(11)='Dantec_16mm_1pixel_step_83';
      fileNames(12)='Dantec_16mm_1pixel_step_84';
      fileNames(13)='Dantec_16mm_1pixel_step_85';
      fileNames(14)='Dantec_16mm_1pixel_step_86';
      fileNames(15)='Dantec_16mm_1pixel_step_87';
      fileNames(16)='Dantec_16mm_1pixel_step_88';
      fileNames(17)='Dantec_16mm_1pixel_step_89';
      fileNames(18)='Dantec_16mm_1pixel_step_90';      
      dataSet = "5";
      groupNum = "06";
      
      
     case 620  %DenTec system 2-0000
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 0';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_1';
      fileNames(2)='Dantec_16mm_1pixel_step_2';
      fileNames(3)='Dantec_16mm_1pixel_step_3';
      fileNames(4)='Dantec_16mm_1pixel_step_4';
      fileNames(5)='Dantec_16mm_1pixel_step_5';
      fileNames(6)='Dantec_16mm_1pixel_step_6';
      fileNames(7)='Dantec_16mm_1pixel_step_7';
      fileNames(8)='Dantec_16mm_1pixel_step_8';
      fileNames(9)='Dantec_16mm_1pixel_step_9';
      fileNames(10)='Dantec_16mm_1pixel_step_10';
      fileNames(11)='Dantec_16mm_1pixel_step_11';
      fileNames(12)='Dantec_16mm_1pixel_step_12';
      fileNames(13)='Dantec_16mm_1pixel_step_13';
      fileNames(14)='Dantec_16mm_1pixel_step_14';
      fileNames(15)='Dantec_16mm_1pixel_step_15';
      fileNames(16)='Dantec_16mm_1pixel_step_16';
      fileNames(17)='Dantec_16mm_1pixel_step_17';
      fileNames(18)='Dantec_16mm_1pixel_step_18';      
      dataSet = "1";
      groupNum = "06";
      
      
      
      
      case 621  %DenTec system 2-0001
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 1';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_19';
      fileNames(2)='Dantec_16mm_1pixel_step_20';
      fileNames(3)='Dantec_16mm_1pixel_step_21';
      fileNames(4)='Dantec_16mm_1pixel_step_22';
      fileNames(5)='Dantec_16mm_1pixel_step_23';
      fileNames(6)='Dantec_16mm_1pixel_step_24';
      fileNames(7)='Dantec_16mm_1pixel_step_25';
      fileNames(8)='Dantec_16mm_1pixel_step_26';
      fileNames(9)='Dantec_16mm_1pixel_step_27';
      fileNames(10)='Dantec_16mm_1pixel_step_28';
      fileNames(11)='Dantec_16mm_1pixel_step_29';
      fileNames(12)='Dantec_16mm_1pixel_step_30';
      fileNames(13)='Dantec_16mm_1pixel_step_31';
      fileNames(14)='Dantec_16mm_1pixel_step_32';
      fileNames(15)='Dantec_16mm_1pixel_step_33';
      fileNames(16)='Dantec_16mm_1pixel_step_34';
      fileNames(17)='Dantec_16mm_1pixel_step_35';
      fileNames(18)='Dantec_16mm_1pixel_step_36';      
      dataSet = "2";
      groupNum = "06";
      
      case 622  %MatchID system 2-0002
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 2';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_37';
      fileNames(2)='Dantec_16mm_1pixel_step_38';
      fileNames(3)='Dantec_16mm_1pixel_step_39';
      fileNames(4)='Dantec_16mm_1pixel_step_40';
      fileNames(5)='Dantec_16mm_1pixel_step_41';
      fileNames(6)='Dantec_16mm_1pixel_step_42';
      fileNames(7)='Dantec_16mm_1pixel_step_43';
      fileNames(8)='Dantec_16mm_1pixel_step_44';
      fileNames(9)='Dantec_16mm_1pixel_step_45';
      fileNames(10)='Dantec_16mm_1pixel_step_46';
      fileNames(11)='Dantec_16mm_1pixel_step_47';
      fileNames(12)='Dantec_16mm_1pixel_step_48';
      fileNames(13)='Dantec_16mm_1pixel_step_49';
      fileNames(14)='Dantec_16mm_1pixel_step_50';
      fileNames(15)='Dantec_16mm_1pixel_step_51';
      fileNames(16)='Dantec_16mm_1pixel_step_52';
      fileNames(17)='Dantec_16mm_1pixel_step_53';
      fileNames(18)='Dantec_16mm_1pixel_step_54';      
      dataSet = "3";
      groupNum = "06";
      
      case 623  %MatchID system 2-0003
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 3';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_55';
      fileNames(2)='Dantec_16mm_1pixel_step_56';
      fileNames(3)='Dantec_16mm_1pixel_step_57';
      fileNames(4)='Dantec_16mm_1pixel_step_58';
      fileNames(5)='Dantec_16mm_1pixel_step_59';
      fileNames(6)='Dantec_16mm_1pixel_step_60';
      fileNames(7)='Dantec_16mm_1pixel_step_61';
      fileNames(8)='Dantec_16mm_1pixel_step_62';
      fileNames(9)='Dantec_16mm_1pixel_step_63';
      fileNames(10)='Dantec_16mm_1pixel_step_64';
      fileNames(11)='Dantec_16mm_1pixel_step_65';
      fileNames(12)='Dantec_16mm_1pixel_step_66';
      fileNames(13)='Dantec_16mm_1pixel_step_67';
      fileNames(14)='Dantec_16mm_1pixel_step_68';
      fileNames(15)='Dantec_16mm_1pixel_step_69';
      fileNames(16)='Dantec_16mm_1pixel_step_70';
      fileNames(17)='Dantec_16mm_1pixel_step_71';
      fileNames(18)='Dantec_16mm_1pixel_step_72';      
      dataSet = "4";
      groupNum = "06";
      
      case 624  %DenTec system 2-0004
      testDir = 'Dantec\16mm_Matdata_1pixels_all_steps\Dataset 4';
      sysNum = 2;
      fileNames=repmat(" ",18,1);
      fileNames(1)='Dantec_16mm_1pixel_step_73';
      fileNames(2)='Dantec_16mm_1pixel_step_74';
      fileNames(3)='Dantec_16mm_1pixel_step_75';
      fileNames(4)='Dantec_16mm_1pixel_step_76';
      fileNames(5)='Dantec_16mm_1pixel_step_77';
      fileNames(6)='Dantec_16mm_1pixel_step_78';
      fileNames(7)='Dantec_16mm_1pixel_step_79';
      fileNames(8)='Dantec_16mm_1pixel_step_80';
      fileNames(9)='Dantec_16mm_1pixel_step_81';
      fileNames(10)='Dantec_16mm_1pixel_step_82';
      fileNames(11)='Dantec_16mm_1pixel_step_83';
      fileNames(12)='Dantec_16mm_1pixel_step_84';
      fileNames(13)='Dantec_16mm_1pixel_step_85';
      fileNames(14)='Dantec_16mm_1pixel_step_86';
      fileNames(15)='Dantec_16mm_1pixel_step_87';
      fileNames(16)='Dantec_16mm_1pixel_step_88';
      fileNames(17)='Dantec_16mm_1pixel_step_89';
      fileNames(18)='Dantec_16mm_1pixel_step_90';      
      dataSet = "5";
      groupNum = "06";
     
      
      
      
      

      
  end
  
end

