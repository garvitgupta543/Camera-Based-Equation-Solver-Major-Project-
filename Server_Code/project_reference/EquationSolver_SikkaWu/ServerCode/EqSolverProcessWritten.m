function EqSolverProcessWritten(input_img_path)
% function EqSolverProcessWritten(input_img_path)
%
% 
%
% May 27, 2012
% EE368 Final Project
% Aman Sikka, Benny Wu
%

% (0) Add paths for vlfeat and RANSAC
    addpath(genpath('C:\wamp\www\vlfeat-0.9.14'));
    %inputImg = imread('C:\wamp\www\upload\testOut.jpg');%input_img_path); 
    inputImg = imread(input_img_path);
    inputImg = uint8(rgb2gray(inputImg));
    %inputImg = imresize(inputImg, 0.25);
    sizeImg = size(inputImg);
    
    %figure(1), imshow(inputImg), title('Input Image');
  

% (1) VL_MSER
    try
    % Compute region seeds and elliptical frames
        [reg fr] = vl_mser(inputImg, 'MinDiversity', 0.7, 'MaxVariation', 1, 'Delta', 15,'MinArea', 0.0001, 'MaxArea' , 0.1  );

    % Calculate regions    
        MSERimg = zeros(sizeImg);
        % Sort region seeds, filter out reg < 0 (overlapping MSER regions)
        regSorted = sort(reg(find(reg > 0)));  
        
        TessOutput = [];
        for x = regSorted'
            s = vl_erfill(inputImg,x);  %Return pixels belonging to region seed x
            MSERimg(s) = MSERimg(s) + 1;            %Number of overlapping extremal regions                
        end
        
        % Dilate image
        MSER_SE = strel('disk', 3');
        MSERimg = imdilate(MSERimg, MSER_SE);
        MSERimg = imerode(MSERimg, MSER_SE);
        
        %figure(3), imshow(MSERimg);
        imwrite(MSERimg,'C:\wamp\www\libSVM\imgMSER.jpg');
        
% (2) Region Props to Segment out Lines        
        regLabels = bwlabel(MSERimg,8);  %label the regions
        %figure(4), imagesc(regLabels);

        regProp   = regionprops(regLabels, 'BoundingBox', 'Centroid', 'Area', 'Solidity');
    
    %(2a) Find Centroid X and Centroid Y
        CentX = zeros(1,length(regProp));
        CentY = zeros(1,length(regProp));
        TopY  = zeros(1,length(regProp));
        BotY  = zeros(1,length(regProp));
        for ri = 1:length(regProp)
            Centroid  = regProp(ri).Centroid;
            CentX(ri) = Centroid(1);
            CentY(ri) = Centroid(2);
            BdBox     = regProp(ri).BoundingBox;
            TopY (ri) = BdBox(2);
            BotY (ri) = BdBox(2) + BdBox(4);     %Y for bottom of region            
        end
    
    %(2b) Figure out the number of lines using Histogram
        numBins = 20;
        bins = (sizeImg(1)/(numBins*2)):(sizeImg(1)/numBins):sizeImg(1);
        [imgHist binsHist] = hist(CentY, bins);
        %figure(5); hist(CentY, bins);
    
        line_ind = 1;      % line index
        lineY    = 0;
        peakHist = 0;
        for ii = 1:numBins
            if (imgHist(ii) > peakHist)          % New peak fond
                lineY(line_ind) = binsHist(ii);  % Update line Centroid Y
                peakHist        = imgHist(ii);   % Store current peak as new max
            end
            if (peakHist > 0) && (imgHist(ii) == 0)  % End of line
                line_ind = line_ind + 1;             %   Increment line index
                peakHist = 0;                        %   Reset max
            end
        end

    %(2c) Calculate boundary of lines based on mean of centroid Y in histogram       
        boundaryLineY      = zeros(1,length(lineY)+1);
        boundaryLineY(1)   = 1;          %Top of first line is row 1
        boundaryLineY(end) = sizeImg(1); %Bottom of last line is Y extent of image
        
        % Set boundary as mean of Centroid Y of neighbouring lines
        for ii = 2:length(lineY)
            boundaryLineY(ii) = round(mean([lineY(ii-1), lineY(ii)]));
        end
    catch e
        disp('ERROR: Bad image.  Please take another image!');        
        disp(getReport(e,'extended'));
    end
    

%% (3) Segment out Lines, segment out characters, use libSVM to recognize
    system('del C:\wamp\www\libSVM\NewData.txt');
    lineLength = 0;
    indexEqual = zeros(size(lineY));
    for li = 1:length(lineY)            
        lineImg = MSERimg(boundaryLineY(li):boundaryLineY(li+1), :);
        %imwrite(lineImg, 'lineImg.jpg');
        %figure(10); imshow(lineImg); title('Original lineImg');
            
        % Find all regions with y-centroid within boundaryLineY(li) < CentY < boundaryLineY(li+1)
        regAll = intersect(find(CentY > boundaryLineY(li)), find(CentY < boundaryLineY(li+1)));
        lineCentX = CentX(regAll);
        baselineY = BotY(regAll);
        toplineY  = TopY(regAll);
                        
%         % (3a) Segment out individual characters
%             lineRegLabels = bwlabel(lineImg,8);  %label the regions
%             %figure(5), imagesc(lineRegLabels);             
% 
%             % '=' will have two regions that have almost same x-centroid
%             minCentXSeparation = 20;  % Assume characters are separated by at least this much
%             % Use bitMask to eliminate double counting x-centroid of '='
%             regMask  = logical([ (CentX(regAll(2:end)) - CentX(regAll(1:end-1)) > minCentXSeparation) 1]);  %bitMask 
%             % Get x-centroid of all characters
%             charX = [CentX( regAll(regMask) ) sizeImg(2)];
% 
%             % Set boundary as mean of x-centroid of neighbouring characters
%             boundaryCharX      = zeros(1,length(charX)+1);
%             boundaryCharX(1)   = 1;
%             boundaryCharX(end) = sizeImg(2);
%             % Use x-boundary to segment out characters
%             for ii = 1:length(charX)-1
%                boundaryCharX(ii+1) = round(mean([charX(ii), charX(ii+1)]));
% 
%                charImg = lineImg(:, boundaryCharX(ii):boundaryCharX(ii+1));
%                figure, imshow(charImg);
%                %imwrite(charImg, 'charImg.jpg');
%                %[status,result] = system('tesseract C:\wamp\www\upload\charImg.jpg C:\wamp\www\upload\TessOutput -psm 10 alpha_number_math');
%                %ocrLine = textread('TessOutput.txt', '%s', 'delimiter', ',')
%             end            

        % (3a) Segment out individual characters
            %lineRegLabels = bwlabel(lineImg,8);  %label the regions
            %figure(5), imagesc(lineRegLabels);             

            % '=' will have two regions that have almost same x-centroid
            minCentXSeparation = 20;  % Assume characters are separated by at least this much
            % Use bitMask to eliminate double counting x-centroid of '='
            regNotEqSign = logical([(CentX(regAll(2:end)) - CentX(regAll(1:end-1)) > minCentXSeparation) 1]);
            %regMask   = regAll(logical(1-regEqSign));  %bitMask 
            
            ii = 1;
            if(li==1)
               lineLength= sum(regNotEqSign);
            end
            if ~isempty(find(regNotEqSign == 0))
                indexEqual(li) = find(regNotEqSign == 0) + lineLength*(li-1);
            else
                indexEqual(li) = -1;
            end
             while ii <= length(regNotEqSign)
                
                % Not a '=' region
                if regNotEqSign(ii)
                    BB = round(regProp(regAll(ii)).BoundingBox);
                    minX = BB(1);
                    minY = BB(2);
                    maxX = BB(1) + BB(3);
                    maxY = BB(2) + BB(4);
                else % Region is part of '='
                    BBup = round(regProp(regAll(ii)).BoundingBox);
                    BBdn = round(regProp(regAll(ii+1)).BoundingBox);
                    minY = min(BBup(2)        , BBdn(2)        );
                    maxY = max(BBup(2)+BBup(4), BBdn(2)+BBdn(4));
                    minX = min(BBup(1)        , BBdn(1)        );
                    maxX = max(BBup(1)+BBup(3), BBdn(1)+BBdn(3));      
                    ii = ii+1;
                end
                
                % Check to see if aspect ratio is a problem
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
                    
                imgBW = MSERimg(minY:maxY,minX:maxX);                    
                % Pad boundary with zeros (since we will dilate later)
                imgBW = padarray(imgBW, [5 5]);
                                    
                %figure(6), imshow(imgBW);                      
        
        % (3b) Dilation and Resizing
            % Dilation to make strokes wider    
                %SE = strel('disk',2);
                %imgBW = imdilate(imgBW,SE);
                %figure(2),imshow(imgBW);

            % (2b) Resize image to 32x32
                imgBW = imresize(imgBW,[32 32]);
                % Threshold to remove resizing edge effects 
                imgBW = imgBW > 0.2;
                %imwrite(imgBW,'C:\Users\Miffi\Dropbox\EE368 Project\Project Code\libSVM\imgBW.jpg');
                imwrite(imgBW,'C:\wamp\www\libSVM\imgBW.jpg');

                %figure,imshow(imgBW,'InitialMagnification','fit');
    
        % (3c) Compute 64-vector, append to output training file
            % (3a) Open file for append
                %fid = fopen('C:\Users\Miffi\Dropbox\EE368 Project\Project Code\libSVM\NewData.txt', 'at');
                fid = fopen('C:\wamp\www\libSVM\NewData.txt', 'at');
                
                % (3b) Write vector value to file    
                % 64-vector is generated by dividing 32x32 image into 64 4x4 regions
                % Top row is region 1 2 3 4 5 6 7 8.  Second row is 9 ... 16 and so on
                fprintf(fid, '- ');
                for row = 0:7
                    for col = 0:7
                        fprintf(fid, '%i:%i ', row*8+col+1, sum(sum(imgBW(4*row+1:4*row+4,4*col+1:4*col+4)))); 
                    end
                end
                fprintf(fid, '\n');
                fclose(fid);    
                
                ii = ii+1;
             end                            
    end

% (4) Text Recognition with libSVM
    % Scale input vectors to between range -1 and 1
    system('C:\libsvm\windows\svm-scale -l -1 -u 1 -s range C:\wamp\www\libSVM\NewData.txt > C:\wamp\www\libSVM\NewDataScale');
    % Generate predictions for input 64-vectors
    system('C:\libsvm\windows\svm-predict C:\wamp\www\libSVM\NewDataScale C:\wamp\www\libSVM\BennyAman_charDBScale.svm_tra.model C:\wamp\www\libSVM\svm_output');
 %%   
    % Interpret prediction classes
    svm_outputNum = dlmread('C:\wamp\www\libSVM\svm_output');
    svm_outputChar = [];
    system('del C:\wamp\www\upload\svmOutput.txt')
    fid = fopen('C:\wamp\www\upload\svmOutput.txt','w');
    lineNum =1;
    for ii = 1:length(svm_outputNum)
        if(ii == indexEqual(lineNum))
            fprintf(fid, '=');
            continue
        end
        switch svm_outputNum(ii)
            case {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
                svm_outputChar = [svm_outputChar num2str(svm_outputNum(ii))];
                fprintf(fid, '%s', num2str(svm_outputNum(ii)));
            case 10
                svm_outputChar = [svm_outputChar 'a'];
                fprintf(fid, 'a');
            case 11
                svm_outputChar = [svm_outputChar 'b'];
                fprintf(fid, 'b');
            case 20
                svm_outputChar = [svm_outputChar '+'];
                fprintf(fid, '+');
            case 21
                svm_outputChar = [svm_outputChar '-'];
                fprintf(fid, '-');
            case 22
                svm_outputChar = [svm_outputChar '-'];
                fprintf(fid, '*'); 
            case 24        
                fprintf(fid, '=');
        end
        if ii == lineLength
            fprintf(fid, '\r\n');
            lineNum = lineNum + 1;
        end
        %disp('here');
    end
    fclose(fid);
    
