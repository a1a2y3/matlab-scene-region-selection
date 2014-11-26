%计算参考图绝对值粗糙度的函数
function mG = image_meanGradientIntensity(ImgRef)

[m,n] = size(ImgRef);
Rough_r_total = 0;
Rough_c_total = 0;
Gx= zeros(m,n);
Gy= zeros(m,n);
%计算x方向的灰度差异
for i=2:m
    Gx(i,:)=ImgRef(i,:)-ImgRef(i-1,:);
end
%计算y方向的灰度差异
for i=2:n
    Gy(:,i)=ImgRef(:,i)-ImgRef(:,i-1);
end
Gx= Gx(:);
Gy= Gy(:);
mG= sum(sqrt(Gx.*Gx+Gy.*Gy))/((m-1)*(n-1));