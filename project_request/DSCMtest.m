function DSCMtest
M =20;
KK = 2*M+1;
% win_origi = zeros(KK,KK);%图像子区间大小
% win_defor = zeros(KK,KK);
step = 1;%网格节点步长
max = -inf;%相关函数极值
maxi = 1;%极值点坐标
maxj = 1;
count = 1;%标记点计数
count_pk = 1;
%读图像
origi_im = dicomread('.\pic\s10_I10');
defor_im = dicomread('.\pic\s20_I10');
% figure;imshow(origi_im);%显示图片
% figure;imshow(defor_im);
%彩色=>灰度
% origi_im = rgb2gray(origi_im);
% defor_im = rgb2gray(defor_im);
% %图像零延拓
% origi_im_ex=zero_expan(origi_im,M);
% defor_im_ex=zero_expan(defor_im,M);
%像素值转为浮点型
origi_im_ex = im2double(origi_im);
defor_im_ex = im2double(defor_im);
[p,q]=size(origi_im_ex);
p = floor(p/step)*step;%取扫描边界
q = floor(q/step)*step;
a = floor(p/KK)*KK;
b = floor(q/KK)*KK;

%用相关函数评价前后图像子区间相似程度
for s = KK:KK:a%如果图截得不完整有可能形变后区域根本已经不在图像内，此处需要条件处理（或者要求截图准确）~~另一种情况：子区域取到材料之外的背景，此时是没有形变的，这点要处理
    %关于子窗口移动的步长，若扫描不覆盖之前的区域，那么子区间选取的个数是很少的，这种近似的精确度会不会太低？
    for k = KK:KK:b
        for i = KK:step:p
            for j = KK:step:q
                win_origi = origi_im_ex(s-KK+1:s,k-KK+1:k);%取子区间
                win_defor = defor_im_ex(i-KK+1:i,j-KK+1:j);
                %相关函数计算
                pk(count_pk,1) = i-M;
                pk(count_pk,2) = j-M;
                pk(count_pk,3) = Cp(win_origi, win_defor);
                if max < pk(count_pk,3)
                    max = pk(count_pk,3);
                    maxi = i;
                    maxj = j;
                end
                %X Y Z
                ix = floor((i-KK)/step+1);
                jy = floor((j-KK)/step+1);
                X(ix,jy) = i-M;
                Y(ix,jy) = j-M;
                Z(ix,jy) = pk(count_pk,3);
                
                count_pk = count_pk+1;
            end
        end
        %记录每个点的位移
        flag(count,1) = s-M;%原图子区间中心点
        flag(count,2) = k-M;
        flag(count,3) = maxi-M;%形变后对应位置子区间中心点
        flag(count,4) = maxj-M;
        flag(count,5) = s-maxi;%相对位移
        flag(count,6) = k-maxj;
        flag(count,7) = max;%相关函数极值
        count_pk = 1;
        max = -inf;
        %输出每个相关函数
% %                 fid=fopen(strcat(strcat('data',num2str(count)),'.txt'),'w');
% %                 fprintf(fid, [repmat('%f  ', 1, size(pk,2)), '\r\n'], pk');
% %                 fclose(fid);
        
        %C = [X;Y;Z];
        % %         fid=fopen(strcat(strcat('X',num2str(count)),'.txt'),'w');
        % %         fprintf(fid, [repmat('%f  ', 1, size(X,2)), '\r\n'], X');
        % %         fclose(fid);
        % %         fid=fopen(strcat(strcat('Y',num2str(count)),'.txt'),'w');
        % %         fprintf(fid, [repmat('%f  ', 1, size(Y,2)), '\r\n'], Y');
        % %         fclose(fid);
        % %         fid=fopen(strcat(strcat('Z',num2str(count)),'.txt'),'w');
        % %         fprintf(fid, [repmat('%f  ', 1, size(Z,2)), '\r\n'], Z');
        % %         fclose(fid);
        
        count = count+1;
    end
end
%输出相对位移
disp(flag);
%将结果写入txt中
[m,n] = size(flag);
fid=fopen('data.txt','w');
% for i = i:m
%     for j = 1:n
%         fprintf(fid, '%f\t', flag(i,j));
%     end
%     fprintf(fid,'\n');
% end
fprintf(fid, [repmat('%f  ', 1, size(flag,2)), '\r\n'], flag');
fclose(fid);
%很多细节条件没有处理&（*）*…………*&

%%  图像零延拓函数******************
function X_ex = zero_expan(X,M)  %零延拓
[m,n] = size(X);
long = floor(M);
X_ex = [zeros(long,2*long+n);zeros(m,long),X,zeros(m,long);zeros(long,2*long+n)];


%% 相关函数*****************
function [pk] = Cp(winO, winD)
fm = mean2(winO);  %子区域灰度均值
gm = mean2(winD);
[m n] = size(winO);
fm = ones(m,n)*fm;
gm = ones(m,n)*gm;
numerator = (sum(sum((winO-fm).*(winD-gm))))^2;%函数分子计算
denominator = sum(sum((winO-fm).^2))*sum(sum((winD-gm).^2));%函数分母计算
pk = numerator/denominator;%相关函数计算值




