%%
clc,clear
img_path_list = dir(strcat( '.\pic\'));  %��ȡ���ļ����и�ʽ��ͼ��
img_num = length(img_path_list);  %��ȡͼ��������
Atlas=cell(1,img_num-2);
if img_num > 2  %������������ͼ��
    for i = 3:img_num  %��һ��ȡͼ��
        
        image_name = img_path_list(i).name;
        im_pro =  dicomread(strcat( '.\pic\',image_name));
        im_pro = m_GrayWindow(im_pro,2000,3500);  %2500,3000;2048,3600
        %image_out = change(im_pro);
        image_out = zeros(640,640);  %ͼ����ģ�ߴ�
        image_out = im_pro(223:862,193:832);
        %figure(i-2)
        %imshow(uint8(image_out));
        Atlas{i-2} = image_out;  %�洢�����ͼ������
        fprintf('%d %s\n',i-2,strcat('.\pic\',image_name));  % ��ʾ���ڴ����ͼ����
    end
end

pro_a=Atlas{1,1};
pro_b=Atlas{1,2};
[m,n]=size(pro_b);
deta_X = zeros(m, n);
data_Y = zeros(m, n);
Dscm=zeros(m,n);
width = 10;

time_begin = clock;  %ʱ�����
for i=12:5:m-12  %ȡ�м�����200��200��
    for j=12:5:n-12
        A=pro_a(i-width/2:i+width/2,j-width/2:j+width/2);  %����20*20�Ļ�����
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

% %%ѡȡ��ע����
% pre=im2bw(pro_a,graythresh(pro_a));  %Otsu������ֵ��ֵ��
% [l,z]=bwlabel(pre);
% b=0;
% 
% for i=1:max(max(l))  %�ҳ���������
%     c=sum(l(l==i))/i;  %һ���ǩ����
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

Dscm_pud=flipud(Dscm);  %���������û�������λ��ͼ�������������½�
figure(1)
contourf(Dscm_pud);
colorbar;
%colormap(jet)
title('���ͼ��λ��ͼ','fontsize',18);


%ʸ��ͼ
[x, y] = meshgrid(1:10:m,1:10:n);
u = deta_X(x(1,:), y(:,1));
v = data_Y(x(1,:), y(:,1));

figure(2)
imshow(uint8(pro_a));
%contour(x,y,sqrt(u.^2+v.^2));
hold on
quiver(x,y,u,v,'-k');
title('���ͼ��ʸ��ͼ','fontsize',18);

%��ά����ͼ
%mesh(x,y,z,c)�����������棬�����ݵ��ڿռ������,���������� 
%surf(x,y,z,c)�����������棬�����ݵ�����ʾ���滭����
figure(3)
mesh(x, y, u);
title('�з����ʸ��ͼ','fontsize',18);
figure(4)
surf(x, y, v);
title('�з����ʸ��ͼ','fontsize',18);

%����ص�ͼ
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
title('���ͼ�����ͼ','fontsize',18);