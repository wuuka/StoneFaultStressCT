%% 
clc,clear
img_path_list = dir(strcat( '.\pic\'));  %��ȡ���ļ����и�ʽ��ͼ��
img_num = length(img_path_list);  %��ȡͼ��������
max_pixel = [];
cellMatrix=cell(1,img_num-2);
cellMatrix_gra=cell(1,img_num-2);
if img_num > 2  %������������ͼ��
    for i = 3:img_num  %��һ��ȡͼ��
        figure(i-2)
        image_name = img_path_list(i).name;  % ͼ����
        im =  dicomread(strcat( '.\pic\',image_name));
        max_pixel = [max_pixel, max(im(:))];
        im_pro = m_GrayWindow(im,2000,3500);  %2500,3000;2048,3600
        %imwrite(uint8(im_pro),'1.png');
        cellMatrix{i-2} = im_pro;  %�洢�����ͼ������
        imshow(uint8(im_pro))
        figure(2*(i-2))
        Ggram = m_HistogramEqualiza(im_pro);
        cellMatrix_gra{i-2} = Ggram;
        imshow(uint8(Ggram))
        image_out = change(Ggram);
        figure(3*(i-2))
        imshow(image_out);
        fprintf('%d %s\n',i-2,strcat('.\pic\',image_name));  % ��ʾ���ڴ����ͼ����
    end
end


DataResult = cell(img_num-2,img_num-2);
for num = 1:length(cellMatrix_gra)-1 %����ÿ������ϵĲ������
    for num_latter = num+1:1:length(cellMatrix_gra)
        [sum, detax, detay] = SumSquaredDiff(cellMatrix_gra{num}, cellMatrix_gra{num_latter}, 7);  %����ͼ��������3*3��Χ��
        min_number= min(min(sum));
        [x, y] = find(min_number==sum);
        DataResult{num, num_latter} =[min_number,x-8, y-8];
    end
end