%计算参考图的零交叉密度的函数
function crossDens = zero_cross_density(ImgRef)

[m_ref,n_ref] = size(ImgRef);

h=fspecial('log');%定义高斯拉普拉斯（LoG）滤波器

temp = 0;
filter_image = imfilter(ImgRef, h);%高斯-拉普拉斯二阶算子运算
%按照定义计算零交叉密度的函数
for m=1:m_ref;
    for n=1:n_ref;
        if filter_image(m,n) == 0;
            temp = temp + 1;
        end
    end
end
temp=temp./(m_ref*n_ref);

crossDens = temp;
 