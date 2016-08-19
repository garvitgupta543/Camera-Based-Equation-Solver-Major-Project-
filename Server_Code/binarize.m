I = imread('test1.jpg');


imgGray = rgb2gray(I);

imgGray = imresize(imgGray, [480 640], 'bicubic');
[height, width] = size(imgGray);

winSize = 31;
imgBackground = ordfilt2(imgGray, winSize^2-50, true(winSize));

imgSub = imgBackground - imgGray;

imgBW = imgSub ;


figure; imshow(imgBW);

% imgBW =im2bw(imgBW);
% imgBW= ~imgBW;
% figure,imshow(imgBW);

% This file is for binarize the gray level image
% input: gray level image
% output: the binarized image

%function imgBW = binarization(imgGray)

imgBW = ~imgBW;
% imgBW = imdilate(imgBW, strel('square',2));
% 
% imgBW = imfill(imgBW,'holes');

figure, imshow(imgBW);

[L Ne]=bwlabel(imgBW);

%% Measure properties of image regions

propied=regionprops(L,'BoundingBox');

hold on

%% Plot Bounding Box

for n=1:size(propied,1)

    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end

hold off

pause (1)

%% Objects extraction

figure

% for n=1:Ne
% 
%     [r,c] = find(L==n);
%     n1=imgBW(min(r):max(r),min(c):max(c));
%     figure,imshow(~n1);
%     %imsave();
% 
% end
 