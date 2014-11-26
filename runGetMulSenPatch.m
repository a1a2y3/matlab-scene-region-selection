%%*****************程序说明*************************
%功能 ：在异源图像集上选取符合匹配区范围的图像区域
%%
clear;
close all;
clc;
format long g;
travelstep_R=120;   %Row
travelstep_C=120;   %Column
ImgRefSize_R=200;    
ImgRefSize_C=200;    
imgType = 'vis-ir';
writeName='%06d.jpg';
nSrc=17;   % vis-ir 17     vis-sar 27
cnt=0;
mkdir([imgType,'-A']);
mkdir([imgType,'-B']);
tic;
for k=1:nSrc
    disp(['runGetMulSenPatch image ', num2str(k), ' of', num2str(nSrc)]);
    imA = imread(['异源图像库1.0\',imgType,'\small-',num2str(k),'.bmp']);
    imB = imread(['异源图像库1.0\',imgType,'\large-',num2str(k),'.bmp']);
    [m,n]=size(imA);
    blockR=1+floor((m-ImgRefSize_R)/travelstep_R);
    blockC=1+floor((n-ImgRefSize_C)/travelstep_C);    
    for i=1:blockR
        OffsetR_r=(i-1)*travelstep_R+1;  %相对行偏移    
        for j=1:blockC
            OffsetC_r=(j-1)*travelstep_C+1;  %相对列偏移
            cnt= cnt+1;
            refName= sprintf(writeName, cnt);
            patchA=imA(OffsetR_r:OffsetR_r+ImgRefSize_R-1,OffsetC_r:OffsetC_r+ImgRefSize_C-1);
            patchB=imB(OffsetR_r:OffsetR_r+ImgRefSize_R-1,OffsetC_r:OffsetC_r+ImgRefSize_C-1);
            
            imwrite(patchA, [imgType,'-A\',refName]);
            imwrite(patchB, [imgType,'-B\',refName]);
        end
    end
end
toc;