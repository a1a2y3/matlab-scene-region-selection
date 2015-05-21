function [sim]=regionEvaluateMonoSensor(im,winW,winH,iClass)
% ��������������
% �ο�����ʱ��
% 400*400, wReal=200, *s
% 400*400, wReal=100, *s
% 200*200, wReal=100, 5s
% 200*200, wReal=40 , *s
if nargin<4
    iClass= 3;
end
im2= histeq(im);
im3= im2;
h = fspecial('average', 5);
for k=1:iClass
    im2= imfilter(im2,h);
    im3= imnoise(im3,'speckle',0.1);    
end
[sim,map]= getSelfSim(histeq(im2),im3,winW,winH);
figure;
subplot(1,2,1),imshow(im);
[h0,w0]= size(map);
for i=1:h0
    for j=1:w0
        if map(i,j)>128
%             rectangle('Position',[j,i,winW,winH],'EdgeColor','r');
              line([j+winW/2-5,j+winW/2+5],[i+winH/2,i+winH/2],'Color','r');
              line([j+winW/2,j+winW/2],[i+winH/2-5,i+winH/2+5],'Color','r');
        end
    end
end
subplot(1,2,2),imshow(im);
c1='r';%c2='m';c3='c';
% s1='-';%s2='--';s3=':'
fontsize= 16;;
[h0,w0]= size(im);
text(10,25,['����ߴ�:',num2str(w0),'��',num2str(h0)],...
    'Color',c1,'FontSize',fontsize,'FontWeight','normal');
text(10,50,['Сͼ�ߴ�:',num2str(winW),'��',num2str(winH)],...
    'Color',c1,'FontSize',fontsize,'FontWeight','normal');
text(10,75,['�����ȼ�: ',num2str(iClass)],...
    'Color',c1,'FontSize',fontsize,'FontWeight','normal');
text(10,100,['������: ' num2str(sim,'%4.3f')],...
     'Color',c1,'FontSize',fontsize,'FontWeight','normal');
% saveas(gcf, 'saveresult\�������������.jpg');