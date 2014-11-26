function cimg= SCBC3Encoding(im1, gab, pw)
% im: 输入图像
% gab: 编码器, m*n   m=w*w, w width of template, n number of templates
% pw: 池化宽度
if nargin<3
    pw=16;
end
[m,n]=size(gab);
w0= sqrt(m);
%% 卷积编码
a= [];
for k=1:n
    g0= gab(:,k);
    g0= g0-mean(g0);                % 去均值
    g0= g0./(sum(abs(g0))+0.001);   % 归一化
    g0= reshape(g0,w0,w0);
    C = conv2(im1,g0,'valid');    
    a= [a C];    
end
%% 处理
a= abs(a); % 翻转一致
a= (a-min(a(:)))/(max(a(:))-min(a(:)));   % 归一化，此步多余，不影响排序结果
[h,w]=size(C);
im3D= zeros([size(C),n]);
for k=1:n
    im3D(:,:,k)= a(:,w*(k-1)+1:w*(k-1)+w);
end
%% 池化
nw= floor(w/pw);
nh= floor(h/pw);
poolIm3D= zeros(nh,nw,n);
for i=0:nh-1
    for j=0:nw-1
        tmpMat= im3D(i*pw+1:i*pw+pw,j*pw+1:j*pw+pw,:); 
        poolIm3D(i+1,j+1,:)= sum(sum(tmpMat,1),2);
    end
end
%% 二值
[~,idx]=sort(poolIm3D,3,'descend');   
% % 最大三值对应的方向
cimg= uint16(2.^(idx(:,:,1)-1)+2.^(idx(:,:,2)-1)+2.^(idx(:,:,3)-1));