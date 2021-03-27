    clc;  
    close all;  
    clear;
for i=42%11:15
    tic;
    %A=['测试\',num2str(i)];
    I1=imread([num2str(i),'\1.jpg']);  
    
    I2=imread([num2str(i),'\2.jpg']); 
    
    I3=imread([num2str(i),'\3.jpg']); 
    
    I4=imread([num2str(i),'\4.jpg']); 
    
    I5=imread([num2str(i),'\5.jpg']); 
    
    I6=imread([num2str(i),'\6.jpg']); 
    
    I7=imread([num2str(i),'\7.jpg']); 
    
    I8=imread([num2str(i),'\8.jpg']); 
    
    
    
    
%         I1=I1(1:1000,1:1000,:);
%         imwrite(I1,[num2str(i),'\I1.jpg']);
%         I2=I2(1:1000,1:1000,:);
%         I3=I3(1:1000,1:1000,:);
%         I4=I4(1:1000,1:1000,:);
%         I5=I5(1:1000,1:1000,:);
%         I6=I6(1:1000,1:1000,:);
%         I7=I7(1:1000,1:1000,:);
%         I8=I8(1:1000,1:1000,:);
    
    %————计算对齐map——————————
    [mapx2,mapy2]=CalcuFourDisplace(I2,I1);%计算I1向I2对齐的map
    [mapx3,mapy3]=CalcuFourDisplace(I3,I1);%计算I3向I2对齐的map
    [mapx4,mapy4]=CalcuFourDisplace(I4,I1);%计算I3向I2对齐的map
    [mapx5,mapy5]=CalcuFourDisplace(I5,I1);%计算I3向I2对齐的map
    [mapx6,mapy6]=CalcuFourDisplace(I6,I1);%计算I3向I2对齐的map
    [mapx7,mapy7]=CalcuFourDisplace(I7,I1);%计算I3向I2对齐的map
    [mapx8,mapy8]=CalcuFourDisplace(I8,I1);%计算I3向I2对齐的map
    
    I{1}=I1;
    I{2}=I2;
    I{3}=I3;
    I{4}=I4;
    I{5}=I5;
    I{6}=I6;
    I{7}=I7;
    I{8}=I8;
    
    clear mapx;clear mapy;
    
    mapx(:,:,1)=mapx2;
    mapx(:,:,2)=mapx3;
    mapx(:,:,3)=mapx4;
    mapx(:,:,4)=mapx5;
    mapx(:,:,5)=mapx6;
    mapx(:,:,6)=mapx7;
    mapx(:,:,7)=mapx8;
    
    mapy(:,:,1)=mapy2;
    mapy(:,:,2)=mapy3;
    mapy(:,:,3)=mapy4;
    mapy(:,:,4)=mapy5;
    mapy(:,:,5)=mapy6;
    mapy(:,:,6)=mapy7;
    mapy(:,:,7)=mapy8;
    
    
    
    
    N=16;
    [w,h,~]=size(I1);
    x=mapx(1:N:w,1:N:h,:);
    y=mapy(1:N:w,1:N:h,:);
   
    
    Irgb=merge8(I,x,y,N);%I是作为参考帧
    
    %Irgb=merge1(I,x,y,N);%I是作为参考帧
    
%     %————自动伽马矫正——————
%     Irgb=double(Irgb)/255.0;
%     ImgGamma=imadjust(Irgb,[0 0.7],[0 1],0.6);
%    
%     ImgGamma=uint8(ImgGamma*255.0);
%     %————————————————
    imwrite(Irgb,[num2str(i),'\hdr_result.jpg']);
%     imwrite(ImgGamma,[num2str6(i),'\ImgGamma.jpg']);
    
    
%     %——————曝光融合——————————
%     I22=Irgb;  
%     I33=ImgGamma; 
%     [w,h,d]=size(I22);
%     I11(:,:,1)=zeros(w,h);
%     I11(:,:,2)=zeros(w,h);
%     I11(:,:,3)=zeros(w,h);
% 
%     I44(:,:,1)=zeros(w,h);
%     I44(:,:,2)=zeros(w,h);
%     I44(:,:,3)=zeros(w,h);
% 
%     I11=double(I11)/255;
%     I22=double(I22)/255;
%     I33=double(I33)/255;
%     I44=double(I44)/255;
% 
%     II(:,:,:,1)=I11;
%     II(:,:,:,2)=I22;
%     II(:,:,:,3)=I33;
%     II(:,:,:,4)=I44;
% %     % I = load_images('house');
% %     figure('Name','Input sequence');
% %     subplot(2,2,1); imshow(I(:,:,:,1));
% %     subplot(2,2,2); imshow(I(:,:,:,2));
% %     subplot(2,2,3); imshow(I(:,:,:,3));
% %     subplot(2,2,4); imshow(I(:,:,:,4));
% 
%     R = exposure_fusion(II,[1 1 1]);
%     %figure('Name','Result'); 
%     %imshow(R); 
%     %imwrite(R,'Result.jpg');
%     imwrite(R,[num2str(i),'\Result.jpg']);
    
    toc;
end
    