clear;
close all;
%%
load '..\data\ftr_v.mat';  % mRi      n * 12
load '..\data\ftr_f13.mat';% f13
load '..\data\sim2.mat';  % mRv      5 * n
%% v, mR
v= [v, f13];
mR= sim2(5,:);
mR= mR';
n= size(v,1);
%%
for i=1:size(v,2)
    figure;
    set(gcf,'color','white');
    plot(v(:,i)',mR,'*');
    title(['F',num2str(i)]);
    saveas(gcf,['saveresult\ftr-',num2str(i),'.jpg']);
end

v1= v;
c1= zeros(size(v1,2),1);
for i=1:size(v1,2)
    vf= v1(:,i);
    coe= corrcoef(vf,mR);
    c1(i)= coe(1,2);   
end
display(c1');
%%plot mean & var HOG 
% load 'Feature_mvHOG.mat'; % mean & var of HOG 896*2
% vHOG= mvHOG(1:896,:);
% figure;
% plot(vHOG(:,1),mR,'*');
% title('meanHOG');
% figure;
% plot(vHOG(:,2),mR,'*');
% title('varHOG');