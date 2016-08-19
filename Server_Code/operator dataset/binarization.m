% This file is for binarize the gray level image
% input: gray level image
% output: the binarized image
function imgBW = binarization(imgGray)
[height, width] = size(imgGray);
imgGray = imresize(imgGray, [height width], 'bicubic');
[height, width] = size(imgGray);

winSize = 31;
imgBackground = ordfilt2(imgGray, winSize^2-50, true(winSize));
%figure;imshow(imgBackground);title('binarize');

imgSub = imgBackground - imgGray;


imgBW = imgSub > 0.2;

end