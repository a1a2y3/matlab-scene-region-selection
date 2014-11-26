%%*****************程序说明*************************
%功能 ：图像5级模糊S，5级加噪声A
%%
clear;
close all;
clc;
format long g;
imgType= 'vis-ir-B';  % 'datav','vis-ir-A','vis-ir-B','vis-sar-A','vis-sar-B'
img_dir = dir([imgType,'/*.jpg']);
num = length(img_dir);
for i=1:5
    mkdir([imgType,'-S',num2str(i)]);
    mkdir([imgType,'-A',num2str(i)]);
end
h = fspecial('average', 5);
tic;
for k=1:num
    disp(['runGetSA image ', num2str(k), ' of', num2str(num)]);
    im = imread([imgType,'/',img_dir(k).name]);
    imS= im;
    imA= im;
    for i=1:5
        imS= imfilter(imS,h);
        imA= imnoise(imA,'speckle',0.1);
        imwrite(imS,[imgType,'-S',num2str(i),'\', img_dir(k).name]);
        imwrite(imA,[imgType,'-A',num2str(i),'\', img_dir(k).name]);
    end
end
toc;