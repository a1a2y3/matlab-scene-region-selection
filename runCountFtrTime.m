close all;
clear all;
clc;
addpath('feature\');
v=zeros(100,13);
img_dir = dir('datav/*.jpg');
num = length(img_dir);
sim = zeros([5,num]);
tic;
for k=1:200
    ImgRef = imread(['datav/', img_dir(k).name]);
%         f=mean(ImgRef(:));
%         v(k,1)=f;   
end
toc;
tic;
for k=1:200
    ImgRef = imread(['datav/', img_dir(k).name]);
        f=mean(ImgRef(:));
        v(k,1)=f;   
end
toc;
tic;
for k=1:200
    ImgRef = imread(['datav/', img_dir(k).name]);
%         f1=refer_image_whole_standard_deviation(ImgRef);%全图标准差F1
%         f2 = image_roughness(ImgRef);%绝对值粗糙度F2
%         [f3,f4]=edge_density(ImgRef);%边缘密度(同时返回均值与标准差，应用时取边缘标准差)F3, F4
%         f5 = zero_cross_density(ImgRef);%零交叉密度F5
%         f6 = refer_image_whole_entropy(ImgRef);%全图信息熵F6
%         f7 = mean_FBM_dimension(ImgRef);%平均FBM维数F7
%         f8 = MinLocalStd(ImgRef);%最小局部标准差F8
%         f9 = frieden_entropy(ImgRef); %Frieden灰度熵F9
%         f10 = image_meanGradientIntensity(ImgRef);%梯度强度均值F10
%         f11= phase_complexity(ImgRef);%高频信息比 F11
        f12= hpf_grid(ImgRef,4);%最小局部高频信息和 F12
        v(k,2)=f12;   
end
toc;
