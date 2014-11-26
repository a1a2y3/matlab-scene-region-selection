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
%         f1=refer_image_whole_standard_deviation(ImgRef);%ȫͼ��׼��F1
%         f2 = image_roughness(ImgRef);%����ֵ�ֲڶ�F2
%         [f3,f4]=edge_density(ImgRef);%��Ե�ܶ�(ͬʱ���ؾ�ֵ���׼�Ӧ��ʱȡ��Ե��׼��)F3, F4
%         f5 = zero_cross_density(ImgRef);%�㽻���ܶ�F5
%         f6 = refer_image_whole_entropy(ImgRef);%ȫͼ��Ϣ��F6
%         f7 = mean_FBM_dimension(ImgRef);%ƽ��FBMά��F7
%         f8 = MinLocalStd(ImgRef);%��С�ֲ���׼��F8
%         f9 = frieden_entropy(ImgRef); %Frieden�Ҷ���F9
%         f10 = image_meanGradientIntensity(ImgRef);%�ݶ�ǿ�Ⱦ�ֵF10
%         f11= phase_complexity(ImgRef);%��Ƶ��Ϣ�� F11
        f12= hpf_grid(ImgRef,4);%��С�ֲ���Ƶ��Ϣ�� F12
        v(k,2)=f12;   
end
toc;
