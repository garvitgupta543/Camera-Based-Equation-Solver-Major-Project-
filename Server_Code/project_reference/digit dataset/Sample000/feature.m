
for x=1:9
str = strcat('G:\project_reference\digit dataset\Sample00
for n=1:55
    str = strcat('img',num2str(n));
    str = strcat(str,'.png');
    
    fid = fopen('datasetlib2.txt', 'at');

        % (3b) Write vector value to file    
        % 64-vector is generated by dividing 32x32 image into 64 4x4 regions
        % Top row is region 1 2 3 4 5 6 7 8.  Second row is 9 ... 16 and so on
        fprintf(fid, '0 ');
        
        for row = 0:31
            for col = 0:31
                fprintf(fid, '%i:%i',row*32+col+1, imgBW(int8(row),int8(col))); 
            end
        end
        fprintf(fid, '\n');
        fclose(fid);
fid = fopen('dataset4.csv', 'at');

for row = 0:31
                    for col = 0:31
                        fprintf(fid, imgBW(int8(row),int8(col))); 
%                         if(~(row==7 && col==7))
                            fprintf(fid, ',');
%                         end
                    end
                end
                fprintf(fid,'0');
                fprintf(fid, '\n');
    
    end
    
    
 end
    