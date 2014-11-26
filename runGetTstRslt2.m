clear;clc;
close all;
%im1  ‰»Î¥ÛÕº
%im2  ‰»Î–°Õº
im1o=imread('E:\lizhuang\“Ï‘¥∆•≈‰≤‚ ‘Õº\1\1.bmp');
im2o=imread('E:\lizhuang\“Ï‘¥∆•≈‰≤‚ ‘Õº\1\2.bmp');
% im2o= im1o(101:300,101:300);
im1= im1o(:,:,1);
im2= im2o(:,:,1);
% pooling width
w=4;
tic;
% sparse coding template binary coding
mtd1= 'SCBC3';
display([mtd1,' running']);
[x1,y1,imrslt1]=SCBC3_Match(im1,im2,w);
toc;tic;
% gabor template binary coding
mtd2= 'SCBC3_3D';
display([mtd2,' running']);
[x2,y2,imrslt2]=SCBC3_3D_Match(im1,im2,w);
toc;tic;
% harr like template binary coding
mtd3= 'HSC';
display([mtd3,' running']);
[x3,y3,imrslt3]=HSC_Match(im1,im2,w);
toc;
% save('saveresult\imrslt2.mat', 'imrslt1', 'imrslt2', 'imrslt3');
%% plot
[h1,w1]=size(im1);
[h2,w2]=size(im2);
[h3,w3]=size(imrslt1);
imCom= uint8(zeros(max(h1,h2),w1+5+w2+(5+w3)*3));
imCom(1:h1,1:w1)= im1;
imCom(1:h2,w1+6:w1+5+w2)= im2;
imCom(1:h3,w1+w2+11:w1+w2+10+w3)= uint8(imrslt1*255);
imCom(1:h3,w1+w2+16+w3:w1+w2+15+w3*2)= uint8(imrslt2*255);
imCom(1:h3,w1+w2+21+w3*2:w1+w2+20+w3*3)= uint8(imrslt3*255);
figure(1);
imshow(imCom);
lineR= 60;
% add cross on right small image
line([w2/2+w1+5+lineR,w2/2+w1+5-lineR], [h2/2,h2/2], 'Color','w','LineWidth',2,'LineStyle','-');
line([w2/2+w1+5,w2/2+w1+5], [h2/2+lineR,h2/2-lineR], 'Color','w','LineWidth',2,'LineStyle','-');
% add result on left large image
c1='y';c2='m';c3='c';
s1='-';s2='--';s3=':';
d1=0;d2=10;d3=20;
x=x1;y=y1;
line([x+w2/2-lineR,x+w2/2+lineR], [y+h2/2,y+h2/2], 'Color',c1,'LineWidth',2,'LineStyle',s1);
line([x+w2/2,x+w2/2], [y+h2/2-lineR,y+h2/2+lineR], 'Color',c1,'LineWidth',2,'LineStyle',s1);
rectangle('Position',[x+d1,y+d1,w2-d1*2,h2-d1*2],'LineWidth',2,'EdgeColor',c1,'LineStyle',s1);
x=x2;y=y2;
line([x+w2/2-lineR,x+w2/2+lineR], [y+h2/2,y+h2/2], 'Color',c2,'LineWidth',2,'LineStyle',s2);
line([x+w2/2,x+w2/2], [y+h2/2-lineR,y+h2/2+lineR], 'Color',c2,'LineWidth',2,'LineStyle',s2);
rectangle('Position',[x+d2,y+d2,w2-d2*2,h2-d2*2],'LineWidth',2,'EdgeColor',c2,'LineStyle',s2);
x=x3;y=y3;
line([x+w2/2-lineR,x+w2/2+lineR], [y+h2/2,y+h2/2], 'Color',c3,'LineWidth',2,'LineStyle',s3);
line([x+w2/2,x+w2/2], [y+h2/2-lineR,y+h2/2+lineR], 'Color',c3,'LineWidth',2,'LineStyle',s3);
rectangle('Position',[x+d3,y+d3,w2-d3*2,h2-d3*2],'LineWidth',2,'EdgeColor',c3,'LineStyle',s3);
x=10;y=20;tt=50;
line([x,x+tt],[y,y], 'Color',c1,'LineWidth',2,'LineStyle',s1);
text(x+tt,y,mtd1, 'Color',c1,'FontSize',18,'FontWeight','bold');
line([x,x+tt],[y+24,y+24], 'Color',c2,'LineWidth',2,'LineStyle',s2);
text(x+tt,y+24,mtd2, 'Color',c2,'FontSize',18,'FontWeight','bold');
line([x,x+tt],[y+48,y+48], 'Color',c3,'LineWidth',2,'LineStyle',s3);
text(x+tt,y+48,mtd3, 'Color',c3,'FontSize',18,'FontWeight','bold');

saveas(gcf,'123.bmp');
%%
% [h0,w0]=size(imrslt1);
% crm= (zeros(h0,w0*3+10));
% crm(:,1:w0)= imrslt1;
% crm(:,w0+6:w0*2+5)= imrslt2;
% crm(:,w0*2+11:w0*3+10)= imrslt3;
% figure,imshow(crm);
% figure;
% subplot(1,3,1);imshow(imrslt1);title(mtd1);
% subplot(1,3,2);imshow(imrslt2);title(mtd2);
% subplot(1,3,3);imshow(imrslt3);title(mtd3);
%%
% imwrite(im2o,'saveresult\im2.jpg');
% imrslt= imrslt1;
% imwrite((imrslt-min(imrslt(:)))/(max(imrslt(:))-min(imrslt(:))),'saveresult\imrslt_SCBC_Match.jpg');
% imrslt= imrslt2;
% imwrite((imrslt-min(imrslt(:)))/(max(imrslt(:))-min(imrslt(:))),'saveresult\imrslt_GBC_Match.jpg');
% imrslt= imrslt3;
% imwrite((imrslt-min(imrslt(:)))/(max(imrslt(:))-min(imrslt(:))),'saveresult\imrslt_NGF_Match.jpg');
