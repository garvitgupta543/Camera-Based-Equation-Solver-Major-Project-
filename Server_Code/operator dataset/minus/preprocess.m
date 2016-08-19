% This file is for preprocessing function for formula recognition
 %function images_out = preprocess(InputImg)
%------------------------------------------------------------------------------
% INPUT:
% input_img_path 	- input image path
% output_img_path 	- output image path
%--------------------------------------------------------------------------

%InputImg = imread(InputImg);

for n=1:9
    str = strcat('img001-00',num2str(n));
    str = strcat(str,'.png');
    InputImg = imread(str);
    InputImg = im2double(InputImg);
    imgBW = InputImg;
    GrayImg = rgb2gray(InputImg);
    
    imgBW = GrayImg;
    imgBW = binarization(GrayImg);
    figure,imshow(imgBW);
    [L Ne]=bwlabel(imgBW);

% Measure properties of image regions

    propied=regionprops(L,'BoundingBox');


    hold on

% Plot Bounding Box



    for n=1:size(propied,1)
%     
    
        rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
    end

    hold off
    for n=1:1

        [r,c] = find(L==n);
        n1=imgBW(min(r):max(r),min(c):max(c));
        [x y]= size(n1);
    
        if(x*y>=300)
            
        %figure,imshow(~n1);
            n1 = not(n1);
            n1 = imresize(n1,[32 32]);
            
            imwrite(n1,str);
        end
    

    end
end
 
    %se = strel('square',2);
%     imgBW = imerode(imgBW,se);
%     imgBW = imerode(imgBW,se);
%     imgBW = imerode(imgBW,se);
%     imgBW = imerode(imgBW,se);



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

%figure;imshow(imgBW);title('binarize');




%imgBW = imdilate(imgBW,se);
%imgBW = imdilate(imgBW,se);

%imwrite(imgBW,'enhanced.jpg');








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



% 
% figure
cnt=0;


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
%     images_out = oblique(candidates_r);
%     images_out = not(images_out);
%     %figure;
%     %imshow(images_out);
%     imwrite(images_out,'handledoblique.jpg');
%     title(['images_out  ', num2str(i)]);
%    %imwrite(images_out,bin); 
% % end
% % % 
% % % end
% % % 
