function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(image,row, col,...
    patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

%REPLACE THIS
% the shift distance is the difference between searchWindowSize and
% patchSize
shiftDis = searchWindowSize - patchSize;

% set the offset
offsetsRows = -shiftDis:1:shiftDis;
offsetsCols = -shiftDis:1:shiftDis;

% initialise the distance matrix
distances = zeros(size(offsetsRows,2),size(offsetsCols,2));

% extend the edge of the image to make sure it can work on the border
imgSearch = padarray(image, [searchWindowSize,searchWindowSize],'symmetric','both');
                
% change the row and col index in the extended image
row = row + searchWindowSize;
col = col + searchWindowSize;

% find the ssd value of each shifted patch in the range of offset
for i = 1:size(offsetsRows,2)
    for j = 1:size(offsetsCols,2)
        % get the shifted value of x and y
        rowShift = offsetsRows(i);
        colShift = offsetsCols(j);
        % referenceP is the reference patch
        referenceP = imgSearch(row-patchSize:row+patchSize,col-patchSize:col+patchSize,:);
        % searchP is the patch after shifting
        searchP = imgSearch(row-patchSize+rowShift:row+patchSize+rowShift,col-patchSize+colShift:col+patchSize+colShift,:);
        % temp is the matrix of the difference square between referencep 
        % and searchP
        temp = (referenceP-searchP).^2;
        % distance is the ssd value between searchP and refernenceP
        distances(i,j) = sum(temp(:))/(3*(2*patchSize+1)^2);
        
    end
end
end