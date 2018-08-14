%% Some parameters to set - make sure that your code works at image borders!

% Row and column of the pixel for which we wish to find all similar patches 
% NOTE: For this section, we pick only one patch
clear all;
close all;
row = 1;
col = 1;

% Patchsize - make sure your code works for different values
patchSize = 1;

% Search window size - make sure your code works for different values
searchWindowSize = 2;


%% Implementation of work required in your basic section-------------------

% TODO - Load Image
image = imread('images/alleyReference.png');
image = double(image);                

% imgPatch = padarray(image, '[patchSize,patchSize]','symmetric','both');
% imgSearch = padarray(image, '[searchWindowSize,searchWindowSize]','symmetric','both');
% TODO - Fill out this function

image_ii = computeIntegralImage(image);
% to normalise the integral image, find the maximum value of the matrix and
% then get the percentage of each pixel in the maxValue 
maxValue = image_ii(end,end,:);
norm_ii = image_ii ./ maxValue;

% TODO - Display the normalised Integral Image
% NOTE: This is for display only, not for template matching yet!
figure('name', 'Normalised Integral Image');imshow(norm_ii);


% TODO - Template matching for naive SSD (i.e. just loop and sum)
[offsetsRows_naive, offsetsCols_naive, distances_naive] = templateMatchingNaive(image,row, col,...
    patchSize, searchWindowSize);

% TODO - Template matching using integral images
[offsetsRows_ii, offsetsCols_ii, distances_ii] = templateMatchingIntegralImage(image,row, col,...
    patchSize, searchWindowSize);

%% Let's print out your results--------------------------------------------

% NOTE: Your results for the naive and the integral image method should be
% the same!
for i=1:length(offsetsRows_naive)
    for j=1:length(offsetsCols_naive)
    disp(['offset rows: ', num2str(offsetsRows_naive(i)), '; offset cols: ',...
        num2str(offsetsCols_naive(j)), '; Naive Distance = ', num2str(distances_naive(i,j),10),...
        '; Integral Im Distance = ', num2str(distances_ii(i,j),10)]);
    end
end