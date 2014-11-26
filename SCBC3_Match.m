function [x,y,imrslt]=SCBC3_Match(im1,im2,pw,cw)
im1o= im2double(im1);
im2o= im2double(im2);
% pool width 
if nargin<3   
    pw=4; 
end
% coding template width
if nargin<4   
    cw=7; 
end

load('bsds500_7x7_first_25_spa1.mat');
gab= dic_first.dic(:,1:16);  % 只用前16 模板

% load 'tmpPatch.mat';
% gab=W1';
im1= SCBC3Encoding(im1o-0.5, gab, pw);
im2= SCBC3Encoding(im2o-0.5, gab, pw);
[h1,w1]=size(im1);
[h2,w2]=size(im2);
sh= h1-h2+1;
sw= w1-w2+1;
imrslt= zeros(sh,sw);

for i=1:sh
    for j=1:sw
        tmp= uint16(zeros(size(im2)));
        cimg= bitand(im2,im1(i:i+h2-1,j:j+w2-1));
        for k=0:15            % 16 templates
            tmp=tmp+ bitand(bitshift(cimg,-k),1);
        end
        imrslt(i,j)= sum(tmp(:));
    end
end
[y,x]=find(imrslt==max(imrslt(:)),1);
y=pw*y;
x=pw*x;
imrslt= (imrslt-min(imrslt(:)))/(max(imrslt(:))-min(imrslt(:)));