function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(image,row,...
    col,patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsX(1) = -1;
% offsetsY(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

% This time, use the integral image method!
% NOTE: Use the 'computeIntegralImage' function developed earlier to
% calculate your integral images
% NOTE: Use the 'evaluateIntegralImage' function to calculate patch sums

%REPLACE THIS
% extend the edge of the image to make sure it can work on the border
windowImage = padarray(image, [searchWindowSize,searchWindowSize],'symmetric','both');

% the shift distance is the difference between searchWindowSize and
% patchSize
shiftDis = searchWindowSize - patchSize;

% set the offset  
offsetsRows = -shiftDis:1:shiftDis;
offsetsCols = -shiftDis:1:shiftDis;

% initialise the distances matrix which is the ssd value between reference
% patch and search patch
distances = zeros(size(offsetsRows,2),size(offsetsCols,2));

% change the row and col index in the extended image
row = row + searchWindowSize;
col = col + searchWindowSize;

% get the search window of the pixel
% rowLeft is the top bound of search window 
rowLeft = row - searchWindowSize;
% colLeft is the left bound of search window
colLeft = col - searchWindowSize;
% rowRight is the bottom bound of search window
rowRight = row + searchWindowSize;
% colRight is the right bound of search window
colRight = col + searchWindowSize;

% imgSearch is the search window of the pixel
imgSearch = windowImage(rowLeft:rowRight,colLeft:colRight,:);

% shiftIm is the image after shifting
shiftIm = zeros(size(imgSearch));
% change the row and col of the original image to the ingSearch 

for dx = 1:size(offsetsRows,2)
    for dy = 1:size(offsetsCols,2)
        %get the shifted search window from origin search window
        
        % if the offsetsRows(dx)<=0 && offsetsCols(dy)<=0, get the left-top
        % part of origin image as the right-down part of shifIm

        if offsetsRows(dx)<=0 && offsetsCols(dy)<=0
            shiftIm(1-offsetsRows(dx):end,1-offsetsCols(dy):end,:)=imgSearch(1:end+offsetsRows(dx),1:end+offsetsCols(dy),:);
        end
        
        % if the offsetsRows(dx)<=0 && offsetsCols(dy)>0, get the
        % right-up part of origin image as the left-down part of shifIm
        if offsetsRows(dx)<=0 && offsetsCols(dy)>0
            shiftIm(1-offsetsRows(dx):end,1:end-offsetsCols(dy),:)=imgSearch(1:end+offsetsRows(dx),1+offsetsCols(dy):end,:);
        end
        
         % if the offsetsRows(dx)>0 && offsetsCols(dy)<=0, get the
        % left-down part of origin image as the right-up part of shifIm
        if offsetsRows(dx)>0 && offsetsCols(dy)<=0
            shiftIm(1:end-offsetsRows(dx),1-offsetsCols(dy):end,:)=imgSearch(1+offsetsRows(dx):end,1:end+offsetsCols(dy),:);
        end
        
         % if the offsetsRows(dx)>0 && offsetsCols(dy)>0, get the
        % right-down part of origin image as the left-up part of shifIm
        if offsetsRows(dx)>0 && offsetsCols(dy)>0
            shiftIm(1:end-offsetsRows(dx),1:end-offsetsCols(dy),:)=imgSearch(1+offsetsRows(dx):end,1+offsetsCols(dy):end,:);
        end
        %diff is the difference square matrix between origin search window 
        %and shifted search window
        diff = (imgSearch - shiftIm).^2;
        % diffIntegral is the integral image of diff
        diffIntegral = computeIntegralImage(diff);
        % get the ssd value by using evaluateIntegralImage
        distances(dx,dy) = evaluateIntegralImage(diffIntegral, searchWindowSize+1,searchWindowSize+1, patchSize);
        
    end
end 

end
