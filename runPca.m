clear;
close all;
%%
%%
load 'ftr_v.mat';  % mRi      n * 12
load 'sim2.mat';  % mRv      5 * n
%% v, mR
v= [v(:,1),v(:,2),v(:,5),v(:,6),v(:,8),v(:,9),v(:,10),v(:,11),v(:,12)];
mR= sim2(5,:);
mR= mR';
n= size(v,1);
stdr = std(v);
v1 = v./repmat(stdr,size(v,1),1);
[c, s, l]= pca(v1);

%%
for i=1:size(v,2)
    figure;
    plot(s(:,i)',mR,'*');
    title(['s',num2str(i)]);
    saveas(gcf,['saveresult\ftr-pca-',num2str(i),'.jpg']);
end
c1= zeros(size(v1,2),1);
for i=1:size(v1,2)
    vf= v1(:,i);
    coe= corrcoef(vf,mR);
    c1(i)= coe(1,2);   
end
display(c1');
v1= s;
c1= zeros(size(v1,2),1);
for i=1:size(v1,2)
    vf= v1(:,i);
    coe= corrcoef(vf,mR);
    c1(i)= coe(1,2);   
end
display(c1');