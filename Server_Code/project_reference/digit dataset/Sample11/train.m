%function train()
% function train()
%  Generates 64-vector suitable for libSVM from input image.
%  
%  Input: Requires no input parameters.  Image from camera is saved to
%    ..\EE368 Project\Project Code\images\img.jpg
%  Output: 64-vector is appended to training file
%    ..\EE368 Project\Project Code\NewData.txt
%
%  EE368 2012 Final Project
%  Aman Sikka and Benny Wu
%  June 2, 2012

addpath(genpath('G:\project_reference\vlfeat-0.9.14'));

% (1) Pre-processing of camera image

    % (1a) Read in image, rotate, convert to grayscale
    for n=1:280
    str = strcat('plus (',num2str(n));
    str = strcat(str,').jpg');
        img = imread(str);
        %img = imrotate(img,-90);
        %img = rgb2gray(img);
        %figure(99),imshow(img);

        sizeImg = size(img);
        
%         img = medfilt2(img);
    
    % (1b) Compute MSER
        % Calculate regions
        [reg fr] = vl_mser(img, 'MinDiversity', 0.7, 'MaxVariation', 0.4, 'Delta', 15);% 'MaxArea', 0.1, 'MinArea', (50/(sizeImg(1)*sizeImg(2))) );
 
        % Create binary mask using regions    
        minY = sizeImg(1);
        maxY = 1;
        minX = sizeImg(2);
        maxX = 1;
        
        imgBW= zeros(size(img));
        reg_pos = reg > 0;
        reg = reg(reg_pos);
        for x = reg'
            s = vl_erfill(img,x);    %Return pixels belonging to region seed x
            imgBW(s) = imgBW(s) + 1; %Number of overlapping extremal regions                

            
%             MSER_SE = strel('disk', 2);
%         imgBW = imdilate(imgBW, MSER_SE);
%         %imgBW = imerode(imgBW, MSER_SE);
%         se = strel('square',2);
%         imgBW = imerode(imgBW, se);
        
        
            % Figure out bounding box of character
            minY = min(minY,min(mod(s,sizeImg(1)))+1);
            maxY = max(maxY,max(mod(s,sizeImg(1)))+1);
            minX = min(minX,min(s) / sizeImg(1));
            maxX = max(maxX,max(s) / sizeImg(1));
            
            
            
            

%             if (aspectR < (1/5))
%                 minY = max(1,minY - 50);
%                 maxY = min(sizeImg(1),maxY + 50);
%             elseif (aspectR > 5)
%                 minX = max(1,minX - 50);
%                 maxX = min(sizeImg(1),maxX + 50);
%   
%             end
%         
        end
        
%         deltaX = maxX - minX;
%         deltaY = maxY - minY;
%         aspectR = deltaY/deltaX;
%             
%         if (deltaX > deltaY)
%             minY = minY - round((deltaX - deltaY)/2);
%             maxY = maxY + round((deltaX - deltaY)/2);                
%         else
%             minX = minX - round((deltaY - deltaX)/2);
%             maxX = maxX + round((deltaY - deltaX)/2);
%         end
        
%          deltaX = maxX - minX;
%                     deltaY = maxY - minY;
%                     aspectR = deltaY/deltaX;
% 
%                     if (aspectR < (1/3))
%                          minY = max(1,minY - 30);
%                          maxY = min(sizeImg(1),maxY + 30);
%                     elseif (aspectR > 3)
%                          minX = max(1,minX - 30);
%                          maxX = min(sizeImg(1),maxX + 30);
%                     end 
                    
                    
        
        imgBW = imgBW(minY:maxY, minX:maxX);
        
        % Pad boundary with zeros (since we will dilate later)
        imgBW = padarray(imgBW, [5 5]);

     %figure(1),imshow(imgBW);
%%
% (2) Dilation and Resizing
    % Dilation to make strokes wider    
%         SE = strel('disk',11);
%         imgBW = imdilate(imgBW,SE);
%         %figure(2),imshow(imgBW);

% SE = strel('disk',4);
%                 imgBW = imdilate(imgBW,SE);
% %                 imgBW = imdilate(imgBW,SE);
% %                 imgBW = imerode(imgBW,SE);
% 
%                 se = strel('disk',2);
%                 imgBW = imerode(imgBW,se);

    % (2b) Resize image to 32x32
        imgBW = imresize(imgBW,[32 32]);
        % Threshold to remove resizing edge effects 
        imgBW = imgBW > 0.2;
        str2 = strcat('img',num2str(n));
    str2 = strcat(str2,'.png');
        imwrite(imgBW,str2);
    
        %figure(3),imshow(imgBW,'InitialMagnification','fit');
    
% (3) Compute 64-vector, append to output training file
    % (3a) Open file for append
        fid = fopen('datasetlib.txt', 'at');

        % (3b) Write vector value to file    
        % 64-vector is generated by dividing 32x32 image into 64 4x4 regions
        % Top row is region 1 2 3 4 5 6 7 8.  Second row is 9 ... 16 and so on
        fprintf(fid, '0 ');
        for row = 0:7
            for col = 0:7
                fprintf(fid, '%i:%i ', row*8+col+1, sum(sum(imgBW(4*row+1:4*row+4,4*col+1:4*col+4)))); 
            end
        end
        fprintf(fid, '\n');
        fclose(fid);
fid = fopen('dataset3.csv', 'at');

for row = 0:7
                    for col = 0:7
                        fprintf(fid, '%i ', sum(sum(imgBW(4*row+1:4*row+4,4*col+1:4*col+4)))); 
%                         if(~(row==7 && col==7))
                            fprintf(fid, ',');
%                         end
                    end
                end
                fprintf(fid,'0');
                fprintf(fid, '\n');
                fclose(fid);
    
    end