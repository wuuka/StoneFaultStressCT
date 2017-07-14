clc;clear;
I1=dicomread('.\pic\s10_I10');
I2=dicomread('.\pic\s20_I10');
[m,n]=size(I2);
deta_X = zeros(m, n);
data_Y = zeros(m, n);
Dscm=zeros(m,n);
width = 20;

time_begin = clock;  %时间计算
for l=201:m-200  %取中间区域（200，200）
    for j=201:n-200
        A=I1(l-width/2:l+width/2,j-width/2:j+20/2);  %构建20*20的滑动窗
        %[detax, detay, Y_num]=Max_CCM1(A,I2,l,j);
        %[detax, detay, Y_num]=SumSquared_cor(A,I2,l,j,width);
        [detax, detay, Y_num]=SumSquaredDif_cor(A,I2,l,j,width);
        deta_X(l,j) = detax;
        data_Y(l,j) = detay;
        Dscm(l,j) = Y_num;
    end
end
time_end = clock;
etime(time_end,time_begin)

I2=im2bw(I1,graythresh(I1));  %Otsu法求阈值二值化
[l,z]=bwlabel(I2);
b=0;

for i=1:max(max(l))  %找出最大的区域
    c=sum(l(l==i))/i;  %一类标签个数
    if(c>b)
        b=c;
        index=i;
    end
end
l(l~=1)=0;

for i=1:m
    for j=1:n
        if l(i,j)~=index;
            Dscm(i,j)=-Inf;
            deta_X(i,j) = -Inf;
            data_Y(i,j) = -Inf;
        end
    end
end

 Dscm=flipud(Dscm);%矩阵上下颠倒。
 figure;
 contourf(Dscm);
 colorbar;
 colormap(jet)
 title('相关图像位移图','fontsize',18);
