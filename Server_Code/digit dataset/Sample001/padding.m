

for n=2:2   
str = strcat('img001-00',num2str(n));
    str = strcat(str,'.png');
    my_image = imread(str);
    %my_image = im2double(my_image);
    imgBW = ~my_image;
imgBW = padarray(imgBW, [5 5]);
str2 = strcat('image',num2str(n));
str2 = strcat(str2,'.png');
imwrite(~imgBW,str2);

end