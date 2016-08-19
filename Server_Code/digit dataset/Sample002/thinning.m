% @Author:  Linbo<linbo.me>
% @Version: 1.0  25/10/2014
% This is the implementation of the 
% Zhang-Suen Thinning Algorithm for skeletonization.

clc,clear
% load image data
%addpath('./data')
for n=10:55
    str = strcat('img002-0',num2str(n));
    str = strcat(str,'.png');

    Img_Original = imread(str);
%     [height, width] = size(Img_Original);
%     height = height/5;
%     width = width/5;
% 
% Img_Original = imresize(Img_Original,[height width]);

%Convert gray images to binary images using Otsus method
% Otsu_Threshold = graythresh(Img_Original);
% BW_Original = not(im2bw(Img_Original,Otsu_Threshold));  % must set object region as 1, background region as 0 

BW_Original = not(Img_Original);

changing = 1;
[rows, columns] = size(BW_Original);
BW_Thinned = BW_Original;
BW_Del = ones(rows, columns);
while changing
    % BW_Del = ones(rows, columns);
    changing = 0;
    % Setp 1
    for i=2:rows-1
        for j = 2:columns-1
            P = [BW_Thinned(i,j) BW_Thinned(i-1,j) BW_Thinned(i-1,j+1) BW_Thinned(i,j+1) BW_Thinned(i+1,j+1) BW_Thinned(i+1,j) BW_Thinned(i+1,j-1) BW_Thinned(i,j-1) BW_Thinned(i-1,j-1) BW_Thinned(i-1,j)]; % P1, P2, P3, ... , P8, P9, P2
            if (BW_Thinned(i,j) == 1 &&  sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(6)==0 && P(4)*P(6)*P(8)==0)   % conditions
                % No. of 0,1 patterns (transitions from 0 to 1) in the ordered sequence
                A = 0;
                for k = 2:size(P,2)-1
                    if P(k) == 0 && P(k+1)==1
                        A = A+1;
                    end
                end
                if (A==1)
                    BW_Del(i,j)=0;
                    changing = 1;
                end
            end
        end
    end
    BW_Thinned = BW_Thinned.*BW_Del;  % the deletion must after all the pixels have been visited
    % Step 2 
    for i=2:rows-1
        for j = 2:columns-1
            P = [BW_Thinned(i,j) BW_Thinned(i-1,j) BW_Thinned(i-1,j+1) BW_Thinned(i,j+1) BW_Thinned(i+1,j+1) BW_Thinned(i+1,j) BW_Thinned(i+1,j-1) BW_Thinned(i,j-1) BW_Thinned(i-1,j-1) BW_Thinned(i-1,j)];
            if (BW_Thinned(i,j) == 1 && sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(8)==0 && P(2)*P(6)*P(8)==0)   % conditions
                A = 0;
                for k = 2:size(P,2)-1
                    if P(k) == 0 && P(k+1)==1
                        A = A+1;
                    end
                end
                if (A==1)
                    BW_Del(i,j)=0;
                    changing = 1;
                end
            end
        end
    end
    BW_Thinned = BW_Thinned.*BW_Del;
end%while

% figure
% imshow(BW_Original);
% figure
% imshow(BW_Thinned);
% 
 se = strel('disk',2);
 imgBW= BW_Thinned;
 imgBW = imdilate(BW_Thinned,se);
 %imgBW = imdilate(imgBW,se);
% figure
% imshow(imgBW);
str2 = strcat('imag',num2str(n));
    str2 = strcat(str2,'.png');
imwrite(imcomplement(imgBW),str2);
end