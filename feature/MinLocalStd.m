function mlstd=MinLocalStd(ImgRef)
% ��λ���ͼ���Ե�ܶȵľ�ֵ����׼��
% ���㵥λ���ʱ�����ж�20�ȷ�
[m,n]=size(ImgRef);
%�������зָ���
blockNum_R=5;
blockNum_C=5;
%����ÿ��ĵ���
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