% 边缘，方差，筛选20%最优区并排序，用自相关系数值进行确认 >0.6
close all
clear;
addpath('feature\');
im0= imread('..\image\source\sq001.jpg');
if size(im0,3)>1
    im= rgb2gray(im0);
else
    im= im0;
end
[h, w]= size(im);
travelstep=120; 
ImgRefSize=200;    
figure, imshow(im0);
scoremap= zeros(((h-20-ImgRefSize)/travelstep+1)*...
    ((w-20-ImgRefSize)/travelstep+1),4);
tic;
edgemap= edge(im,'canny');
toc;
tic;
varmap= regionVar(im);
toc;


cnt=0;
for i=10:travelstep:h-10-ImgRefSize
    for j=10:travelstep:w-10-ImgRefSize
        win1= edgemap(i:i+ImgRefSize-1,j:j+ImgRefSize-1);
        f1= mean(win1(:));
        win2= varmap(i:i+ImgRefSize-1,j:j+ImgRefSize-1);
        f2= mean(win2(:));
%         if (f1>0.10 && f2>0.00)
%         if (f1*f2> 0.012)
%             rectangle('Position',[j,i,ImgRefSize,ImgRefSize],'EdgeColor','r');
%         end
        cnt=cnt+1;
        scoremap(cnt,1)= f1*f2;
        scoremap(cnt,2)= j;   % x
        scoremap(cnt,3)= i;   % y
    end
end
[~,idx1]= sort(scoremap(:,1),'descend');
selfsim= zeros(100,1);
tic;
for i=1:min(100,cnt/5)
    disp(['processing image ', num2str(i), 'of ', num2str(cnt/5)]);
    k= idx1(i);
    win3= im(scoremap(k,3):scoremap(k,3)+ImgRefSize-1,...
             scoremap(k,2):scoremap(k,2)+ImgRefSize-1);
    selfsim(i)= getSelfSim(win3,100);
    if selfsim(i)>0.6
        rectangle('Position',[scoremap(k,2),scoremap(k,3)...
            ,ImgRefSize,ImgRefSize],'EdgeColor','r');
    else
        rectangle('Position',[scoremap(k,2),scoremap(k,3)...
            ,ImgRefSize,ImgRefSize],'EdgeColor','b');
    end;
end
toc;