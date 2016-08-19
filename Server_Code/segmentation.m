I = imread('image.png');
imshow(I)
I2 = imtophat(I,strel('disk',15));
imshow(I3);
bw =im2bw(I3);
bw = bwareaopen(bw, 50);
cc = bwconncomp(bw, 4)
grain = false(size(bw));
grain(cc.PixelIdxList{50}) = true;
imshow(grain);
