function DSCMtest
M =20;
KK = 2*M+1;
% win_origi = zeros(KK,KK);%ͼ���������С
% win_defor = zeros(KK,KK);
step = 1;%����ڵ㲽��
max = -inf;%��غ�����ֵ
maxi = 1;%��ֵ������
maxj = 1;
count = 1;%��ǵ����
count_pk = 1;
%��ͼ��
origi_im = dicomread('.\pic\s10_I10');
defor_im = dicomread('.\pic\s20_I10');
% figure;imshow(origi_im);%��ʾͼƬ
% figure;imshow(defor_im);
%��ɫ=>�Ҷ�
% origi_im = rgb2gray(origi_im);
% defor_im = rgb2gray(defor_im);
% %ͼ��������
% origi_im_ex=zero_expan(origi_im,M);
% defor_im_ex=zero_expan(defor_im,M);
%����ֵתΪ������
origi_im_ex = im2double(origi_im);
defor_im_ex = im2double(defor_im);
[p,q]=size(origi_im_ex);
p = floor(p/step)*step;%ȡɨ��߽�
q = floor(q/step)*step;
a = floor(p/KK)*KK;
b = floor(q/KK)*KK;

%����غ�������ǰ��ͼ�����������Ƴ̶�
for s = KK:KK:a%���ͼ�صò������п����α����������Ѿ�����ͼ���ڣ��˴���Ҫ������������Ҫ���ͼ׼ȷ��~~��һ�������������ȡ������֮��ı�������ʱ��û���α�ģ����Ҫ����
    %�����Ӵ����ƶ��Ĳ�������ɨ�費����֮ǰ��������ô������ѡȡ�ĸ����Ǻ��ٵģ����ֽ��Ƶľ�ȷ�Ȼ᲻��̫�ͣ�
    for k = KK:KK:b
        for i = KK:step:p
            for j = KK:step:q
                win_origi = origi_im_ex(s-KK+1:s,k-KK+1:k);%ȡ������
                win_defor = defor_im_ex(i-KK+1:i,j-KK+1:j);
                %��غ�������
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
        %��¼ÿ�����λ��
        flag(count,1) = s-M;%ԭͼ���������ĵ�
        flag(count,2) = k-M;
        flag(count,3) = maxi-M;%�α���Ӧλ�����������ĵ�
        flag(count,4) = maxj-M;
        flag(count,5) = s-maxi;%���λ��
        flag(count,6) = k-maxj;
        flag(count,7) = max;%��غ�����ֵ
        count_pk = 1;
        max = -inf;
        %���ÿ����غ���
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
%������λ��
disp(flag);
%�����д��txt��
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
%�ܶ�ϸ������û�д���&��*��*��������*&

%%  ͼ�������غ���******************
function X_ex = zero_expan(X,M)  %������
[m,n] = size(X);
long = floor(M);
X_ex = [zeros(long,2*long+n);zeros(m,long),X,zeros(m,long);zeros(long,2*long+n)];


%% ��غ���*****************
function [pk] = Cp(winO, winD)
fm = mean2(winO);  %������ҶȾ�ֵ
gm = mean2(winD);
[m n] = size(winO);
fm = ones(m,n)*fm;
gm = ones(m,n)*gm;
numerator = (sum(sum((winO-fm).*(winD-gm))))^2;%�������Ӽ���
denominator = sum(sum((winO-fm).^2))*sum(sum((winD-gm).^2));%������ĸ����
pk = numerator/denominator;%��غ�������ֵ




