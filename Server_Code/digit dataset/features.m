
n=11;    
str = strcat('image',num2str(n));
    str = strcat(str,'.jpg');
    my_image = imread(str);
    my_image = im2double(my_image);
    imgBW = ~my_image;
    
    fid = fopen('featurevector.csv', 'at');
                
                % (3b) Write vector value to file    
                % 64-vector is generated by dividing 32x32 image into 64 4x4 regions
                % Top row is region 1 2 3 4 5 6 7 8.  Second row is 9 ... 16 and so on
                %fprintf(fid, '- ');
                
%                 for row = 0:7
%                     for col = 0:7
%                         
%                         fprintf(fid, '0,');
%                     end
%                 end
                
                for row = 0:7
                    for col = 0:7
                        fprintf(fid, '%i ', sum(sum(imgBW(4*row+1:4*row+4,4*col+1:4*col+4)))); 
                        fprintf(fid, ',');
                    end
                end
                fprintf(fid, '\n');
                fclose(fid);  
    
      
    