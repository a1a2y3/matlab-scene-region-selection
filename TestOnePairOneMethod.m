function [tstcnt,errcnt]=TestOnePairOneMethod(im1,im2,mtdhdl,...
    winwidth,poolwidth,codewidth)
% 实时图为方形，边长winwidth 
% 池化边长，等同于压缩倍数 poolwidth

% sparse coding template binary coding
[h,w]= size(im2);
% 窗口尺寸w0*w0, 
w0=winwidth;
% 边界
d=30;
errcnt=0;
tstcnt=0;
% 准备显示

subplot(1,2,1);imshow(im1);
subplot(1,2,2);imshow(im2);
lineR= 20;
c1='y';%c2='m';c3='c';
s1='-';%s2='--';s3=':';
% 循环测试
for i=d:floor(w0/3):h-w0-d
	for j=d:floor(w0/3):w-w0-d
        tstcnt=tstcnt+1;
		imwin= im2(i:i+w0-1,j:j+w0-1);
        [x,y,~]=feval(mtdhdl,im1,imwin,poolwidth,codewidth);
        % 显示结果
        subplot(1,2,1);
		line([x+w0/2-lineR,x+w0/2+lineR], [y+w0/2,y+w0/2], 'Color',c1,'LineWidth',2,'LineStyle',s1);
        line([x+w0/2,x+w0/2], [y+w0/2-lineR,y+w0/2+lineR], 'Color',c1,'LineWidth',2,'LineStyle',s1);
        text(x+w0/2+10,y+w0/2-10,num2str(tstcnt), 'Color',c1,'FontSize',12,'FontWeight','normal');
        subplot(1,2,2);
		line([j+w0/2-lineR,j+w0/2+lineR], [i+w0/2,i+w0/2], 'Color',c1,'LineWidth',2,'LineStyle',s1);
        line([j+w0/2,j+w0/2], [i+w0/2-lineR,i+w0/2+lineR], 'Color',c1,'LineWidth',2,'LineStyle',s1);
        text(j+w0/2+10,i+w0/2-10,num2str(tstcnt), 'Color',c1,'FontSize',12,'FontWeight','normal');
        if(abs(y-i)>20 || abs(x-j)>20)
			errcnt=errcnt+1;
		end
	end
end
saveas(gcf, 'result.jpg');