include = ' -Id:\opencv2410\build\include\';
libpath = 'd:\opencv2410\build\x64\vc12\lib\';
files = dir([libpath '*.lib']);

lib = [];
for i = 1:length(files),   
    lib = [lib ' ' libpath files(i).name];
end

% eval(['mex getSimMapNCC.cpp -O' include lib]);
eval(['mex getSimMapNGF.cpp -O' include lib]);
% eval(['mex getSimMapAOG.cpp -O' include lib]);

% evaluate
im0= imread('1.bmp');
if(size(im0,3)>1)
    im0= im0(:,:,1);
end
h= fspecial('average',5);
im0 = imfilter(im0,h);
im1= im0(101:200,201:300);
tic;
% imrslt= getSimMapNCC(im0,im1);
imrslt= getSimMapNGF(im0,im1);
% imrslt= getSimMapAOG(im0,im1);
toc;
imrslt= (imrslt-min(imrslt(:)))/(max(imrslt(:))-min(imrslt(:)));
imshow(imrslt);
