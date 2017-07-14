function [I, J, Y]=Max_CCM1(A,B,h,l)
% 掩模A在原图的起始行，列分别是h，l；将A在B里面平滑，得到A在B里面的相对移动距离
% 行移动I个象素，列运动J象素
A=double(A);  B=double(B); 
% [w,v]=size(A);
K=10;  %变化在一定的区域

for m=1:2*K;  %%% 行变化范围
    for n=1:2*K  %%% 列变化范围
        C=B(h+m-20:h+m,l+n-20:l+n);  
        a=abs(A.*conj(C));  %%% 分子
%         a=A.*conj(C);  %%% 分子
        b=A.*conj(A);  %%% 分母一
        c=C.*conj(C);  %%%　分母二
        gama(m,n)=sum(a(:))/sqrt(sum(b(:))*sum(c(:)));  %%% 相干系数    
%         gama(m,n)=abs(sum(a(:)))/sqrt(sum(b(:))*sum(c(:)));  %%% 相干系数  
   end
end
% figure,   imagesc(gama),  title('范数距离');  colormap(gray);  axis image off;  IMPIXELINFO;
[idx,idy]=find(gama==max(gama(:)));  %%% 求最大相干系数所在的位置
%I=abs(idx-K);%m,n的值不是相对滑动的值。m，n为 11的时候X Y已相对滑动0个单位。
%J=abs(idy-K);
I=idx-K;
J=idy-K;
% I=idx-1;
% J=idy-1;
Y=sqrt(I^2+J^2);














