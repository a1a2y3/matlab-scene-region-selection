clear;
%%
load '..\data\ftr_v.mat';  % mRi      n * 12
load '..\data\ftr_f13.mat';% f13
load '..\data\sim2.mat';  % mRv      5 * n
load '..\data\vlayer1-5083';% vLayer1
mR= sim2(3,:);
mR= mR';
mf= [v(:,1),v(:,2),v(:,5),v(:,6),v(:,8),v(:,9),v(:,10),v(:,11),v(:,12)];
% lssvm predict
addpath('../LSSVMlabv1_8_R2009b_R2011a');
load('..\models\lssvm_.mat');
disp(['lssvm predicting layer2']);
mf= (mf-repmat(mydata.v_low, size(mf,1), 1))./...
    (repmat(mydata.v_high, size(mf,1), 1)-repmat(mydata.v_low, size(mf,1), 1));
mR_svm = simlssvm(mydata.model,mf);
v1= [v(:,1),v(:,2),-v(:,5),v(:,6),v(:,8),-v(:,9),v(:,10),v(:,11),v(:,12)...
    , vLayer1, vLayer1(:,1).*vLayer1(:,2),mR_svm];

[m,n]= size(v1);

c1= zeros(size(v1,2),1);
for i=1:size(v1,2)
    vf= v1(:,i);
    coe= corrcoef(vf,mR);
    c1(i)= coe(1,2);   
end
display(c1);

v2= v1;
[~,ix2] = sort(mR,'descend');
c2= zeros(size(v,2),1);
topn= 1000;
mr_n= 100;
% 根据每个特征选取前topn匹配概率与实际前topn匹配概率基准图标号重合数
for i=1:size(v1,2)
    [~,v2(:,i)] = sort(v1(:,i),'descend');
    c2(i)= size(intersect(v2(1:topn,i),ix2(1:mr_n)),1);
end
c2= c2/mr_n;
disp(c2);
% 计算实际前topn匹配概率基准图在全部特征前topn中出现的数目
v3= v2(1:topn,:);
v3= unique( v3(:) );% 去除冗余，计算全部特征共选取多少不重复的基准图
cnt1= size(intersect(v3, ix2(1:mr_n)),1);  
disp(size(v3,1));
disp(cnt1/mr_n);