%%*****************程序说明*************************
%功能 ：计算5级图像的自相似度
%%
clear;
close all;
clc;
wReal= 100;
imgType= 'vis-ir-B';  % 'datav','vis-ir-A','vis-sar-A','vis-ir-B','vis-sar-B'
img_dir = dir([imgType,'/*.jpg']);
num = length(img_dir);
sim = zeros([5,num]);
matlabpool close;
matlabpool
tic;
for k=1:num
    disp(['runGetSim image ', num2str(k), ' of', num2str(num)]);
    kname= img_dir(k).name;
    parfor i=1:5
        im2= imread([imgType,'-S',num2str(i),'\',kname]);
        im3= imread([imgType,'-A',num2str(i),'\',kname]);
        [sim(i,k),~,~]= CrossMatchRate_BSC0(im2,im3,wReal);
    end
end
toc;
matlabpool close;
save(['sim-',imgType,'-5','.mat'],'sim'); 
