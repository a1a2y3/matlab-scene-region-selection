%计算平均FBM维数的函数
function FBM_dimension = mean_FBM_dimension(ImgRef)

[m_ref,n_ref] = size(ImgRef);

%取第一个delta_ij，得第一组样本点
%delta初始值
delta_i = 2;
delta_j = 2;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%遍历图像的小邻域，共(m_ref-delta_i)*(n_ref-delta_j)个邻域
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%计算灰度差的均值
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%最小二乘直线拟合的x轴向量
y1 = log(mean_derivative_gray) - log(complexity);
x1 = log(delta_ij);

%取第二个delta_ij，得第二组样本点
%delta初始值
delta_i = 5;
delta_j = 6;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%遍历图像的小邻域，共(m_ref-delta_i)*(n_ref-delta_j)个邻域
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%计算灰度差的均值
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%最小二乘直线拟合的x轴向量
y2 = log(mean_derivative_gray) - log(complexity);
x2 = log(delta_ij);

%取第三个delta_ij，得第三组样本点
%delta初始值
delta_i = 8;
delta_j = 8;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%遍历图像的小邻域，共(m_ref-delta_i)*(n_ref-delta_j)个邻域
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%计算灰度差的均值
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%最小二乘直线拟合的x轴向量
y3 = log(mean_derivative_gray) - log(complexity);
x3 = log(delta_ij);

%取第四个delta_ij，得第四组样本点
%delta初始值
delta_i = 12;
delta_j = 13;
delta_ij = sqrt(delta_i^2 + delta_j^2);

rotal_derivative_gray = 0;

%遍历图像的小邻域，共(m_ref-delta_i)*(n_ref-delta_j)个邻域
for m=1:m_ref-delta_i; 
for n=1:n_ref-delta_j; 
rotal_derivative_gray = rotal_derivative_gray + double(ImgRef(m+delta_i,n+delta_j) - ImgRef(m,n));
end
end
%计算灰度差的均值
mean_derivative_gray = rotal_derivative_gray/((m_ref-delta_i)*(n_ref-delta_j));

complexity = image_complexity(ImgRef);

%最小二乘直线拟合的x轴向量
y4 = log(mean_derivative_gray) - log(complexity);
x4 = log(delta_ij);

%按照定义计算FBM维数
x = [x1 x2 x3 x4];
y = [y1 y2 y3 y4];
p = polyfit(x,y,1);

FBM_dimension = 3-p(1);















