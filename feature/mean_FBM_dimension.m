%����ƽ��FBMά���ĺ���
function FBM_dimension = mean_FBM_dimension(ImgRef)

[m_ref,n_ref] = size(ImgRef);

%ȡ��һ��delta_ij���õ�һ��������
%delta��ʼֵ
delta_i = 2;
delta_j = 2;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%����ͼ���С���򣬹�(m_ref-delta_i)*(n_ref-delta_j)������
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%����ҶȲ�ľ�ֵ
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%��С����ֱ����ϵ�x������
y1 = log(mean_derivative_gray) - log(complexity);
x1 = log(delta_ij);

%ȡ�ڶ���delta_ij���õڶ���������
%delta��ʼֵ
delta_i = 5;
delta_j = 6;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%����ͼ���С���򣬹�(m_ref-delta_i)*(n_ref-delta_j)������
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%����ҶȲ�ľ�ֵ
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%��С����ֱ����ϵ�x������
y2 = log(mean_derivative_gray) - log(complexity);
x2 = log(delta_ij);

%ȡ������delta_ij���õ�����������
%delta��ʼֵ
delta_i = 8;
delta_j = 8;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%����ͼ���С���򣬹�(m_ref-delta_i)*(n_ref-delta_j)������
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%����ҶȲ�ľ�ֵ
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%��С����ֱ����ϵ�x������
y3 = log(mean_derivative_gray) - log(complexity);
x3 = log(delta_ij);

%ȡ���ĸ�delta_ij���õ�����������
%delta��ʼֵ
delta_i = 12;
delta_j = 13;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%����ͼ���С���򣬹�(m_ref-delta_i)*(n_ref-delta_j)������
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%����ҶȲ�ľ�ֵ
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%��С����ֱ����ϵ�x������
y4 = log(mean_derivative_gray) - log(complexity);
x4 = log(delta_ij);

%���ն������FBMά��
x = [x1 x2 x3 x4];
y = [y1 y2 y3 y4];
p = polyfit(x,y,1);

FBM_dimension = 3-p(1);















