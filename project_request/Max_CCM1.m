function [I, J, Y]=Max_CCM1(A,B,h,l)
% ��ģA��ԭͼ����ʼ�У��зֱ���h��l����A��B����ƽ�����õ�A��B���������ƶ�����
% ���ƶ�I�����أ����˶�J����
A=double(A);  B=double(B); 
% [w,v]=size(A);
K=10;  %�仯��һ��������

for m=1:2*K;  %%% �б仯��Χ
    for n=1:2*K  %%% �б仯��Χ
        C=B(h+m-20:h+m,l+n-20:l+n);  
        a=abs(A.*conj(C));  %%% ����
%         a=A.*conj(C);  %%% ����
        b=A.*conj(A);  %%% ��ĸһ
        c=C.*conj(C);  %%%����ĸ��
        gama(m,n)=sum(a(:))/sqrt(sum(b(:))*sum(c(:)));  %%% ���ϵ��    
%         gama(m,n)=abs(sum(a(:)))/sqrt(sum(b(:))*sum(c(:)));  %%% ���ϵ��  
   end
end
% figure,   imagesc(gama),  title('��������');  colormap(gray);  axis image off;  IMPIXELINFO;
[idx,idy]=find(gama==max(gama(:)));  %%% ��������ϵ�����ڵ�λ��
%I=abs(idx-K);%m,n��ֵ������Ի�����ֵ��m��nΪ 11��ʱ��X Y����Ի���0����λ��
%J=abs(idy-K);
I=idx-K;
J=idy-K;
% I=idx-1;
% J=idy-1;
Y=sqrt(I^2+J^2);














