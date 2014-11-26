%计算参考图的图像复杂度的函数
function pc = phase_complexity(ImgRef)

[m_ref,n_ref] = size(ImgRef);
hx= n_ref/2+1;
hy= m_ref/2+1;
ims= fftshift(abs(fft2(ImgRef)));
s1= sum(ims(:));
s2= sum(sum(ims(hy-95:hy+95, hx-95:hx+95)));
s3= sum(sum(ims(hy-2:hy+2, hx-2:hx+2)));
pc= (s2-s3)/(s1+0.000001);