function [ii] = computeIntegralImage(image)

%REPLACE THIS
% first get the the cumulative sum of image's row and 
%then get the cumulative sum of the image after compute the cumulative sum
%of rows
ii = cumsum(cumsum(image,2),1);

end