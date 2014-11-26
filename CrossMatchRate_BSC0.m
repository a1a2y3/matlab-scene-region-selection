function [MRate,rn,tn]=CrossMatchRate_BSC0(im1o,im2o,Rw,pw)
% im1o取窗口 在 im2o 里进行匹配
im1o= im2double(im1o);
im2o= im2double(im2o);
% pool width 
% pool width 
if nargin<4   
    pw=4; 
end
cw=7; 
load('bsds500_7x7_first_25_spa1','dic_first');
gab= dic_first.dic(:,1:16);  % 只用前16 模板
im1= SCBC3Encoding(im1o-0.5, gab, pw);
im2= SCBC3Encoding(im2o-0.5, gab, pw);
[h1,w1]=size(im1);
[h2,w2]=size(im2);
if h1~=h2 || w1~=w2
    err('CrossMatchRate_BSC（） 输入图像尺寸要一致');
end
Rw= round(Rw/pw);
sh= h1-Rw+1;
sw= w1-Rw+1;
rn=0;
tn=0;
for i0=1:2:sh
    for j0=1:2:sw
        imrslt= zeros(sh,sw);
        rimg= im1(i0:i0+Rw-1,j0:j0+Rw-1);
        for i=1:sh
            for j=1:sw
                tmp= uint16(zeros(Rw,Rw));
                cimg= bitand(rimg,im2(i:i+Rw-1,j:j+Rw-1));
                for k=0:15            % 16 templates
                    tmp=tmp+bitand(bitshift(cimg,-k),1);
                end
%                 tmp=tmp+bitand(bitshift(cimg,0),1);
%                 tmp=tmp+bitand(bitshift(cimg,-1),1);
%                 tmp=tmp+bitand(bitshift(cimg,-2),1);
%                 tmp=tmp+bitand(bitshift(cimg,-3),1);
%                 
%                 tmp=tmp+bitand(bitshift(cimg,-4),1);
%                 tmp=tmp+bitand(bitshift(cimg,-5),1);
%                 tmp=tmp+bitand(bitshift(cimg,-6),1);
%                 tmp=tmp+bitand(bitshift(cimg,-7),1);
%                 
%                 tmp=tmp+bitand(bitshift(cimg,-8),1);
%                 tmp=tmp+bitand(bitshift(cimg,-9),1);
%                 tmp=tmp+bitand(bitshift(cimg,-10),1);
%                 tmp=tmp+bitand(bitshift(cimg,-11),1);
%                 
%                 tmp=tmp+bitand(bitshift(cimg,-12),1);
%                 tmp=tmp+bitand(bitshift(cimg,-13),1);
%                 tmp=tmp+bitand(bitshift(cimg,-14),1);
%                 tmp=tmp+bitand(bitshift(cimg,-15),1);
                imrslt(i,j)= sum(tmp(:));
            end
        end
        [y,x]=find(imrslt==max(imrslt(:)),1);
        if((y-i0)*(y-i0)+(x-j0)*(x-j0)<3)
            rn= rn+1;
        end
        tn= tn+1;
    end
end
MRate= rn/tn;