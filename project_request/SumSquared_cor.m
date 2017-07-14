function [detax, detay, Y]=SumSquared_cor(A,B,de_x,de_y,width)

A=double(A);  B=double(B); 

for m=1:width 
    for n=1:width  
        
        %Dif = zeros(width+1,width+1);
        C=B(de_x+m-width:de_x+m,de_y+n-width:de_y+n);  
        Dif =  (A - C)^2;  %偏移图像，像素差平方求和。
        gama(m,n)=sum(Dif(:));  %%% 相干系数    
        
   end
end


[idx,idy]=find(gama==min(gama(:)));  %%% 求最小像素差平方和系数所在的位置
detax=idx-width/2;  %m,n的值不是相对滑动的值。m，n为 11的时候X Y已相对滑动0个单位。
detay=idy-width/2;
Y=sqrt(detax^2+detay^2);














