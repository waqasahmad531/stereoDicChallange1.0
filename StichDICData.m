%get the filenames for the test
[FileNameBase, testDir] = DicDataFileNames(2);
testName = testDir;
testDir = [testDir '\'];
DirBase= 'C:\Users\jhelm\Documents\Sabbatical_Work\DIC Challenge Registration\DIC Data\';
testDir = [DirBase testDir];

%process each of the files for the displacement values
for fileIdx = 1:size(FileNameBase,1)

  msg='working on: ' + FileNameBase(fileIdx);
  disp(msg)
  drawnow;
  matFile = testDir+FileNameBase(fileIdx)+'.mat';
  load(matFile);
 
  if fileIdx == 1 
    xi = [reshape(x,[],1);reshape(x_0,[],1);reshape(x_1,[],1);reshape(x_2,[],1);reshape(x_3,[],1);reshape(x_4,[],1)];
    yi = [reshape(y,[],1);reshape(y_0,[],1);reshape(y_1,[],1);reshape(y_2,[],1);reshape(y_3,[],1);reshape(y_4,[],1)];
  end
  
  %Clean up the data for each of the areas
  %compile the data into a single array 
  x = [reshape(x,[],1);reshape(x_0,[],1);reshape(x_1,[],1);reshape(x_2,[],1);reshape(x_3,[],1);reshape(x_4,[],1)];
  y = [reshape(y,[],1);reshape(y_0,[],1);reshape(y_1,[],1);reshape(y_2,[],1);reshape(y_3,[],1);reshape(y_4,[],1)];
  X = [reshape(X,[],1);reshape(X_0,[],1);reshape(X_1,[],1);reshape(X_2,[],1);reshape(X_3,[],1);reshape(X_4,[],1)];
  Y = [reshape(Y,[],1);reshape(Y_0,[],1);reshape(Y_1,[],1);reshape(Y_2,[],1);reshape(Y_3,[],1);reshape(Y_4,[],1)];
  Z = [reshape(Z,[],1);reshape(Z_0,[],1);reshape(Z_1,[],1);reshape(Z_2,[],1);reshape(Z_3,[],1);reshape(Z_4,[],1)];
  U = [reshape(U,[],1);reshape(U_0,[],1);reshape(U_1,[],1);reshape(U_2,[],1);reshape(U_3,[],1);reshape(U_4,[],1)];
  V = [reshape(V,[],1);reshape(V_0,[],1);reshape(V_1,[],1);reshape(V_2,[],1);reshape(V_3,[],1);reshape(V_4,[],1)];
  W = [reshape(W,[],1);reshape(W_0,[],1);reshape(W_1,[],1);reshape(W_2,[],1);reshape(W_3,[],1);reshape(W_4,[],1)];

  A_1 = [x y X Y Z U V W];
  
  %do the arrays have the same xy coordinates
  if ~isequal(xi,x)||~isequal(yi,y)
    disp ('unequal arrays')
    disp (FileNameBase(fileIdx))
    pause
  end    
  
  %Remove any elements with Z>6.4 or Z<-0.1 to get rid of bad data points
  A_1(A_1(:,5)>6.4, :) = [];
  A_1(A_1(:,5)<-0.1, :) = [];
  A_1(A_1(:,5)==0, :) = [];
  DICData = A_1;
  outFile = testDir + FileNameBase(fileIdx) + '_DICData.mat';
  save(outFile,'DICData');

end
