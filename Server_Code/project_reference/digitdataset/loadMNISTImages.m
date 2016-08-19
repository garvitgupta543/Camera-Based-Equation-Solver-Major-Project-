clear all;
close all;

%//Open file
fid = fopen('train-images.idx3-ubyte', 'r');

%//Read in magic number
%//A = fread(fid, 4, 'uint8');
%//magicNumber = sum(bitshift(A', [24 16 8 0]));

%//OR
A = fread(fid, 1, 'uint32');
magicNumber = swapbytes(uint32(A));

%//Read in total number of images
%//A = fread(fid, 4, 'uint8');
%//totalImages = sum(bitshift(A', [24 16 8 0]));

%//OR
A = fread(fid, 1, 'uint32');
totalImages = swapbytes(uint32(A));

%//Read in number of rows
%//A = fread(fid, 4, 'uint8');
%//numRows = sum(bitshift(A', [24 16 8 0]));

%//OR
A = fread(fid, 1, 'uint32');
numRows = swapbytes(uint32(A));

%//Read in number of columns
%//A = fread(fid, 4, 'uint8');
%//numCols = sum(bitshift(A', [24 16 8 0]));

%// OR
A = fread(fid, 1, 'uint32');
numCols = swapbytes(uint32(A));

%//For each image, store into an individual cell
imageCellArray = cell(1, totalImages);
for k = 1 : totalImages
    %//Read in numRows*numCols pixels at a time
    A = fread(fid, numRows*numCols, 'uint8');
    %//Reshape so that it becomes a matrix
    %//We are actually reading this in column major format
    %//so we need to transpose this at the end
    imageCellArray{k} = reshape(uint8(A), numCols, numRows)';
    
end

for k=1:6000
    str = strcat('image',num2str(k));
    str = strcat(str,'.png');
imwrite(imageCellArray{k},str);
end


%//Close the file
fclose(fid);