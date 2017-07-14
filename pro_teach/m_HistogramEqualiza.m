%% 直方图均衡化
%   @image-输入的图像为灰度图
%   1.求image的灰度直方图向量H
%   2.由H/row*col  得到灰度分布概率Pi，及计算累计分布概率Pa
%   3.求得255*Pa后，从原图image像素映射到Gi像素
%   @Gi-输出处理后图像
function Gi = m_HistogramEqualiza(image)
[row,col] = size(image);
num = max(max(image));  %矩阵中最大值
H = zeros(1,double(num)+1);  %灰度直方图向量
PI = zeros(1,double(num)+1);  %灰度分布概率
Pa = zeros(1,double(num)+1);  %累计分布概率
Gi = zeros(row,col);
format rat  %分数形式
for i=1:row
    for j=1:col
        H(double(image(i,j))+1)  = H(double(image(i,j))+1)+1; 
    end
end
PI = H/(row*col);

Pai = 0;
for m=2:double(num)+1
    Pai = Pai+PI(m);
    Pa(m) = Pai+PI(1);
end
Pa = round(double(num)*Pa);

for i=1:row
    for j=1:col
        Gi(i,j) = Pa(image(i,j)+1);
    end
end

% hist(H);
% x=1000:length(H);
% y = H(1,x);
% plot(x,y,'-ko');
% title('输入图像的灰度直方图');
% xlabel('灰度级范围');ylabel('像素累计数');
% figure;
% imhist(uint8(Gi));
% title('直方图均衡化后图像的灰度直方图');