%����ο�ͼ���㽻���ܶȵĺ���
function crossDens = zero_cross_density(ImgRef)

[m_ref,n_ref] = size(ImgRef);

h=fspecial('log');%�����˹������˹��LoG���˲���

temp = 0;
filter_image = imfilter(ImgRef, h);%��˹-������˹������������
%���ն�������㽻���ܶȵĺ���
for m=1:m_ref;
    for n=1:n_ref;
        if filter_image(m,n) == 0;
            temp = temp + 1;
        end
    end
end
temp=temp./(m_ref*n_ref);

crossDens = temp;
 