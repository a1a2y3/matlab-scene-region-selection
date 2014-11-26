%计算参考图绝对值粗糙度的函数
function imgRough = image_roughness(ImgRef)

[m,n] = size(ImgRef);
Rough_r_total = 0;
Rough_c_total = 0;

%计算x方向的灰度差异
for i=3:m
    Rough_r_total=Rough_r_total+sum(abs(ImgRef(i,:)-ImgRef(i-2,:)))/n;
end
Rough_x=Rough_r_total/(m-2);

%计算y方向的灰度差异
for i=3:n
    Rough_c_total=Rough_c_total+sum(abs(ImgRef(:,i)-ImgRef(:,i-2)))/m;
end
Rough_y=Rough_c_total/(n-2);
%计算参考图绝对值粗糙度
imgRough=(Rough_y+Rough_x)/2;

