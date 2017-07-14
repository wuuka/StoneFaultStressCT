%%
clc,clear
img_path_list = dir(strcat( '.\pic\'));  %获取该文件夹中格式的图像
img_num = length(img_path_list);  %获取图像总数量
Atlas=cell(1,img_num-2);
if img_num > 2  %有满足条件的图像
    for i = 3:img_num  %逐一读取图像
        
        image_name = img_path_list(i).name;
        im_pro =  dicomread(strcat( '.\pic\',image_name));
        im_pro = m_GrayWindow(im_pro,2000,3500);  %2500,3000;2048,3600
        %image_out = change(im_pro);
        image_out = zeros(640,640);  %图像掩模尺寸
        image_out = im_pro(223:862,193:832);
        %figure(i-2)
        %imshow(uint8(image_out));
        Atlas{i-2} = image_out;  %存储处理后图像数据
        fprintf('%d %s\n',i-2,strcat('.\pic\',image_name));  % 显示正在处理的图像名
    end
end

pro_a=Atlas{1,1};
pro_b=Atlas{1,2};
[m,n]=size(pro_b);
deta_X = zeros(m, n);
data_Y = zeros(m, n);
Dscm=zeros(m,n);
width = 10;

time_begin = clock;  %时间计算
for i=12:5:m-12  %取中间区域（200，200）
    for j=12:5:n-12
        A=pro_a(i-width/2:i+width/2,j-width/2:j+width/2);  %构建20*20的滑动窗
        %[detax, detay, Y_num]=Max_CCM1(A,I2,l,j);
        %[detax, detay, Y_num]=SumSquared_cor(A,I2,l,j,width);
        [detax, detay, Y_num]=SumSquaredDif_cor(A,pro_b,i,j,width);
        deta_X(i-2:i+2,j-2:j+2) = detax;
        data_Y(i-2:i+2,j-2:j+2) = detay;
        Dscm(i-2:i+2,j-2:j+2) = Y_num;
    end
end
time_end = clock;
etime(time_end,time_begin)

% %%选取关注区域
% pre=im2bw(pro_a,graythresh(pro_a));  %Otsu法求阈值二值化
% [l,z]=bwlabel(pre);
% b=0;
% 
% for i=1:max(max(l))  %找出最大的区域
%     c=sum(l(l==i))/i;  %一类标签个数
%     if(c>b)
%         b=c;
%         index=i;
%     end
% end
% l(l~=1)=0;
% 
% for i=1:m
%     for j=1:n
%         if l(i,j)~=index;
%             Dscm(i,j) = 0;
%             deta_X(i,j) = 0;
%             data_Y(i,j) = 0;
%         end
%     end
% end

Dscm_pud=flipud(Dscm);  %矩阵上下置换。这里位移图像的坐标点在左下角
figure(1)
contourf(Dscm_pud);
colorbar;
%colormap(jet)
title('相关图像位移图','fontsize',18);


%矢量图
[x, y] = meshgrid(1:10:m,1:10:n);
u = deta_X(x(1,:), y(:,1));
v = data_Y(x(1,:), y(:,1));

figure(2)
imshow(uint8(pro_a));
%contour(x,y,sqrt(u.^2+v.^2));
hold on
quiver(x,y,u,v,'-k');
title('相关图像矢量图','fontsize',18);

%三维曲面图
%mesh(x,y,z,c)：画网格曲面，将数据点在空间中描出,并连成网格。 
%surf(x,y,z,c)：画完整曲面，将数据点所表示曲面画出。
figure(3)
mesh(x, y, u);
title('行方向的矢量图','fontsize',18);
figure(4)
surf(x, y, v);
title('列方向的矢量图','fontsize',18);

%组合重叠图
image_mix = zeros(m,n,3);
image_three = m_GrayWindow(Dscm,1,16);

for i = 1:m
    for jj =1:n
        image_mix(i,jj,2) = pro_a(i,jj);
        image_mix(i,jj,1) = pro_b(i,jj);
        image_mix(i,jj,3) = round(image_three(i,jj));
    end
end

figure(5)
imshow(uint8(image_mix));
title('相关图像组合图','fontsize',18);