sim2= sim;
for i=2:5
    sim2(i,:)= min(sim(1:i,:),[],1);
end
save('sim2.mat','sim2'); 
[~,idx]= sort(sim2(5,:));
figure;
hold on;
iColor= ['y','m','c','r','g','b','w','k'];
for i=1:5
    a= sim2(i,:);
    [~,idx]= sort(a);
    plot(a(idx),'Color',iColor(i+1));
end
legend('class 1','class 2','class 3','class 4','class 5');
set(gcf,'color','white');
saveas(gcf,'..\saveresult\sim2-5class.emf');
