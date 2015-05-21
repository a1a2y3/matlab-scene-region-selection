function findMatchableWindowMonoSensor_2layer(im,RefW,RefH,winW,winH,step)
%% 参数准备
if nargin<6
    step=100;
end
if nargin<4
    winW=refW/2;
    winH=refH/2;
end
if size(im,3)>1
    im= rgb2gray(im);
end
travelstep_h=step;   %Row
travelstep_w=travelstep_h;   %Column
ImgRefSize_h=RefH;    
ImgRefSize_w=RefW;    
% 计算特征，估计适配性,输入大图，在大图上标示前N个最适合的匹配区
%% 第一层选择 edge+var
h = fspecial('average',5);
im= imfilter(im,h);
[h, w]= size(im);
srh= floor((h-20-ImgRefSize_h)/travelstep_h)+1;
srw= floor((w-20-ImgRefSize_w)/travelstep_w)+1;
scoreList_1= zeros(srh*srw,3);
disp('var calculating  layer1');
varmap= regionVar(im);   % 方差21
disp('edge detecting  layer1');
edgemap= edge(im,'canny'); % 边缘
figure, imshow(im);
cnt=0;
for i=10:travelstep_h:h-10-ImgRefSize_h
    disp(['processing image ', num2str(cnt), ' of ', num2str(srh*srw), ' layer1']);
    for j=10:travelstep_w:w-10-ImgRefSize_w
        win1= edgemap(i:i+ImgRefSize_h-1,j:j+ImgRefSize_w-1);
        f1= mean(win1(:));
        win2= varmap(i:i+ImgRefSize_h-1,j:j+ImgRefSize_w-1);
        f2= mean(win2(:));
        cnt=cnt+1;
        scoreList_1(cnt,1)= f1*f2;
        scoreList_1(cnt,2)= j;   % x
        scoreList_1(cnt,3)= i;   % y
    end
end
%% show score map
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
N2= min(N2,N1);
% display layer1 result
for i=1:N2
    k= idx1(i);
    rectangle('Position',[scoreList_1(k,2),scoreList_1(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','r');
end
% saveas(gcf,'..\saveresult\region_find_bsc.emf');
%% 第三层选择 getSelfSim
% return;
N3= N2;
scoreList_3= zeros(N3,3);
h = fspecial('average', 7);
for i=1:N3
    disp(['evaluating ', num2str(i), 'of ', num2str(N3), ' layer3']);
    k= idx1(i);
    win3= im(scoreList_1(k,3):scoreList_1(k,3)+ImgRefSize_h-1,...
             scoreList_1(k,2):scoreList_1(k,2)+ImgRefSize_w-1);
    ratio = 70/sqrt(ImgRefSize_h*ImgRefSize_w);
    win3= imresize(win3,ratio);
    win3_s= imfilter(win3,h);
    win3_a= imnoise(win3,'speckle',0.4); 
    [mRate,~]= getSelfSim(win3_s,win3_a,winW*ratio,winH*ratio);
%     mRate= getSelfSim(win3,winR);
    scoreList_3(i,:)= [mRate scoreList_1(k,2) scoreList_1(k,3)];
end
[mRList,idx3]= sort(scoreList_3(:,1),'descend');
N4= min(ceil(N3/4),10);
% display result
for i=1:N4
    k= idx3(i);
    rectangle('Position',[scoreList_3(k,2),scoreList_3(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','b');    
end
saveas(gcf,'..\saveresult\region_find_bsc.emf');
figure;
for i=1:N4
    k= idx3(i);
    win3= im(scoreList_3(k,3):scoreList_3(k,3)+ImgRefSize_h-1,...
             scoreList_3(k,2):scoreList_3(k,2)+ImgRefSize_w-1,:);
    imshow(win3);
    text(10,10,['适配性: ' num2str(mRList(i),'%4.3f')],...
     'Color','y','FontSize',12,'FontWeight','normal');
    saveas(gcf,['..\saveresult\win-',num2str(i),'.jpg']);
end
close gcf;
