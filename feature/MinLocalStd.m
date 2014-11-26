function mlstd=MinLocalStd(ImgRef)
% 单位面积图像边缘密度的均值，标准差
% 计算单位面积时，行列都20等份
[m,n]=size(ImgRef);
%设置行列分割数
blockNum_R=5;
blockNum_C=5;
%计算每块的点数
Num_R=floor(m/blockNum_R);
Num_C=floor(n/blockNum_C);

localstd=zeros(blockNum_R,blockNum_C);
for i=1:blockNum_R
    for j=1:blockNum_C
        lstd= std2(double(ImgRef(...
            (i-1)*Num_R+1:i*Num_R,(j-1)*Num_C+1:j*Num_C)));
        localstd(i,j)= lstd;
    end
end
mlstd= min(localstd(:));