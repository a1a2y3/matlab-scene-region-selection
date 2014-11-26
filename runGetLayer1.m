%%*****************程序说明*************************
%功能 ：在大面积的基准图源上选取保存多个符合匹配区范围的图像区域
%%
clear;
close all;
clc;
format long g;
travelstep_R=200;   %Row
travelstep_C=200;   %Column
ImgRefSize_R=200;    
ImgRefSize_C=200;    
img_dir = dir('../image/source/*.jpg');
num = length(img_dir);
cnt=0;tic;
vLayer1= [];
for k=1:num
    disp(['runGetPatch image ', num2str(k), ' of', num2str(num)]);
    im = imread(['../image/source/', img_dir(k).name]);
    if size(im,3)>1
       im= rgb2gray(im);
    end
    edgemap= edge(im,'canny');
    varmap= regionVar(im);
    [m,n]=size(im);
    blockR=fix((m-ImgRefSize_R)/travelstep_R);
    blockC=fix((n-ImgRefSize_C)/travelstep_C);    
    for i=1:blockR
        OffsetR_r=(i-1)*travelstep_R+1;  %相对行偏移    
        for j=1:blockC
            OffsetC_r=(j-1)*travelstep_C+1;  %相对列偏移
            cnt= cnt+1;
%             imgRef=im(OffsetR_r:OffsetR_r+ImgRefSize_R-1,OffsetC_r:OffsetC_r+ImgRefSize_C-1);
%             refName= sprintf(writeName, cnt);
%             imwrite(imgRef, refName);
            win1= edgemap(OffsetR_r:OffsetR_r+ImgRefSize_R-1,OffsetC_r:OffsetC_r+ImgRefSize_C-1);
            f1= mean(win1(:));
            win2= varmap(OffsetR_r:OffsetR_r+ImgRefSize_R-1,OffsetC_r:OffsetC_r+ImgRefSize_C-1);
            f2= mean(win2(:));
            vLayer1= [vLayer1; [f1, f2]];
        end
    end
end
save(['../data/vlayer1-',num2str(cnt),'.mat'],'vLayer1'); 
toc;