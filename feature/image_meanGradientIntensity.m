%����ο�ͼ����ֵ�ֲڶȵĺ���
function mG = image_meanGradientIntensity(ImgRef)

[m,n] = size(ImgRef);
Rough_r_total = 0;
Rough_c_total = 0;
Gx= zeros(m,n);
Gy= zeros(m,n);
%����x����ĻҶȲ���
for i=2:m
    Gx(i,:)=ImgRef(i,:)-ImgRef(i-1,:);
end
%����y����ĻҶȲ���
for i=2:n
    Gy(:,i)=ImgRef(:,i)-ImgRef(:,i-1);
end
Gx= Gx(:);
Gy= Gy(:);
mG= sum(sqrt(Gx.*Gx+Gy.*Gy))/((m-1)*(n-1));