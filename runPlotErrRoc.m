clear;
close all;
imgType= 'vis-sar'; % 'vis-ir'
load(['..\data\sim-',imgType,'-B.mat']);
sim0=sim';
sim1= repmat(sim0,5,1);
load(['..\data\sim-',imgType,'-B-5.mat']);
sim5=sim;
clear sim;
ccor= zeros(6,1);
tt= zeros(size(sim0))+mean(sim0);
d= sim5-sim1;
diff= sum(d.*d,2);
dtt= sum((sim0-tt).*(sim0-tt));
diff= [diff;dtt];
coe= corrcoef(tt,sim0);
ccor(6)= coe(1,2);   

%% plot error curve
iColor= ['y','m','c','r','g','b','w','k'];
[~,idx]= sort(sim0);
figure;
set(gcf,'color','white');
hold on;
plot(sim0(idx),'Color',iColor(8));
for i=1:5
    a= sim5(i,:);
    coe= corrcoef(a,sim0);
    ccor(i)= coe(1,2);
%     [~,idx]= sort(a);
    plot(a(idx),'Color',iColor(i+1));
end
xlabel('image number');
ylabel('predict error');
legend('sim','class 1','class 2','class 3','class 4','class 5');
figure;
set(gcf,'color','white');
hold on;
for i=1:5
    a= sim5(i,:);
    a= a-sim0;
    plot(a,'Color',iColor(i+1));  % a(:,1201:1450) for vis-ir
end
xlabel('image number');
ylabel('predict error');
legend('class 1','class 2','class 3','class 4','class 5');
saveas(gcf,['..\saveresult\',imgType,'-self-mul-err.emf']);
n1=sum(abs(sim5-sim1)<0.1,2)
n2=sum(abs(sim5-sim1)<0.2,2);
n3=sum(abs(sim5-sim1)<0.3,2);
n4= mean(abs(sim5-sim1),2)  %误差强度均值
n5= (n1/size(sim1,2))       %阈界内点比
th=0.9;
n6= sum((sim1>=th) & (sim5>=th),2)./sum(sim1>=th,2) % 同为真的比例
n7= sum((sim1<th) & (sim5<th),2)./sum(sim1<th,2)   % 同为假的比例
%% ROC curve
pre= [];
rec= [];
for i=-0.01:0.01:1.01
    r= sum((sim1<th) & (sim5<i),2)./sum(sim1<th,2); %FPR
    p= sum((sim1>=th) & (sim5>=i),2)./sum(sim1>th,2);%TPR
    rec= [rec,r];
    pre= [pre,p];
end
figure;
set(gcf,'color','white');
hold on;
for i=1:5
    p= pre(i,:);
    r= rec(i,:);
    plot(r,p,'Color',iColor(i+1),'linewidth',2);
end
xlabel('False Positive Rate');
ylabel('Ture Positive Rate');
title('ROC');
legend('class 1','class 2','class 3','class 4','class 5');
saveas(gcf,['..\saveresult\',imgType,'-self-mul-roc.emf']);
%% precise-recall curve
% pre= [];
% rec= [];
% for i=0.1:0.01:1
%     r= sum((sim1>=th) & (sim5>=i),2)./sum(sim1>=th,2);
%     p= sum((sim1>=th) & (sim5>=i),2)./sum(sim5>=i,2);
%     rec= [rec,r];
%     pre= [pre,p];
% end
% figure;
% hold on;
% for i=1:5
%     p= pre(i,:);
%     r= rec(i,:);
%     plot(r,p,'Color',iColor(i+1));
% end
% xlabel('recall');
% ylabel('precise');
% legend('class 1','class 2','class 3','class 4','class 5');
% disp(diff);
% disp(ccor);
