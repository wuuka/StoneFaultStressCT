%% 
clc,clear
img_path_list = dir(strcat( '.\pic\'));  %获取该文件夹中格式的图像
img_num = length(img_path_list);  %获取图像总数量
max_pixel = [];
cellMatrix=cell(1,img_num-2);
cellMatrix_gra=cell(1,img_num-2);
if img_num > 2  %有满足条件的图像
    for i = 3:img_num  %逐一读取图像
        figure(i-2)
        image_name = img_path_list(i).name;  % 图像名
        im =  dicomread(strcat( '.\pic\',image_name));
        max_pixel = [max_pixel, max(im(:))];
        im_pro = m_GrayWindow(im,2000,3500);  %2500,3000;2048,3600
        %imwrite(uint8(im_pro),'1.png');
        cellMatrix{i-2} = im_pro;  %存储处理后图像数据
        imshow(uint8(im_pro))
        figure(2*(i-2))
        Ggram = m_HistogramEqualiza(im_pro);
        cellMatrix_gra{i-2} = Ggram;
        imshow(uint8(Ggram))
        image_out = change(Ggram);
        figure(3*(i-2))
        imshow(image_out);
        fprintf('%d %s\n',i-2,strcat('.\pic\',image_name));  % 显示正在处理的图像名
    end
end


DataResult = cell(img_num-2,img_num-2);
for num = 1:length(cellMatrix_gra)-1 %计算每两个组合的差异情况
    for num_latter = num+1:1:length(cellMatrix_gra)
        [sum, detax, detay] = SumSquaredDiff(cellMatrix_gra{num}, cellMatrix_gra{num_latter}, 7);  %两两图像做差在3*3范围内
        min_number= min(min(sum));
        [x, y] = find(min_number==sum);
        DataResult{num, num_latter} =[min_number,x-8, y-8];
    end
end