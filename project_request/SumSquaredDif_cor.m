function [detax, detay, Y]=SumSquaredDif_cor(A,B,de_x,de_y,width)

A=double(A);  B=double(B);

for m=1:width
    for n=1:width
        
        C=B(de_x+m-width:de_x+m,de_y+n-width:de_y+n);  
        A_sum = mean2(A);  %������ҶȾ�ֵ
        C_sum = mean2(C);
        [mm, nn] = size(A);
        A_sum = ones(mm, nn)*A_sum;
        C_sum = ones(mm, nn)*C_sum;
        numerator = (sum(sum((A-A_sum).*(C-C_sum))))^2;  %����
        denominator = sum(sum((A-A_sum).^2))*sum(sum((C-C_sum).^2));  %��ĸ
        gama(m,n) = numerator/denominator;%��غ�������ֵ
        
    end
end

[idx,idy]=find(gama==max(gama(:)));  %%% ����С���ز�ƽ����ϵ�����ڵ�λ��
detax=idx-width/2;  %m,n��ֵ������Ի�����ֵ��m��nΪ 11��ʱ��X Y����Ի���0����λ��
detay=idy-width/2;
Y=sqrt(detax^2+detay^2);

