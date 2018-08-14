function [patchSum] = evaluateIntegralImage(ii, row, col, patchSize)
% This function should calculate the sum over the patch centred at row, col
% of size patchSize of the integral image ii

%REPLACE THIS!
L1 = ii(row-patchSize-1,col-patchSize-1,:);
L2 = ii(row-patchSize-1,col+patchSize,:);
L3 = ii(row+patchSize,col+patchSize,:);
L4 = ii(row+patchSize,col-patchSize-1,:);
patchSum = L3 - L2 -L4 + L1;
patchSum = sum(patchSum(:))/(3*(2*patchSize+1)^2);
end