function [M] = StripNan(M)
%Strips out any rows with NAN's
%   Strips out the rows with NAN in any field and returns the result

  Mnan = sum(isnan(M),2);
  for iRow = size(M,1):-1:1
    if Mnan(iRow)~=0
      M(iRow,:)=[];
    end
  end
  
end

