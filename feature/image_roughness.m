%����ο�ͼ����ֵ�ֲڶȵĺ���
function imgRough = image_roughness(ImgRef)

[m,n] = size(ImgRef);
Rough_r_total = 0;
Rough_c_total = 0;

%����x����ĻҶȲ���
for i=3:m
    Rough_r_total=Rough_r_total+sum(abs(ImgRef(i,:)-ImgRef(i-2,:)))/n;
end
Rough_x=Rough_r_total/(m-2);

%����y����ĻҶȲ���
for i=3:n
    Rough_c_total=Rough_c_total+sum(abs(ImgRef(:,i)-ImgRef(:,i-2)))/m;
end
Rough_y=Rough_c_total/(n-2);
%����ο�ͼ����ֵ�ֲڶ�
imgRough=(Rough_y+Rough_x)/2;

