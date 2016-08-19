RGB= imread('Desktop1.png');
imshow(RGB);
I = rgb2gray(RGB);
figure
imshow(I)
J = imnoise(I,'gaussian',0,0.025); %noise is added
imshow(J)
K = wiener2(J,[5 5]);
figure
imshow(K)
M=medfilt2(K);
figure, imshow(M)
LEN = 56;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(M, PSF, 'conv', 'circular');
figure, imshow(blurred)

estimated_nsr = 0.03;
wnr3 = deconvwnr(blurred, PSF, estimated_nsr);
figure, imshow(wnr3)
title('Restoration of Blurred, Noisy Image Using Estimated NSR');