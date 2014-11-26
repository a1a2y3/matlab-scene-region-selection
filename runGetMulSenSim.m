%%*****************程序说明*************************
%功能 ：计算异源图像相似度
%%
clear;
close all;
clc;
wReal= 100;
imgType='vis-ir';  % 'vis-ir','vis-sar'
img_dir= dir([imgType,'-A/*.jpg']);
num = length(img_dir);
sim = zeros(num,1);
tic;
for k=1:num
    disp(['runGetMulSenSim image ', num2str(k), ' of', num2str(num)]);
    kname= img_dir(k).name;
    imA= imread([imgType,'-A/', kname]);
    imB= imread([imgType,'-B/', kname]);
    [sim(k),~,~]= CrossMatchRate_BSC0(imA,imB,wReal);
%     imA= imresize(imA,0.5);
%     imB= imresize(imB,0.5);
%     sim(k)= CrossSimRateAOG(imA,imB,wReal/2,wReal/2);
end
toc;
save(['sim-',imgType,'.mat'],'sim'); 
