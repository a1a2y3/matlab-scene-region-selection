clear;
iname= [2,3,5,7,8,10];
iwidth=[146,113,151,112,174,142];
for i=1:6
    imName= ['ref\vis-',num2str(iname(i)),'-ref'];
    im= imread([imName,'.jpg']);
    winW= iwidth(i);
    winH= iwidth(i);
    disp(['processing image ', imName]);
    tic;
    rst= regionEvaluateMonoSensor(im,winW,winH,3);
    toc;
    disp(rst);
    saveas(gcf, [imName,'-  ≈‰–‘_monosensor.jpg']);
end