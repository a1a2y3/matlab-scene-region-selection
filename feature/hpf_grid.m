function hg= hpf_grid(im, th)
g=fftshift(fft2(im));
[n1,n2]=size(g);
y= zeros(n1,n2);
hx= n2/2+1;
hy= n1/2+1;
for i=1:n1
    for j=1:n2
        d= sqrt((i-hy)^2+(j-hx)^2);
        if d<=th
            h=0;
        else
            h=1;
        end
        y(i,j)=h*g(i,j);
    end
end
E1=ifft2(ifftshift(y));
im2=uint8(real(E1));
htmp= zeros(4,4);
gx= n2/4;
gy= n1/4;
for i=0:3
    for j=0:3
        htmp(i+1,j+1)= sum(sum(im2(i*gy+1:i*gy+gy,j*gx+1:j*gx+gx)));
    end
end
hg= min(htmp(:));