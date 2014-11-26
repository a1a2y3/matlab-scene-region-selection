%计算参考图全图信息熵的函数
function entropy = refer_image_whole_entropy(ImgRef)

[m_ref,n_ref] = size(ImgRef);

%计算参考图全图信息熵
p = imhist(ImgRef(:)); 
% remove zero entries in p 
p(p==0) = []; 
% normalize p so that sum(p) is one. 
p = p ./ numel(ImgRef); 
entropy = -sum(p.*log2(p));

%{
第二种方法
temp=zeros(1,256); 

%对图像的灰度值在[0,255]上做统计 
for m=1:m_ref; 
for n=1:n_ref; 

if ImgRef(m,n)==0; 
i=1; 
else 
i=ImgRef(m,n); 
end 
temp(i)=temp(i)+1; 
end 
end 
temp=temp./(m_ref*n_ref); 

%由熵的定义做计算 
result=0; 

for i=1:length(temp) 
if temp(i)==0; 
result=result; 
else 
result=result-temp(i)*log2(temp(i)); 
end 
end 
result 
%}

 