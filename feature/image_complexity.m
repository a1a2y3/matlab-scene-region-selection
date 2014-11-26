%����ο�ͼ��ͼ���Ӷȵĺ���
function complexity = image_complexity(ImgRef)

[m_ref,n_ref] = size(ImgRef);
%����X����һάƫ����Y����һάƫ����XY���������άƫ���ı�����ʼ��
X_derivative = 0.0;
Y_derivative = 0.0;
XY_derivative = 0.0;

%����ͼ���С���򣬹�(m_ref-4)*(n_ref-4)������
for m=3:m_ref-2;
    for n=3:n_ref-2;

        %����X����һάƫ��
        X_derivative = X_derivative + double((ImgRef(m,n) - ImgRef(m-2,n)));
        %����Y����һάƫ��
        Y_derivative = Y_derivative + double((ImgRef(m,n) - ImgRef(m,n-2)));
        %����XY�����άƫ���������ĸ�����
        XY_derivative = XY_derivative + double(((ImgRef(m,n+2) - ImgRef(m,n-2)) + (ImgRef(m+2,n) - ImgRef(m-2,n))) / 4);

    end
end

%���������ͼ���Ӷ�
complexity = (X_derivative + Y_derivative)/XY_derivative;