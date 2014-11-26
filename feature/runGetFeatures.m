close all;
clear all;
clc;
% 1-1500 data1+data2 ��ʱ 154.96s
% 1501-1792 data1+data2��ʱ 20.63s
tic;
v=[];
seq= 1:5808;
for i=seq
    imgName= ['..\datai\',num2str(i,'%06d'),'.jpg'];
    ImgRef=imread(imgName);
        %ȫͼ��׼��F1
        f1=refer_image_whole_standard_deviation(ImgRef);
        %����ֵ�ֲڶ�F2
        f2 = image_roughness(ImgRef);
        %��Ե�ܶ�(ͬʱ���ؾ�ֵ���׼�Ӧ��ʱȡ��Ե��׼��)F3, F4
        [f3,f4]=edge_density(ImgRef);
        %�㽻���ܶ�F5
        f5 = zero_cross_density(ImgRef);
        %ȫͼ��Ϣ��F6
        f6 = refer_image_whole_entropy(ImgRef);
        %ƽ��FBMά��F7
        f7 = mean_FBM_dimension(ImgRef);
        %��С�ֲ���׼��F8
        f8 = MinLocalStd(ImgRef);
        %Frieden�Ҷ���F9
        f9 = frieden_entropy(ImgRef);
        %�ݶ�ǿ�Ⱦ�ֵF10
        f10 = image_meanGradientIntensity(ImgRef);
        v=[v; f1 f2 f3 f4 f5 f6 f7 f8 f9 f10];
end
toc;        

