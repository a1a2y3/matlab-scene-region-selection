clear;
addpath('../LSSVMlabv1_8_R2009b_R2011a');
%%
load '../data/ftr_v.mat';  % mRi      n * 12
load '../data/sim2.mat';  % mRv      5 * n
%% v, mR
mRv= (sim2(5,:))';
v= [v(:,1),v(:,2),v(:,5),v(:,6),v(:,8),v(:,9),v(:,10),v(:,11),v(:,12)];      
%%
mf= v;
mR= mRv;
%%
%数据归一化参数
v_low= min(v,[],1);
v_high= max(v,[],1);
[m,n]= size(v);
mf= (mf-repmat(v_low, m, 1))./(repmat(v_high, m, 1)-repmat(v_low, m, 1));
%% lssvm
gam = 10; % 1411 %13269.4149;  %29.8;  %10;   
svmModel = initlssvm(v,mRv,'f',gam,0.2,'lin_kernel');
svmModel = trainlssvm(svmModel);
plotlssvm(svmModel);
mydata.model= svmModel;
mydata.v_low= v_low;
mydata.v_high= v_high;
save('..\models\lssvm_.mat','mydata');