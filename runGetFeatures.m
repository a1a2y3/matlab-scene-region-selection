close all;
clear all;
clc;
% 1-5083 ��ʱ 300s
addpath('feature\');
% method= {@refer_image_whole_standard_deviation,...%ȫͼ��׼��F1
%         @image_roughness,...%����ֵ�ֲڶ�F2
%         @edge_density,...%��Ե�ܶ�(ͬʱ���ؾ�ֵ���׼�Ӧ��ʱȡ��Ե��׼��)F3, F4
%         @zero_cross_density,...%�㽻���ܶ�F5
%         @refer_image_whole_entropy,...%ȫͼ��Ϣ��F6
%         @mean_FBM_dimension,...%ƽ��FBMά��F7
%         @MinLocalStd,...%��С�ֲ���׼��F8
%         @frieden_entropy,...%Frieden�Ҷ���F9
%         @image_meanGradientIntensity,...%�ݶ�ǿ�Ⱦ�ֵF10
%         @phase_complexity,...%��Ƶ��Ϣ�� F11
%         @hpf_grid};%��С�ֲ���Ƶ��Ϣ�� F12
v=[];
img_dir = dir('../image/datav/*.jpg');
num = length(img_dir);
sim = zeros([5,num]);
tic;
for k=1:num
    ImgRef = imread(['../image/datav/', img_dir(k).name]);
    disp(['runGetFeature ', num2str(k), ' of', num2str(num)]);
        f1=refer_image_whole_standard_deviation(ImgRef);%ȫͼ��׼��F1
        f2 = image_roughness(ImgRef);%����ֵ�ֲڶ�F2
        [f3,f4]=edge_density(ImgRef);%��Ե�ܶ�(ͬʱ���ؾ�ֵ���׼�Ӧ��ʱȡ��Ե��׼��)F3, F4
        f5 = zero_cross_density(ImgRef);%�㽻���ܶ�F5
        f6 = refer_image_whole_entropy(ImgRef);%ȫͼ��Ϣ��F6
        f7 = mean_FBM_dimension(ImgRef);%ƽ��FBMά��F7
        f8 = MinLocalStd(ImgRef);%��С�ֲ���׼��F8
        f9 = frieden_entropy(ImgRef); %Frieden�Ҷ���F9
        f10 = image_meanGradientIntensity(ImgRef);%�ݶ�ǿ�Ⱦ�ֵF10
        f11= phase_complexity(ImgRef);%��Ƶ��Ϣ�� F11
        f12= hpf_grid(ImgRef,4);%��С�ֲ���Ƶ��Ϣ�� F12        
        v=[v; f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12];   
        
%         f13= edge_density_new(ImgRef);
%         v=[v; f13];  
end
toc;
% f13= v;
% save('ftr_f13.mat','f13'); 
save(['../data/ftr-',num2str(num),'.mat'],'v'); 

