%计算参考图的全图标准差的函数
function var = regionVar(Im)
h= zeros(21,21)+1/441;
Im= im2double(Im);
eim= conv2(Im,h,'same');
% eim= filter2(h,Im,'same');
Im= Im.*Im;
Im= conv2(Im,h,'same');
% Im= filter2(h,Im,'same');
Im= Im-eim.*eim;
var= sqrt(Im);

 