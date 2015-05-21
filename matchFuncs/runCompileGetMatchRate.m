%  1 NCC
%  2 AOG
%  3 NGF
%  4 BSC
%  5 EDGE
%  6 SURF
% im0 中取窗口，在im1中搜索

include = ' -Id:\opencv2410\build\include\';
libpath = 'd:\opencv2410\build\x64\vc12\lib\';
files = dir([libpath '*.lib']);

lib = [];
for i = 1:length(files),   
    lib = [lib ' ' libpath files(i).name];
end

% eval(['mex getMatchRateNCC.cpp -O' include lib]);
% eval(['mex getMatchRateAOG.cpp -O' include lib]);
% eval(['mex getMatchRateEDGE.cpp -O' include lib]);
% eval(['mex getMatchRateSURF.cpp -O' include lib]);

% evaluate
im0= imread('1.bmp');
% im0= imresize(im0,0.5);
if(size(im0,3)>1)
    im0= im0(:,:,1);
end
im1= im0;

tic;
% [pp, map]= getMatchRateNCC(im0,im1,size(im0,1)/2,7,1);
% [pp, map]= getMatchRateAOG(im0,im1,size(im0,1)/2,7,4);
% [pp, map]= getMatchRateEDGE(im0,im1,size(im0,1)/2,7,1);
[pp, map]= getMatchRateSURF(im0,im1,size(im0,1)/2,8,4);
% [pp,map]= getMatchRateBSC(im0,im1,size(im0,1)/2,5,4);
toc;
imshow(map);
disp(pp);