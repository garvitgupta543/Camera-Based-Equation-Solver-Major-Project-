%I = imread('rice.png');
%bw =im2bw(I3);
%imshow(bw)

% This file is for binarize the gray level image
% input: gray level image
% output: the binarized image

%function imgBW = binarization(imgGray)


imgGray = imread('test.jpg');
imgGray = rgb2gray(imgGray);
%figure
%imshow(imgGray);

imgGray = imresize(imgGray, [480 840], 'bicubic');
[height, width] = size(imgGray);

winSize = 31;
imgBackground = ordfilt2(imgGray, winSize^2-50, true(winSize));

imgSub = imgBackground - imgGray;

imgBW = imgSub ;

[row_img_crop_fill col_img_crop_fill] = size(imgBW);
figure; imshow(imgBW);

imgBW = imdilate(imgBW, strel('square',2));

imgBW = imfill(imgBW,'holes');

[Ilabel num] = bwlabel(imgBW);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
Ibox = reshape(Ibox,[4 length(Ibox)/4]);
figure;
cnt_subplot=0;

for cnt = 1:length(Ibox)
    rectangle('position', Ibox(:,cnt),'edgecolor','r');
    out= ceil(Ibox(1:2,cnt))';
    
    start_OCR_col = out(1,1); start_OCR_row = out(1,2);
    end_OCR_col = start_OCR_col + ceil(Ibox(3,cnt))-1;
    end_OCR_row = start_OCR_row + ceil(Ibox(4,cnt))-1;
    
    img_crop_char = imgBW(start_OCR_row:end_OCR_row, start_OCR_col:end_OCR_col);
    figure; imshow(img_crop_char);
    %[pixel_rows(1,cnt) pixel_cols(1,cnt)] = size(img_crop_char);
    
end
    
    


imshow(img :end_OCR_row, startBW);