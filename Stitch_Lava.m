    %Read the data and then seperate into the sepaerate areas
    DICInputDir ='C:\Users\helmj\Documents\DICe_Challenge\Challenge Data\Lava\16mm-Step1\';
    DICInputFile = char(strcat(DICInputDir, 'Step01 00,00-sys2-0000_0.tif.mat'));
    whos('-file', DICInputFile);
    load(DICInputFile);
    A_1 = DicData;
    %strip out any nan entries
    disp(strcat('-rows before StripNan', num2str(size(A_1,1))));
    A_1 = StripNan(A_1);
    disp(strcat('-rows aafter StripNan', num2str(size(A_1,1))));
    