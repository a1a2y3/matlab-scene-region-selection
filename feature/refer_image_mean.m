function meangray = refer_image_mean(ImgRef)
%计算参考图的全图灰度均值
meangray=mean(mean(double(ImgRef)));
 