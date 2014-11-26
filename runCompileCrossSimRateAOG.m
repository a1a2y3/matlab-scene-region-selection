clc;clear;
%%
% include = ' -Id:\opencv246\build\include\ -Id:\opencv246\build\include\opencv\ -Id:\opencv246\build\include\opencv2\';
% libpath = 'd:\opencv246\build\x64\vc10\lib\';
% files = dir([libpath '*.lib']);
% lib = [];
% for i = 1:length(files),   
%     lib = [lib ' ' libpath files(i).name];
% end
% eval(['mex CrossSimRateAOG.cpp -O' include lib]);
%%
im0= imread('match\a1.jpg');
im1= imread('match\s1.jpg');
im0= imresize(im0,1.5);
im1= imresize(im1,1.5);
%%
[h,w]=size(im1);
wReal=h/2;
tic;
s1= CrossMatchRate_BSC0(im0,im1,wReal);
toc;
tic;
im0= imresize(im0,0.5);
im1= imresize(im1,0.5);
s2= CrossSimRateAOG(im0,im1,wReal/2,wReal/2);
toc;
