%       I1：交替帧
%       I2：参考帧
%       mapx4：平移x矩阵
%       mapy4：平移y矩阵



function   [mapx4,mapy4]=CalcuFourDisplace(I1,I2)%I是作为参考帧
   
    I=rgb2gray(I1);  %
    II=rgb2gray(I2); 
    [w,h]=size(I);
    %imwrite(II,'II.jpg');
    
    %————用一个表map存储每个像素的其实位置————
    mapx=zeros(w,h);
    mapy=zeros(w,h);
    
    %————第1级平移————
    n=32;%将原图缩放的倍数
    N=16;%缩放后的图片划分的平铺块的大小
    I2=imresize(I,1/n);    %交替帧
    II2=imresize(II,1/n);  %参考帧
    map1=Calcumap(II2,I2,N,4,n,mapx,mapy);  
    [mapx1,mapy1]=Calcudismap(mapx,mapy,map1,n,N);
    %[Idis1,mask1]=dis_img(mapx1,mapy1,II);
    %Idis1=uint8(Idis1);
    %imwrite(Idis1,'1111.jpg');



    %————第2级平移————
    n=8;%将原图缩放的倍数
    N=16;%缩放后的图片划分的平铺块的大小
    I2=imresize(I,1/n);    %交替帧
    II2=imresize(II,1/n);  %参考帧
    map2=Calcumap(II2,I2,N,4,n,mapx1,mapy1);  
    [mapx2,mapy2]=Calcudismap(mapx1,mapy1,map2,n,N);
    %[Idis2,mask2]=dis_img(mapx2,mapy2,II);
    %Idis2=uint8(Idis2);
    %imwrite(Idis2,'2222.jpg');



    %————第3级平移————
    n=2;%将原图缩放的倍数
    N=16;%缩放后的图片划分的平铺块的大小
    I2=imresize(I,1/n);    %交替帧
    II2=imresize(II,1/n);  %参考帧
    map3=Calcumap(II2,I2,N,4,n,mapx2,mapy2);  
    [mapx3,mapy3]=Calcudismap(mapx2,mapy2,map3,n,N);
    %[Idis3,mask3]=dis_img(mapx3,mapy3,II);
    %Idis3=uint8(Idis3);
    %imwrite(Idis3,'3333.jpg');


    %————第4级平移————
    n=1;%将原图缩放的倍数
    N=16;%缩放后的图片划分的平铺块的大小
    I2=imresize(I,1/n);    %交替帧
    II2=imresize(II,1/n);  %参考帧
    map4=Calcumap(II2,I2,N,1,n,mapx3,mapy3);  
    [mapx4,mapy4]=Calcudismap(mapx3,mapy3,map4,n,N);
    
    %[Idis4,~]=dis_img(mapx4,mapy4,II);
    %Idis4=uint8(Idis4);
    %imwrite(Idis4,'4444.jpg');

end