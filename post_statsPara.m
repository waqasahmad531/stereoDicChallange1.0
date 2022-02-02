function [U,V,W,st] = post_statsPara(data,iFile)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
u = data(:,:,4);
v = data(:,:,5);
w = data(:,:,6);
z = data(:,:,3);
if iFile~=1
    u(z==0) = NaN;
    v(z==0) = NaN;
    w(z==0) = NaN;
end

st(1,:) = [mean(u,'all','omitnan'),...
            std(u,0,'all','omitnan'),...
            min(u,[],'all','omitnan'),...
            max(u,[],'all','omitnan')];
st(2,:) = [mean(v,'all','omitnan'),...
            std(v,0,'all','omitnan'),...
            min(v,[],'all','omitnan'),...
            max(v,[],'all','omitnan')];
st(3,:) = [mean(w,'all','omitnan'),...
            std(w,0,'all','omitnan'),...
            min(w,[],'all','omitnan'),...
            max(w,[],'all','omitnan')];
para = {'mean :';'std : ';'min : ';'max : '};
% for i = 1:3
%     for j = 1:4
%         statText{j,i} = sprintf('%s %0.3f',para{j},st(i,j));
%     end
% end

U = [string(sprintf('%s %0.5f',para{1},st(1,1)));
     string(sprintf('%s %0.5f',para{2},st(1,2)));
     string(sprintf('%s %0.5f',para{3},st(1,3)));
     string(sprintf('%s %0.5f',para{4},st(1,4)))];
 U = vertcat(["    U(mm)    "],U);
 
V = [string(sprintf('%s %0.5f',para{1},st(2,1)));
     string(sprintf('%s %0.5f',para{2},st(2,2)));
     string(sprintf('%s %0.5f',para{3},st(2,3)));
     string(sprintf('%s %0.5f',para{4},st(2,4)))];
V = vertcat(["    V(mm)    "],V);

 W = [string(sprintf('%s %0.5f',para{1},st(3,1)));
     string(sprintf('%s %0.5f',para{2},st(3,2)));
     string(sprintf('%s %0.5f',para{3},st(3,3)));
     string(sprintf('%s %0.5f',para{4},st(3,4)))];
W = vertcat(["    W(mm)    "],W);

end

