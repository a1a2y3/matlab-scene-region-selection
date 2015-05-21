function cimg= SCBC3Encoding(im1, gab, pw)
% im: ����ͼ��
% gab: ������, m*n   m=w*w, w width of template, n number of templates
% pw: �ػ����
if nargin<3
    pw=16;
end
[m,n]=size(gab);
w0= sqrt(m);
%% �������
a= [];
for k=1:n
    g0= gab(:,k);
    g0= g0-mean(g0);                % ȥ��ֵ
    g0= g0./(sum(abs(g0))+0.001);   % ��һ��
    g0= reshape(g0,w0,w0);
    C = conv2(im1,g0,'valid');    
    a= [a C];    
end
%% ����
a= abs(a); % ��תһ��
a= (a-min(a(:)))/(max(a(:))-min(a(:)));   % ��һ�����˲����࣬��Ӱ��������
[h,w]=size(C);
im3D= zeros([size(C),n]);
for k=1:n
    im3D(:,:,k)= a(:,w*(k-1)+1:w*(k-1)+w);
end
%% �ػ�
nw= floor(w/pw);
nh= floor(h/pw);
poolIm3D= zeros(nh,nw,n);
for i=0:nh-1
    for j=0:nw-1
        tmpMat= im3D(i*pw+1:i*pw+pw,j*pw+1:j*pw+pw,:); 
        poolIm3D(i+1,j+1,:)= sum(sum(tmpMat,1),2);
    end
end
%% ��ֵ
[~,idx]=sort(poolIm3D,3,'descend');   
% % �����ֵ��Ӧ�ķ���
cimg= uint16(2.^(idx(:,:,1)-1)+2.^(idx(:,:,2)-1)+2.^(idx(:,:,3)-1));