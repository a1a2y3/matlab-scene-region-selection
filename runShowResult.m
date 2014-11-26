clear all;
close all;
clc;
imgNo= 'p001';
imgName= ['images\' imgNo '.jpg'];
im= imread(imgName);
if size(im,3)>1
    im= rgb2gray(im);
end
load(['images\' imgNo '_v15_200_100.mat'],'v15');
[~,IX] = sort(v15(:,1),'descend');
figure; imshow(im);
for i=1:200
     rectangle('Position',...
        [v15(IX(i),3),v15(IX(i),2),v15(IX(i),5),v15(IX(i),5)],...
        'EdgeColor','r');  %rectangle('Position',[x,y,w,h])
end

writeName='result\\%04d.jpg';
figure; imshow(im);
[~,IX2] = sort(v15(:,4),'ascend');
for i=1:50
    imgRef= im(v15(IX2(i),2):v15(IX2(i),2)+v15(IX(i),5)-1,...
        v15(IX2(i),3):v15(IX2(i),3)+v15(IX(i),5)-1);
    refName= sprintf(writeName, i);
    imwrite(imgRef, refName);
    rectangle('Position',...
        [v15(IX2(i),3),v15(IX2(i),2),v15(IX(i),5),v15(IX(i),5)],...
        'EdgeColor','r');  %rectangle('Position',[x,y,w,h])
end