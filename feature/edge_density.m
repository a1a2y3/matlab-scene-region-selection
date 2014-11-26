function [mean_LocalEdge,std_LocalEdge]=edge_density(ImgRef)
% ��λ���ͼ���Ե�ܶȵľ�ֵ����׼��
% ���㵥λ���ʱ�����ж�20�ȷ�
[m,n]=size(ImgRef);
%�������зָ���
blockNum_R=20;
blockNum_C=20;
%����ÿ��ĵ���
Num_R=floor(m/blockNum_R);
Num_C=floor(n/blockNum_C);

ImgEdge=edge(ImgRef,'canny');
LocalDens= zeros(blockNum_R, blockNum_C);
for i=1:blockNum_R
    for j=1:blockNum_C
        LocalImgEdge=ImgEdge((i-1)*Num_R+1:i*Num_R,(j-1)*Num_C+1:j*Num_C);
        LocalDens(i,j)=sum(LocalImgEdge(:))/Num_R/Num_C;
    end
end
mean_LocalEdge=mean(LocalDens(:));
std_LocalEdge=std(LocalDens(:));
% EdgeDens=mean_LocalEdge+std_LocalEdge;
