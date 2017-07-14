function [detax, detay, Y]=SumSquaredDif_cor(A,B,de_x,de_y,width)

A=double(A);  B=double(B);

for m=1:width
    for n=1:width
        
        C=B(de_x+m-width:de_x+m,de_y+n-width:de_y+n);  
        A_sum = mean2(A);  %子区域灰度均值
        C_sum = mean2(C);
        [mm, nn] = size(A);
        A_sum = ones(mm, nn)*A_sum;
        C_sum = ones(mm, nn)*C_sum;
        numerator = (sum(sum((A-A_sum).*(C-C_sum))))^2;  %分子
        denominator = sum(sum((A-A_sum).^2))*sum(sum((C-C_sum).^2));  %分母
        gama(m,n) = numerator/denominator;%相关函数计算值
        
    end
end

[idx,idy]=find(gama==max(gama(:)));  %%% 求最小像素差平方和系数所在的位置
detax=idx-width/2;  %m,n的值不是相对滑动的值。m，n为 11的时候X Y已相对滑动0个单位。
detay=idy-width/2;
Y=sqrt(detax^2+detay^2);

