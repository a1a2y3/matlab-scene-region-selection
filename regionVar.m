%计算参考图的全图标准差的函数
function var = regionVar(Im)

im= im2double(Im);
im2= im.*im;
h= zeros(21,21)+1/441;
eim= conv2(im,h,'same');
var= conv2(im2,h,'same')-eim.*eim;
var= sqrt(var);

 