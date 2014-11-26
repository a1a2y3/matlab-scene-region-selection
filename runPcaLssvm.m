clear;
%%
addpath('LSSVMlabv1_8_R2009b_R2011a');
%%
load 'ftr_v.mat';  % mRi      n * 12
load 'sim2.mat';  % mRv      5 * n
%% pca
nPca= 5;

mRv= (sim2(5,:))';
n= size(v,1);
n90= floor(n*0.9);
v= [v(:,1),v(:,2),v(:,5),v(:,6),v(:,8),v(:,9),v(:,10),v(:,11),v(:,12)];

stdr = std(v);
v1 = v./repmat(stdr,size(v,1),1);
[c, s, l]= pca(v1);
rg= 1:n90;
rg_test= n90+1:n;

v1= v(rg,:);
s2= v1./repmat(stdr,size(v1,1),1)*c;
mf= s2(:,1:nPca);
mR= mRv(rg);

v1= v(rg_test,:);
s2= v1./repmat(stdr,size(v1,1),1)*c;
mf_test= s2(:,1:nPca);
mR_test= mRv(rg_test);
%%
%数据归一化参数
v_low= min(mf,[],1);
v_high= max(mf,[],1);
[m,n]= size(mf);
mf= (mf-repmat(v_low, m, 1))./(repmat(v_high, m, 1)-repmat(v_low, m, 1));
%% lssvm
% gam= tunelssvm({mf,mR','f',[],[],'RBF_kernel'},'simplex','rcrossvalidatelssvm',{10,'mae'});
gam = 10; % 1411 %13269.4149;  %29.8;  %10;         
% sig2 = 0.0148; %0.139375143;  %0.0148;  %0.2;   
% svmModel = initlssvm(mf,mR,'f',gam,[1,1],'poly_kernel');
svmModel = initlssvm(mf,mR,'f',gam,[2,2],'poly_kernel');
% svmModel = initlssvm(mf,mR,'f',gam,0.2,'RBF_kernel');
% svmModel = initlssvm(mf,mR,'f',gam,0.2,'lin_kernel');
svmModel = trainlssvm(svmModel);
% plotlssvm(svmModel);
mydata.model   = svmModel;
mydata.pcacoeff= c;
mydata.pcan    = nPca;
mydata.stdr    = stdr;
mydata.v_low= v_low;
mydata.v_high= v_high;
save('models\pcalssvm_.mat','mydata');
%% varify
[m,n]= size(mf_test);
mf_test= (mf_test-repmat(v_low, m, 1))./(repmat(v_high, m, 1)-repmat(v_low, m, 1));

mr2= mR_test;
mr1= simlssvm(svmModel,mf_test);
% mr1= sum(mf,2);
% mse= mean(abs(mr1-mr2'));
% var= var(abs(mr1-mr2'));
% display(mse);
% display(var);
coe= corrcoef(mr1,mr2);
disp(coe(1,2));
[~,ix1] = sort(mr1,'descend');
% [~,ix1] = sort(mf_test(:,1),'descend');
[~,ix2] = sort(mr2,'descend');
topn=50;
cnt= size(intersect(ix1(1:50),ix2(1:topn)),1);
disp(cnt/topn);