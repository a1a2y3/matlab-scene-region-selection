close all;
clear all;
clc;
% 1-1500 data1+data2 耗时 154.96s
% 1501-1792 data1+data2耗时 20.63s
tic;
v=[];
seq= 1:5808;
for i=seq
    imgName= ['..\datai\',num2str(i,'%06d'),'.jpg'];
    ImgRef=imread(imgName);
        %全图标准差F1
        f1=refer_image_whole_standard_deviation(ImgRef);
        %绝对值粗糙度F2
        f2 = image_roughness(ImgRef);
        %边缘密度(同时返回均值与标准差，应用时取边缘标准差)F3, F4
        [f3,f4]=edge_density(ImgRef);
        %零交叉密度F5
        f5 = zero_cross_density(ImgRef);
        %全图信息熵F6
        f6 = refer_image_whole_entropy(ImgRef);
        %平均FBM维数F7
        f7 = mean_FBM_dimension(ImgRef);
        %最小局部标准差F8
        f8 = MinLocalStd(ImgRef);
        %Frieden灰度熵F9
        f9 = frieden_entropy(ImgRef);
        %梯度强度均值F10
        f10 = image_meanGradientIntensity(ImgRef);
        v=[v; f1 f2 f3 f4 f5 f6 f7 f8 f9 f10];
end
toc;        

