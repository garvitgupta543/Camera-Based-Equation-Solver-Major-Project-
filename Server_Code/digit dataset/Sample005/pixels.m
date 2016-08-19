


for n=10:55
    str = strcat('img005-0',num2str(n));
    str = strcat(str,'.png');
    my_image = imread(str);
    my_image = im2double(my_image);
    flag=0;
    for ii=1:size(my_image,1)
    for jj=1:size(my_image,2)
        % get pixel value
        pixel=my_image(ii,jj);
          % check pixel value and assign new value
          if pixel<0.4
              top_i = ii;
              top_j = jj;
%               top_i
%               top_j
              flag=1;
              break;
          end
              
    end
      if flag>0
          break;
      end
      
    end
    
    flag=0;
    
    for ii=size(my_image,1):-1:1
    for jj=1:size(my_image,2)
        % get pixel value
        pixel=my_image(ii,jj);
          % check pixel value and assign new value
          if pixel<0.4
              bot_i = ii;
              bot_j = jj;
%               bot_i
%               bot_j
              flag=1;
              break;
          end
              
    end
      if flag>0
          break;
      end
      
    end
    
    flag=0;

    for jj=1:size(my_image,2)
    for ii=1:size(my_image,1)
    
        % get pixel value
        pixel=my_image(ii,jj);
          % check pixel value and assign new value
          if pixel<0.4
              left_i = ii;
              left_j = jj;
%               left_i
%               left_j
              flag=1;
              break;
          end
              
    end
      if flag>0
          break;
      end
      
    end
    
    flag=0;
    
    for jj=size(my_image,2):-1:1
    for ii=1:size(my_image,1)
    
        % get pixel value
        pixel=my_image(ii,jj);
          % check pixel value and assign new value
          if pixel<0.4
              right_i = ii;
              right_j = jj;
%               right_i
%               right_j
              flag=1;
              break;
          end
              
    end
      if flag>0
          break;
      end
      
    end
    
    n1=my_image(top_i:bot_i,left_j:right_j);
   n1 = imcomplement(n1);
   
   
        
    n1 = padarray(n1, [5 5]);
            
        %figure,imshow(~n1);
        
           n1 = imcomplement(n1);
           
            n1 = imresize(n1,[32 32]);
            %n1 = n1 > 0.2;
            
            imwrite(n1,str);
    
    
end