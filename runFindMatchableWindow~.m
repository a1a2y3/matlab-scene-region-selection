%% 说明
% 计算特征，估计适配性
% 输入大图，在大图上标示前N个最适合的匹配区
%% get image region features
close all;
clear all;
clc;
imgNo= 'p001';
winR=  100;
travelstep_R=120;   %Row
travelstep_C=travelstep_R;   %Column
ImgRefSize_R=200;    
ImgRefSize_C=ImgRefSize_R;    
imgName= ['images\' imgNo '.jpg'];
matName= ['images\' imgNo '.mat'];
tic;
cnt=0;
mf=[];
im= imread(imgName);
if size(im,3)>1
    im= rgb2gray(im);
end
imBackup= im;
h = fspecial('average',5);
im= imfilter(im,h);
[m,n]=size(im);
blockR=fix((m-ImgRefSize_R)/travelstep_R);
blockC=fix((n-ImgRefSize_C)/travelstep_C);    
for i=1:blockR
    OffsetR_r=(i-1)*travelstep_R+1;  %相对行偏移    
    for j=1:blockC
        OffsetC_r=(j-1)*travelstep_C+1;  %相对列偏移
        cnt= cnt+1;
        ImgRef=im(OffsetR_r:OffsetR_r+ImgRefSize_R-1,OffsetC_r:OffsetC_r+ImgRefSize_C-1);
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
        %高频信息比 F11
        f11= phase_complexity(ImgRef);
        %最小局部高频信息和 F12
        f12= hpf_grid(ImgRef,4);
        vf=[0 OffsetR_r OffsetC_r ImgRefSize_R ImgRefSize_C cnt ...
            f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12];
        mf= [mf; vf];
    end
end
testdata.imagename= imgName;
testdata.ImgRefSize_R= ImgRefSize_R;
testdata.ImgRefSize_C= ImgRefSize_C;
testdata.travelstep_R= travelstep_R;
testdata.travelstep_C= travelstep_C;
testdata.image    = im;
testdata.v15      = mf;
save(matName,'testdata');
toc;
%% find most matchable regions
addpath('LSSVMlabv1_8_R2009b_R2011a');
writeName='result\\%04d.jpg';
load(['images\' imgNo '.mat']);
v15= testdata.v15;
mf= v15(:,7:18);
% mf= [v15(:,7),v15(:,8),v15(:,9),v15(:,10),v15(:,11),v15(:,12),...
%     v15(:,13),v15(:,14),v15(:,16)];
%% use regressionTree
% load('regTree.mat');
% mr1= predict(regTree,mf);
%% use lssvm
% load('models\lssvm_.mat');
% [m,n]= size(mf);
% mf= (mf-repmat(mydata.v_low, m, 1))./...
%     (repmat(mydata.v_high, m, 1)-repmat(mydata.v_low, m, 1));
% mr1 = simlssvm(mydata.model,mf);
%% use pcalssvm
load('models\pcalssvm_linear.mat');
% load('models\pcalssvm_poly2.mat');
% load('models\pcalssvm_rbf.mat');
tic;
mf= mf./repmat(mydata.stdr,size(mf,1),1)*mydata.pcacoeff;
mf= mf(:,1:mydata.pcan);
mr1 = simlssvm(mydata.model,mf);
toc;
%% use single feature
% mr1 = mf(:,12);
%% show
v15(:,1)= mr1;
refSize_R= testdata.ImgRefSize_R;
refSize_C= testdata.ImgRefSize_C;
[~,IX] = sort(v15(:,1),'descend');
figure; imshow(testdata.image);
% outV=[];
tic;
for i=1:200
    imgRef= testdata.image(v15(IX(i),2):v15(IX(i),2)+refSize_R-1,...
        v15(IX(i),3):v15(IX(i),3)+refSize_C-1);
    v15(IX(i),4)= corrMatchFast(imgRef,winR);   
%     refName= sprintf(writeName, i);
%     imwrite(imgRef, refName);
    rectangle('Position',...
        [v15(IX(i),3),v15(IX(i),2),refSize_C,refSize_R],...
        'EdgeColor','r');  %rectangle('Position',[x,y,w,h])
end
toc;
save(['images\' imgNo '_v15_' num2str(ImgRefSize_R) '_' num2str(winR) '.mat'],'v15');
figure; imshow(testdata.image);
[~,IX2] = sort(v15(:,4),'ascend');
for i=1:50
    imgRef= testdata.image(v15(IX2(i),2):v15(IX2(i),2)+refSize_R-1,...
        v15(IX2(i),3):v15(IX2(i),3)+refSize_C-1);
    refName= sprintf(writeName, i);
    imwrite(imgRef, refName);
    rectangle('Position',...
        [v15(IX2(i),3),v15(IX2(i),2),refSize_C,refSize_R],...
        'EdgeColor','r');  %rectangle('Position',[x,y,w,h])
end
% i=i+1;
% refName= sprintf(writeName, i);
% imwrite(testdata.image, refName);
