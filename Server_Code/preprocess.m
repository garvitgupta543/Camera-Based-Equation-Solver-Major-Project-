% This file is for preprocessing function for formula recognition
 function ii = preprocess(InputImg)
%------------------------------------------------------------------------------
% INPUT:
% input_img_path 	- input image path
% output_img_path 	- output image path
%--------------------------------------------------------------------------

InputImg = imread(InputImg);
%InputImg = imread('enhanced.jpg');
%InputImg = im2double(InputImg);
imgBW = InputImg;
sizeImg = size(InputImg);

%GrayImg = rgb2gray(InputImg);



% Denoise
% [img, imgLP, imgHPSC] = denoiseSoftCoring(GrayImg, 5, 1.75, 30, 2.2);
% figure;imshow(img);title('denoise');
% Debur
% img = deblur(img);
% figure;imshow(GrayImg);title('deblur');
% Binarization


% 
% winSize = 32;
% stepSize = 16;
% %imgBW = localAdaptiveOtsu(GrayImg, 32, 16);
% 
% img = denoise(GrayImg);
% 
% 
%imgBW = binarization(GrayImg);
%figure;imshow(imgBW);title('binarize');


 se = strel('disk',2);
% % 
% % imgBW = imerode(imgBW,se);
% % imgBW = imerode(imgBW,se); 
 imgBW = imdilate(imgBW,se);
 imgBW = imerode(imgBW,se);
 
%  imgBW = imdilate(imgBW,se);
% % imgBW = imdilate(imgBW,se);
% 
% imwrite(imgBW,'enhanced.jpg');
% 









%figure;imshow(imgBW);title('erosin');
% 
% %img = denoise(~imgBW);
% 
% imgBW_temp = imgBW;
% % Negate the image to make the backgroud black 
% %imgBW = not(imgBW);
% % % figure;
% % % imshow(imgBW);
% % title('Binarized image');
% 
% % localize the patch that's is possibly a formula
% patch_list = localization(imgBW);
% %localization(imgBW);
% 
% % apply bounding box to the patches
% candidates = {};
% for i = 1:length(patch_list)
%     candidates{i} = boundingbox(patch_list{i}, imgBW_temp);
%      figure;
%      imshow(candidates{i});
%      title(['candidate ', num2str(i)]);
% end
% % 

[L Ne]=bwlabel(imgBW);
ii = Ne;

% Measure properties of image regions

propied=regionprops(L,'BoundingBox');

fileID = fopen('testfile.txt','w');
fprintf(fileID,'%i',Ne);
fclose(fileID);


% Plot Bounding Box

[row_img_crop_fill col_img_crop_fill] = size(imgBW);


for n=1:size(propied,1)
%     [pixel_rows(1,n) pixel_cols(1,n)] = size(imgBW);
%     if(and(pixel_rows(1,n) >=40, pixel_cols(1,n)>=15)) && (pixel_cols(1,n)<= round(col_img_crop_fill - .05*col_img_crop_fill))
%     
%     else
%         continue;   
%     end
    
    rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end




% 
% figure
cnt=0;
for n=1:Ne

    [r,c] = find(L==n);
    minX = min(r);
    maxX = max(r);
    minY = min(c);
    maxY = max(c);
    deltaX = maxX - minX;
                    deltaY = maxY - minY;
                    aspectR = deltaY/deltaX;

                    if (aspectR < (1/3))
                         minY = max(1,minY - 30);
                         maxY = min(sizeImg(1),maxY + 30);
                    elseif (aspectR > 3)
                         minX = max(1,minX - 30);
                         maxX = min(sizeImg(1),maxX + 30);
                    end   
    n1=imgBW(minX:maxX,minY:maxY);
    [x y]= size(n1);
    if(x*y>=100)
        cnt = cnt +1;
        %figure,imshow(~n1);
        
        n1 = imresize(n1,[32 32]);
        str = strcat('image',num2str(cnt));
        str = strcat(str,'.jpg');
        imwrite(n1,str);
    
    else
        ii = ii-1;
    end
    

end

% % Rotate the image
% candidates_r = {}
% for i = 1:length(candidates)
%     candidates_r = rotate(imgBW);
%     %figure;
%     %imshow(candidates_r);
%     title(['candidate_r ']);
% % end
% % % 
% % % % process oblique image
% % images_out = {}
% % for i = 1:length(candidates_r)
% %     images_out = oblique(candidates_r);
% %     images_out = not(images_out);
%     %figure;
%     %imshow(images_out);
%     imwrite(candidates_r,'handledoblique.jpg');
%     
%    %imwrite(images_out,bin); 
% % end
% % % 
% % % end
% % % 
