%       ʹ��merge���ںϣ�����Ϊ3��ͼ
    clc;  
    close all;  
    clear;
    
    
for i=3:12
    tic;
    %A=['����\',num2str(i)];
    I1=imread([num2str(i),'\1.jpg']);  
    I2=imread([num2str(i),'\2.jpg']); 
    I3=imread([num2str(i),'\3.jpg']); 
    
    %���������������map��������������������
    [mapx1,mapy1]=CalcuFourDisplace(I1,I2);%����I1��I2�����map
    [mapx3,mapy3]=CalcuFourDisplace(I3,I2);%����I3��I2�����map
    
    N=16;
    [w,h,~]=size(I1);
    x1=mapx1(1:N:w,1:N:h);
    y1=mapy1(1:N:w,1:N:h);
    x3=mapx3(1:N:w,1:N:h);
    y3=mapy3(1:N:w,1:N:h);
    
    %������������ͼ�ں�ȥ�롪������
    Irgb=merge(I1,I2,I3,x1,y1,x3,y3,N);%I����Ϊ�ο�֡
    
    %���������Զ�٤�����������������
    
    Irgb=double(Irgb)/255.0;
    ImgGamma=imadjust(Irgb,[0 0.6],[0 1],0.7);
   
    ImgGamma=uint8(ImgGamma*255.0);
    %��������������������������������
    imwrite(Irgb,[num2str(i),'\Irgb.jpg']);
    imwrite(ImgGamma,[num2str(i),'\ImgGamma.jpg']);
    
    toc;
end
    