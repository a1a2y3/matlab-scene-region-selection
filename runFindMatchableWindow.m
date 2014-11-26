% 计算特征，估计适配性,输入大图，在大图上标示前N个最适合的匹配区
%% get image region features
close all;
clear all;
clc;
%% set parameters
travelstep_h=100;   %Row
travelstep_w=travelstep_h;   %Column
ImgRefSize_h=200;    
ImgRefSize_w=ImgRefSize_h;    
winR=  100;
%% load image
% 可见光图像
% sq002, yh004, cs001, py001   用于3.1-3.3
%gb001,gb002,py002,sq004,sq005,sq006,sq007,yh001,yh002,yh003用于3.4
% im0= imread('..\image\source\cs001.jpg');
% SAR  sar1,sar2,sar3
im0= imread('..\image\SAR-source\sar2.jpg');
% im0= imresize(im0,0.5);   % 缩小尺寸，加快处理速度
if size(im0,3)>1
    im= rgb2gray(im0);
else
    im= im0;
end
h = fspecial('average',5);
im= imfilter(im,h);
%% 第一层选择 edge+var
[h, w]= size(im);
srh= floor((h-20-ImgRefSize_h)/travelstep_h)+1;
srw= floor((w-20-ImgRefSize_w)/travelstep_w)+1;
scoreList_1= zeros(srh*srw,3);
tic;
disp('edge detecting  layer1');
edgemap= edge(im,'canny');
toc;
tic;
disp('var calculating  layer1');
varmap= regionVar(im);
toc;
figure, imshow(im0);
cnt=0;
for i=10:travelstep_h:h-10-ImgRefSize_h
    disp(['processing image ', num2str(cnt), ' of ', num2str(srh*srw), ' layer1']);
    for j=10:travelstep_w:w-10-ImgRefSize_w
        win1= edgemap(i:i+ImgRefSize_h-1,j:j+ImgRefSize_w-1);
        f1= mean(win1(:));
        win2= varmap(i:i+ImgRefSize_h-1,j:j+ImgRefSize_w-1);
        f2= mean(win2(:));
%         if (f1>0.10 && f2>0.00)
%         if (f1*f2> 0.012)
%             rectangle('Position',[j,i,ImgRefSize,ImgRefSize],'EdgeColor','r');
%         end
        cnt=cnt+1;
        scoreList_1(cnt,1)= f1*f2;
        scoreList_1(cnt,2)= j;   % x
        scoreList_1(cnt,3)= i;   % y
    end
end
% show score map
% scoreMap_1= reshape(scoreList_1(:,1),srh,srw);
% figure, imagesc(scoreMap_1);
% sort score
N1= cnt;
% 显示全部候选窗口
% for i=1:N1
%     rectangle('Position',[scoreList_1(i,2),scoreList_1(i,3)...
%         ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','y');
% end
[~,idx1]= sort(scoreList_1(:,1),'descend');
N2= max(ceil(N1/5),100);
% display layer1 result
for i=1:N2
    k= idx1(i);
    rectangle('Position',[scoreList_1(k,2),scoreList_1(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','r');
end
% saveas(gcf,'..\saveresult\region_find_bsc.emf');
%% 第二层选择 9features+LSSVM
% return;
scoreList_2= zeros(N2,3);
mf= zeros(N2,9);
addpath('feature');
tic;
for i=1:N2
    disp(['feature extracting ', num2str(i), 'of ', num2str(N2), ' layer2']);
    k= idx1(i);
    ImgRef= im(scoreList_1(k,3):scoreList_1(k,3)+ImgRefSize_h-1,...
             scoreList_1(k,2):scoreList_1(k,2)+ImgRefSize_w-1);
    %全图标准差F1
    f1=refer_image_whole_standard_deviation(ImgRef);
    %绝对值粗糙度F2
    f2 = image_roughness(ImgRef);
    %边缘密度(同时返回均值与标准差，应用时取边缘标准差)F3, F4
%     [f3,f4]=edge_density(ImgRef);
    %零交叉密度F5
    f5 = zero_cross_density(ImgRef);
    %全图信息熵F6
    f6 = refer_image_whole_entropy(ImgRef);
    %平均FBM维数F7
%     f7 = mean_FBM_dimension(ImgRef);
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
    scoreList_2(i,:)= [0 scoreList_1(k,2) scoreList_1(k,3)];
    mf(i,:)= [f1 f2 f5 f6 f8 f9 f10 f11 f12];
end
toc;
% lssvm predict
addpath('../LSSVMlabv1_8_R2009b_R2011a');
load('..\models\lssvm_.mat');
tic;
disp(['lssvm predicting layer2']);
mf= (mf-repmat(mydata.v_low, N2, 1))./...
    (repmat(mydata.v_high, N2, 1)-repmat(mydata.v_low, N2, 1));
% 这里要不要考虑 设置最大最小值限制？？？？？？？？？？？？？？？？？？？？
scoreList_2(:,1) = simlssvm(mydata.model,mf);
toc;
[~,idx2]= sort(scoreList_2(:,1),'descend');
N3= min(ceil(N2/5),50);
% display layer2 result
for i=1:N3
    k= idx2(i);
    rectangle('Position',[scoreList_2(k,2),scoreList_2(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','g');
end
% saveas(gcf,'..\saveresult\region_find_bsc.emf');
%% 第三层选择 BSC matcher 
% return;
scoreList_3= zeros(N3,3);
tic;
h = fspecial('average', 10);
for i=1:N3
    disp(['evaluating ', num2str(i), 'of ', num2str(N3), ' layer3']);
    k= idx2(i);
    win3= im(scoreList_2(k,3):scoreList_2(k,3)+ImgRefSize_h-1,...
             scoreList_2(k,2):scoreList_2(k,2)+ImgRefSize_w-1); 
%     win3= imresize(win3,200/sqrt(ImgRefSize_h*ImgRefSize_w));
    win3_s= imfilter(win3,h);
    win3_a= imnoise(win3,'speckle',0.4);    
    [mRate,~,~]= CrossMatchRate_BSC0(win3_s,win3_a,winR);
%     mRate= getSelfSim(win3,winR);
    scoreList_3(i,:)= [mRate scoreList_2(k,2) scoreList_2(k,3)];
end
toc;
[mRList,idx3]= sort(scoreList_3(:,1),'descend');
N4= min(ceil(N3/4),10);
% display layer2 result
for i=1:N4
    k= idx3(i);
    rectangle('Position',[scoreList_3(k,2),scoreList_3(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','b');
    
    win3= im(scoreList_3(k,3):scoreList_3(k,3)+ImgRefSize_h-1,...
             scoreList_3(k,2):scoreList_3(k,2)+ImgRefSize_w-1);    
    imwrite(win3, ['..\saveresult\win-',num2str(i),'.jpg']);
end
saveas(gcf,'..\saveresult\region_find_bsc.emf');
