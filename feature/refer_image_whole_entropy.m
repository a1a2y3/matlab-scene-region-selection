%����ο�ͼȫͼ��Ϣ�صĺ���
function entropy = refer_image_whole_entropy(ImgRef)

[m_ref,n_ref] = size(ImgRef);

%����ο�ͼȫͼ��Ϣ��
p = imhist(ImgRef(:)); 
% remove zero entries in p 
p(p==0) = []; 
% normalize p so that sum(p) is one. 
p = p ./ numel(ImgRef); 
entropy = -sum(p.*log2(p));

%{
�ڶ��ַ���
temp=zeros(1,256); 

%��ͼ��ĻҶ�ֵ��[0,255]����ͳ�� 
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

%���صĶ��������� 
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

 