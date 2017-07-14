function FastTest

load SumSquaredDif_s10_s20.mat
[m, n] = size(deta_X);
Dscm_pro=flipud(Dscm);%�������µߵ���
for i = 1:m
    for jj=1:n
        if deta_X(i, jj) == -inf
            deta_X(i, jj) = 0;
            data_Y(i, jj) = 0;
            Dscm_pro(i,jj) = 0;
        end
    end
end

%λ��ͼ
figure;
%Dscm=flipud(Y);%�������µߵ���
%[c,h] = contourf(Dscm,4);  %
%clabel(c,h);
contourf(Dscm_pro);
colorbar;
%colormap(jet)
title('���ͼ��λ��ͼ','fontsize',18);

%ʸ��ͼ

[x, y] = meshgrid(1:1:m,1:1:n);
u = deta_X(x(1,:), y(:,1));
v = data_Y(x(1,:), y(:,1));
image_pre = imread('1.png');
figure
imshow(image_pre)
%contour(x,y,sqrt(u.^2+v.^2));
hold on
quiver(x,y,u,v,'-k');

%��ά����ͼ
figure
%mesh(x,y,z,c)�����������棬�����ݵ��ڿռ������,���������� 
%surf(x,y,z,c)�����������棬�����ݵ�����ʾ���滭����
mesh(x, y, u);
figure
surf(x, y, v);

%����ص�ͼ
image_mix = zeros(m,n,3);
I1=dicomread('.\pic\s10_I10');
I2=dicomread('.\pic\s20_I10');
image_one = m_GrayWindow(I1,2048,3600);  %2500,3000;2048,3600
image_two = m_GrayWindow(I2,2048,3600);  %2500,3000;2048,3600
image_three = m_GrayWindow(Dscm_pro,1,16);
for i = 1:m
    for jj =1:n
        image_mix(i,jj,2) = image_one(i,jj);
        %image_mix(i,jj,3) = image_two(i,jj);
        image_mix(i,jj,3) = round(image_three(i,jj));
    end
end
A = image_mix(:,:,1);
figure
imshow(uint8(image_mix));


