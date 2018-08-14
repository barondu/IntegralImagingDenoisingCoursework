function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

%REPLACE THIS

% extend the edge of the image to make sure it can work on the border
windowImage = padarray(image, [windowSize,windowSize],'symmetric','both');
% the shift distance is the difference between searchWindowSize and
% patchSize
shiftDis = windowSize - patchSize;
% set the offset
offsetsRows = -shiftDis:1:shiftDis;
offsetsCols = -shiftDis:1:shiftDis;
%get the size of image
[r c d] = size(image);
%initialise the result 
result = zeros(size(image));
% weightSum is the sum of the weight which will be used to calculate the
% pixel value
weightSum = zeros(size(image));
%initialise the shifted image
shiftIm = zeros(size(windowImage));

for dx = 1:size(offsetsRows,2)
    for dy = 1:size(offsetsRows,2)
        
        % if the offsetsRows(dx)<=0 && offsetsCols(dy)<=0, get the left-top
        % part of origin image as the right-down part of shifIm
        if offsetsRows(dx)<=0 && offsetsCols(dy)<=0
            shiftIm(1-offsetsRows(dx):end,1-offsetsCols(dy):end,:)=windowImage(1:end+offsetsRows(dx),1:end+offsetsCols(dy),:);
        
        % if the offsetsRows(dx)<=0 && offsetsCols(dy)>0, get the
        % right-up part of origin image as the left-down part of shifIm
        elseif offsetsRows(dx)<=0 && offsetsCols(dy)>0
            shiftIm(1-offsetsRows(dx):end,1:end-offsetsCols(dy),:)=windowImage(1:end+offsetsRows(dx),1+offsetsCols(dy):end,:);
        
        % if the offsetsRows(dx)>0 && offsetsCols(dy)<=0, get the
        % left-down part of origin image as the right-up part of shifIm    
        elseif offsetsRows(dx)>0 && offsetsCols(dy)<=0
            shiftIm(1:end-offsetsRows(dx),1-offsetsCols(dy):end,:)=windowImage(1+offsetsRows(dx):end,1:end+offsetsCols(dy),:);
        
        % if the offsetsRows(dx)>0 && offsetsCols(dy)>0, get the
        % right-down part of origin image as the left-up part of shifIm
        elseif offsetsRows(dx)>0 && offsetsCols(dy)>0
            shiftIm(1:end-offsetsRows(dx),1:end-offsetsCols(dy),:)=windowImage(1+offsetsRows(dx):end,1+offsetsCols(dy):end,:);
        end
        
        %diff is the difference matrix between the extended image and
        %shiftIm
        diff = (windowImage - shiftIm).^2;
        % integral the diff
        diffIntegral = computeIntegralImage(diff);
        %get the part of original image from the diffIntegral
        %the part is from the diffIntegral with 2 patchSize extended which
        %aims to avoid border problems.
        %rowLeft is the top bound
        rowLeft = 1 + windowSize - 2*patchSize;
        %colLeft is the left bound
        colLeft = 1 + windowSize - 2*patchSize;
        %rowRight is the bottom bound
        rowRight = r + windowSize + 2*patchSize;
        %colRight is the right bound
        colRight = c + windowSize + 2*patchSize;
        % use matrix to calculate the ssd value for each pixel
        L1 = diffIntegral(rowLeft-patchSize-1:rowRight - patchSize-1,colLeft-patchSize-1:colRight-patchSize-1,:);
        L2 = diffIntegral(rowLeft-patchSize-1:rowRight - patchSize-1,colLeft+patchSize:colRight+patchSize,:);
        L3 = diffIntegral(rowLeft+patchSize:rowRight + patchSize,colLeft+patchSize:colRight+patchSize,:);
        L4 = diffIntegral(rowLeft+patchSize:rowRight + patchSize,colLeft-patchSize-1:colRight-patchSize-1,:);
        distances = L3-L2-L4+L1;
        d = sum(distances,3)/(3*(2*patchSize)^2);
        % get the ssd value of origin image
        d = d(2*patchSize+1:end-2*patchSize,2*patchSize+1:end-2*patchSize,:);
        % calculate the weight with computeWeighting function
        weight = computeWeighting(d, h, sigma);
        % the denoised pixel is the sum of shifted pixel times its weight
        result = result + shiftIm(1+windowSize:r+windowSize,1+windowSize:c+windowSize,:).*weight;
        % cumulate the weightSum
        weightSum = weightSum + weight;
    end
end
% the result is divided by the weightSum
result = result./weightSum;
result = result/255;
end