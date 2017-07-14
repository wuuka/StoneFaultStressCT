%% ����ͼ���غ϶���ߵ�״̬

function [sum, detax, detay] = SumSquaredDiff(matrix_one, matrix_two, deta)
% ����matrix_one��matrix_two��������deta��ʾͼ���λ�ƵĲ���
% ���sumΪͼ�����ز��ƽ���ͣ�detax\detay��ʾλ�Ʒ������

[m, n] = size(matrix_one);
matrix_one_pro = zeros(m+2*deta, n+2*deta);  %�����Ե��չdeta����λ
for x_m = 1:m
    for y_n = 1:n
        matrix_one_pro(x_m+deta,y_n+deta) = matrix_one(x_m, y_n);
    end
end
% figure(7)
% imshow(uint8(matrix_one_pro));

detax = zeros(2*deta+1,2*deta+1);
detay = zeros(2*deta+1,2*deta+1);
sum =zeros(2*deta+1,2*deta+1);

for i = 1:2*deta+1  %����(deta+2)^2��
    for j =1:2*deta+1
        
        sum_square = 0;
        for x = 1:m
            for y = 1:n
                sum_square = sum_square + (matrix_two(x,y) - matrix_one_pro(x+i-1,y+j-1))^2;  %ƫ��ͼ�����ز�ƽ����͡�
            end
        end
        
        detax(i,j) = i-deta-1;
        detay(i,j) = j-deta-1;
        sum(i,j) = sum_square;
    end
end