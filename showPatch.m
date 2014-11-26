function showPatch(k)
sName= [num2str(k,'%06d'),'.jpg'];
im = imread(['datav/', sName]);
figure;
set(gcf,'color','white');
subplot(2,3,1);
imshow(im);
subplot(2,3,4);
imshow(im);
for i=1:2
    ims= imread(['S',num2str(i),'\', sName]);
    ima= imread(['A',num2str(i),'\', sName]);
    subplot(2,3,i+1);
    imshow(ims);
    subplot(2,3,i+4);
    imshow(ima);
end
saveas(gcf,'saveresult\p1.jpg');
figure;
set(gcf,'color','white');
for i=3:5
    ims= imread(['S',num2str(i),'\', sName]);
    ima= imread(['A',num2str(i),'\', sName]);
    subplot(2,3,i-2);
    imshow(ims);
    subplot(2,3,i+1);
    imshow(ima);
end
saveas(gcf,'saveresult\p2.jpg');