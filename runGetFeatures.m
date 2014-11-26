close all;
clear all;
clc;
% 1-5083 耗时 300s
addpath('feature\');
% method= {@refer_image_whole_standard_deviation,...%全图标准差F1
%         @image_roughness,...%绝对值粗糙度F2
%         @edge_density,...%边缘密度(同时返回均值与标准差，应用时取边缘标准差)F3, F4
%         @zero_cross_density,...%零交叉密度F5
%         @refer_image_whole_entropy,...%全图信息熵F6
%         @mean_FBM_dimension,...%平均FBM维数F7
%         @MinLocalStd,...%最小局部标准差F8
%         @frieden_entropy,...%Frieden灰度熵F9
%         @image_meanGradientIntensity,...%梯度强度均值F10
%         @phase_complexity,...%高频信息比 F11
%         @hpf_grid};%最小局部高频信息和 F12
v=[];
img_dir = dir('../image/datav/*.jpg');
num = length(img_dir);
sim = zeros([5,num]);
tic;
for k=1:num
    ImgRef = imread(['../image/datav/', img_dir(k).name]);
    disp(['runGetFeature ', num2str(k), ' of', num2str(num)]);
        f1=refer_image_whole_standard_deviation(ImgRef);%全图标准差F1
        f2 = image_roughness(ImgRef);%绝对值粗糙度F2
        [f3,f4]=edge_density(ImgRef);%边缘密度(同时返回均值与标准差，应用时取边缘标准差)F3, F4
        f5 = zero_cross_density(ImgRef);%零交叉密度F5
        f6 = refer_image_whole_entropy(ImgRef);%全图信息熵F6
        f7 = mean_FBM_dimension(ImgRef);%平均FBM维数F7
        f8 = MinLocalStd(ImgRef);%最小局部标准差F8
        f9 = frieden_entropy(ImgRef); %Frieden灰度熵F9
        f10 = image_meanGradientIntensity(ImgRef);%梯度强度均值F10
        f11= phase_complexity(ImgRef);%高频信息比 F11
        f12= hpf_grid(ImgRef,4);%最小局部高频信息和 F12        
        v=[v; f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12];   
        
%         f13= edge_density_new(ImgRef);
%         v=[v; f13];  
end
toc;
% f13= v;
% save('ftr_f13.mat','f13'); 
save(['../data/ftr-',num2str(num),'.mat'],'v'); 

