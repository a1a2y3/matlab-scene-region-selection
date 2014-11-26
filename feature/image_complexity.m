%计算参考图的图像复杂度的函数
function complexity = image_complexity(ImgRef)

[m_ref,n_ref] = size(ImgRef);
%计算X方向一维偏导、Y方向一维偏导、XY两个方向二维偏导的变量初始化
X_derivative = 0.0;
Y_derivative = 0.0;
XY_derivative = 0.0;

%遍历图像的小邻域，共(m_ref-4)*(n_ref-4)个邻域
for m=3:m_ref-2;
    for n=3:n_ref-2;

        %计算X方向一维偏导
        X_derivative = X_derivative + double((ImgRef(m,n) - ImgRef(m-2,n)));
        %计算Y方向一维偏导
        Y_derivative = Y_derivative + double((ImgRef(m,n) - ImgRef(m,n-2)));
        %计算XY方向二维偏导，计算四个方向
        XY_derivative = XY_derivative + double(((ImgRef(m,n+2) - ImgRef(m,n-2)) + (ImgRef(m+2,n) - ImgRef(m-2,n))) / 4);

    end
end

%按定义计算图像复杂度
complexity = (X_derivative + Y_derivative)/XY_derivative;