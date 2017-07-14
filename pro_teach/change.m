function image_out = change(image_input)
I21=im2bw(image_input,graythresh(image_input));%阈值分割
   [l2,z2]=bwlabel(I21);%标记联通区域
 
   b=0;
   for i=1:max(max(l2))
       c=sum(sum((l2(l2==i))))/i;%取最大联通区域，即圆形区域
       if(c>b)
           b=c;
           index=i;
       end
   end
   I21(l2==index)=1;
   I21(l2~=index)=0;
   BoundingBox=regionprops(I21,'BoundingBox');
   startrow=ceil(BoundingBox.BoundingBox(1));
   startbow=floor(BoundingBox.BoundingBox(2));
   image_out=image_input(startbow:startbow+BoundingBox.BoundingBox(4),startrow:startrow+BoundingBox.BoundingBox(3));