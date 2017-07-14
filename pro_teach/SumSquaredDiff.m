%% 两幅图像重合度最高的状态

function [sum, detax, detay] = SumSquaredDiff(matrix_one, matrix_two, deta)
% 输入matrix_one、matrix_two两个矩阵；deta表示图像间位移的步长
% 输出sum为图像像素差的平方和，detax\detay表示位移方向距离

[m, n] = size(matrix_one);
matrix_one_pro = zeros(m+2*deta, n+2*deta);  %矩阵边缘扩展deta个单位
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

for i = 1:2*deta+1  %遍历(deta+2)^2次
    for j =1:2*deta+1
        
        sum_square = 0;
        for x = 1:m
            for y = 1:n
                sum_square = sum_square + (matrix_two(x,y) - matrix_one_pro(x+i-1,y+j-1))^2;  %偏移图像，像素差平方求和。
            end
        end
        
        detax(i,j) = i-deta-1;
        detay(i,j) = j-deta-1;
        sum(i,j) = sum_square;
    end
end