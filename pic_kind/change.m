function image_out = change(image_input)
I21=im2bw(image_input,graythresh(image_input));%��ֵ�ָ�
   [l2,z2]=bwlabel(I21);%�����ͨ����
 
   b=0;
   for i=1:max(max(l2))
       c=sum(sum((l2(l2==i))))/i;%ȡ�����ͨ���򣬼�Բ������
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