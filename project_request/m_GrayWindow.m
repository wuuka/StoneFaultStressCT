%% 灰级窗
%  @matrix -- 输入的图像为灰度图
% 原理：只对[fa,fb]映射到[0,255]
function G = m_GrayWindow(matrix,fa,fb)
[row,col] = size(matrix);
beld = 255/(fb-fa);  %对图像素
G = zeros(row,col);

for i=1:row
    for j=1:col
        if (matrix(i,j)>=fa) && (matrix(i,j)<fb)
            G(i,j) = beld*(matrix(i,j)-fa);
        end
        if matrix(i,j) >=fb
            G(i,j) = 255;
        end
    end
end