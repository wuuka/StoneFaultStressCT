clc;clear;
I1=dicomread('.\pic\s10_I10');
I2=dicomread('.\pic\s20_I10');
[m,n]=size(I2);
deta_X = zeros(m, n);
data_Y = zeros(m, n);
Dscm=zeros(m,n);
width = 20;

time_begin = clock;  %ʱ�����
for l=201:m-200  %ȡ�м�����200��200��
    for j=201:n-200
        A=I1(l-width/2:l+width/2,j-width/2:j+20/2);  %����20*20�Ļ�����
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

I2=im2bw(I1,graythresh(I1));  %Otsu������ֵ��ֵ��
[l,z]=bwlabel(I2);
b=0;

for i=1:max(max(l))  %�ҳ���������
    c=sum(l(l==i))/i;  %һ���ǩ����
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

 Dscm=flipud(Dscm);%�������µߵ���
 figure;
 contourf(Dscm);
 colorbar;
 colormap(jet)
 title('���ͼ��λ��ͼ','fontsize',18);
