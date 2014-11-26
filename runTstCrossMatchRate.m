im2=    imread('im2.jpg');
im3=    imread('im3.jpg');
wReal= 100;
tic;
[MRate,rn,tn]=CrossMatchRate_BSC0(im3,im2,wReal);
MRate
toc;
