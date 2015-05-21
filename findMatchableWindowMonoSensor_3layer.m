function findMatchableWindowMonoSensor_3layer(im,RefW,RefH,winW,winH,step)
%% ����׼��
if nargin<6
    step=100;
end
if nargin<4
    winW=refW/2;
    winH=refH/2;
end
if size(im,3)>1
    im= rgb2gray(im);
end
travelstep_h=step;   %Row
travelstep_w=travelstep_h;   %Column
ImgRefSize_h=RefH;    
ImgRefSize_w=RefW;   
% ��������������������,�����ͼ���ڴ�ͼ�ϱ�ʾǰN�����ʺϵ�ƥ����
%% ��һ��ѡ�� edge+var
h = fspecial('average',5);
im= imfilter(im,h);
[h, w]= size(im);
srh= floor((h-20-ImgRefSize_h)/travelstep_h)+1;
srw= floor((w-20-ImgRefSize_w)/travelstep_w)+1;
scoreList_1= zeros(srh*srw,3);
disp('var calculating  layer1');
varmap= regionVar(im);   % ����21
disp('edge detecting  layer1');
edgemap= edge(im,'canny'); % ��Ե
figure, imshow(im);
cnt=0;
for i=10:travelstep_h:h-10-ImgRefSize_h
    disp(['processing image ', num2str(cnt), ' of ', num2str(srh*srw), ' layer1']);
    for j=10:travelstep_w:w-10-ImgRefSize_w
        win1= edgemap(i:i+ImgRefSize_h-1,j:j+ImgRefSize_w-1);
        f1= mean(win1(:));
        win2= varmap(i:i+ImgRefSize_h-1,j:j+ImgRefSize_w-1);
        f2= mean(win2(:));
        cnt=cnt+1;
        scoreList_1(cnt,1)= f1*f2;
        scoreList_1(cnt,2)= j;   % x
        scoreList_1(cnt,3)= i;   % y
    end
end
%% show score map
% scoreMap_1= reshape(scoreList_1(:,1),srh,srw);
% figure, imagesc(scoreMap_1);
% sort score
N1= cnt;
% ��ʾȫ����ѡ����
% for i=1:N1
%     rectangle('Position',[scoreList_1(i,2),scoreList_1(i,3)...
%         ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','y');
% end
[~,idx1]= sort(scoreList_1(:,1),'descend');
N2= max(ceil(N1/5),100);
N2= min(N2,N1);
% display layer1 result
for i=1:N2
    k= idx1(i);
    rectangle('Position',[scoreList_1(k,2),scoreList_1(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','r');
end
% saveas(gcf,'..\saveresult\region_find_bsc.emf');
%% �ڶ���ѡ�� 9features+LSSVM
scoreList_2= zeros(N2,3);
mf= zeros(N2,9);
addpath('feature');
for i=1:N2
    disp(['feature extracting ', num2str(i), 'of ', num2str(N2), ' layer2']);
    k= idx1(i);
    ImgRef= im(scoreList_1(k,3):scoreList_1(k,3)+ImgRefSize_h-1,...
             scoreList_1(k,2):scoreList_1(k,2)+ImgRefSize_w-1);
    %ȫͼ��׼��F1
    f1=refer_image_whole_standard_deviation(ImgRef);
    %����ֵ�ֲڶ�F2
    f2 = image_roughness(ImgRef);
    %��Ե�ܶ�(ͬʱ���ؾ�ֵ���׼�Ӧ��ʱȡ��Ե��׼��)F3, F4
%     [f3,f4]=edge_density(ImgRef);
    %�㽻���ܶ�F5
    f5 = zero_cross_density(ImgRef);
    %ȫͼ��Ϣ��F6
    f6 = refer_image_whole_entropy(ImgRef);
    %ƽ��FBMά��F7
%     f7 = mean_FBM_dimension(ImgRef);
    %��С�ֲ���׼��F8
    f8 = MinLocalStd(ImgRef);
    %Frieden�Ҷ���F9
    f9 = frieden_entropy(ImgRef);
    %�ݶ�ǿ�Ⱦ�ֵF10
    f10 = image_meanGradientIntensity(ImgRef);
    %��Ƶ��Ϣ�� F11
    f11= phase_complexity(ImgRef);
    %��С�ֲ���Ƶ��Ϣ�� F12
    f12= hpf_grid(ImgRef,4);
    scoreList_2(i,:)= [0 scoreList_1(k,2) scoreList_1(k,3)];
    mf(i,:)= [f1 f2 f5 f6 f8 f9 f10 f11 f12];
end
% lssvm predict
addpath('../LSSVMlabv1_8_R2009b_R2011a');
load('..\models\lssvm_.mat');
disp(['lssvm predicting layer2']);
mf= (mf-repmat(mydata.v_low, N2, 1))./...
    (repmat(mydata.v_high, N2, 1)-repmat(mydata.v_low, N2, 1));
% ����Ҫ��Ҫ���� ���������Сֵ���ƣ���������������������������������������
scoreList_2(:,1) = simlssvm(mydata.model,mf);
[~,idx2]= sort(scoreList_2(:,1),'descend');
N3= max(ceil(N2/5),50);
N3= min(N3,N2);
% display layer2 result
for i=1:N3
    k= idx2(i);
    rectangle('Position',[scoreList_2(k,2),scoreList_2(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','g');
end
% saveas(gcf,'..\saveresult\region_find_bsc.emf');
%% ������ѡ�� BSC matcher 
scoreList_3= zeros(N3,3);
h = fspecial('average', 7);
for i=1:N3
    disp(['evaluating ', num2str(i), 'of ', num2str(N3), ' layer3']);
    k= idx2(i);
    win3= im(scoreList_2(k,3):scoreList_2(k,3)+ImgRefSize_h-1,...
             scoreList_2(k,2):scoreList_2(k,2)+ImgRefSize_w-1); 
    ratio = 70/sqrt(ImgRefSize_h*ImgRefSize_w);
    win3= imresize(win3,ratio);
    win3_s= imfilter(win3,h);
    win3_a= imnoise(win3,'speckle',0.4);     
    [mRate,~]= getSelfSim(win3_s,win3_a,winW*ratio,winH*ratio);
    scoreList_3(i,:)= [mRate scoreList_2(k,2) scoreList_2(k,3)];
end
[mRList,idx3]= sort(scoreList_3(:,1),'descend');
N4= min(ceil(N3/4),10);
% display result
for i=1:N4
    k= idx3(i);
    rectangle('Position',[scoreList_3(k,2),scoreList_3(k,3)...
        ,ImgRefSize_w,ImgRefSize_h],'EdgeColor','b');    
end
saveas(gcf,'..\saveresult\region_find_monosensor.emf');
figure;
for i=1:N4
    k= idx3(i);
    win3= im(scoreList_3(k,3):scoreList_3(k,3)+ImgRefSize_h-1,...
             scoreList_3(k,2):scoreList_3(k,2)+ImgRefSize_w-1,:);
    imshow(win3);
    text(10,10,['������: ' num2str(mRList(i),'%4.3f')],...
     'Color','y','FontSize',12,'FontWeight','normal');
    saveas(gcf,['..\saveresult\win-',num2str(i),'.jpg']);
end
close gcf;