function [detax, detay, Y]=SumSquared_cor(A,B,de_x,de_y,width)

A=double(A);  B=double(B); 

for m=1:width 
    for n=1:width  
        
        %Dif = zeros(width+1,width+1);
        C=B(de_x+m-width:de_x+m,de_y+n-width:de_y+n);  
        Dif =  (A - C)^2;  %ƫ��ͼ�����ز�ƽ����͡�
        gama(m,n)=sum(Dif(:));  %%% ���ϵ��    
        
   end
end


[idx,idy]=find(gama==min(gama(:)));  %%% ����С���ز�ƽ����ϵ�����ڵ�λ��
detax=idx-width/2;  %m,n��ֵ������Ի�����ֵ��m��nΪ 11��ʱ��X Y����Ի���0����λ��
detay=idy-width/2;
Y=sqrt(detax^2+detay^2);














