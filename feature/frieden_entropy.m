%计算frieden灰度熵的函数
function entropy = frieden_entropy(ImgRef)
s= sum(ImgRef(:)); 
p= double(ImgRef)/s;
e= p.*exp(1-p);
entropy= sum(e(:));
