%% ֱ��ͼ���⻯
%   @image-�����ͼ��Ϊ�Ҷ�ͼ
%   1.��image�ĻҶ�ֱ��ͼ����H
%   2.��H/row*col  �õ��Ҷȷֲ�����Pi���������ۼƷֲ�����Pa
%   3.���255*Pa�󣬴�ԭͼimage����ӳ�䵽Gi����
%   @Gi-��������ͼ��
function Gi = m_HistogramEqualiza(image)
[row,col] = size(image);
num = max(max(image));  %���������ֵ
H = zeros(1,double(num)+1);  %�Ҷ�ֱ��ͼ����
PI = zeros(1,double(num)+1);  %�Ҷȷֲ�����
Pa = zeros(1,double(num)+1);  %�ۼƷֲ�����
Gi = zeros(row,col);
format rat  %������ʽ
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
% title('����ͼ��ĻҶ�ֱ��ͼ');
% xlabel('�Ҷȼ���Χ');ylabel('�����ۼ���');
% figure;
% imhist(uint8(Gi));
% title('ֱ��ͼ���⻯��ͼ��ĻҶ�ֱ��ͼ');