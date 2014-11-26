% 区域适配性评估
% 参考运行时间
% 400*400, wReal=200, 91s
% 400*400, wReal=100, 224s
% 200*200, wReal=100, 2.5s
% 200*200, wReal=40 , 12s
clear;
close all;
clc;
imName= '..\image\datav\000001.jpg';
wReal = 100;
iClass= 4;

im= imread(imName);
scl= sqrt(40000/numel(im));
im= imresize(im,scl);
[h0,w0]= size(im);
wReal= round(wReal*scl);
im2= im;
im3= im;
h = fspecial('average', 5);

tic;
for k=1:iClass
    im2= imfilter(im2,h);
    im3= imnoise(im3,'speckle',0.1);    
end
toc;
tic;
[sim,~,~]= CrossMatchRate_BSC0(im2,im3,wReal);
toc;
figure;
subplot(1,2,1);imshow(im2);
subplot(1,2,2);imshow(im3);
c1='y';%c2='m';c3='c';
% s1='-';%s2='--';s3=':';
subplot(1,2,1);
text(10,20,['区域大小:',num2str(h0),'×',num2str(w0)],...
    'Color',c1,'FontSize',12,'FontWeight','normal');
text(10,40,['小图边长:',num2str(wReal)],...
    'Color',c1,'FontSize',12,'FontWeight','normal');
text(10,60,['噪声等级: ',num2str(iClass)],...
    'Color',c1,'FontSize',12,'FontWeight','normal');
text(10,80,['适配性: ' num2str(sim,'%4.3f')],...
     'Color',c1,'FontSize',12,'FontWeight','normal');
% saveas(gcf, 'saveresult\适配性评估结果.jpg');