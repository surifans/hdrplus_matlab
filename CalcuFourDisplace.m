%       I1������֡
%       I2���ο�֡
%       mapx4��ƽ��x����
%       mapy4��ƽ��y����



function   [mapx4,mapy4]=CalcuFourDisplace(I1,I2)%I����Ϊ�ο�֡
   
    I=rgb2gray(I1);  %
    II=rgb2gray(I2); 
    [w,h]=size(I);
    %imwrite(II,'II.jpg');
    
    %����������һ����map�洢ÿ�����ص���ʵλ�á�������
    mapx=zeros(w,h);
    mapy=zeros(w,h);
    
    %����������1��ƽ�ơ�������
    n=32;%��ԭͼ���ŵı���
    N=16;%���ź��ͼƬ���ֵ�ƽ�̿�Ĵ�С
    I2=imresize(I,1/n);    %����֡
    II2=imresize(II,1/n);  %�ο�֡
    map1=Calcumap(II2,I2,N,4,n,mapx,mapy);  
    [mapx1,mapy1]=Calcudismap(mapx,mapy,map1,n,N);
    %[Idis1,mask1]=dis_img(mapx1,mapy1,II);
    %Idis1=uint8(Idis1);
    %imwrite(Idis1,'1111.jpg');



    %����������2��ƽ�ơ�������
    n=8;%��ԭͼ���ŵı���
    N=16;%���ź��ͼƬ���ֵ�ƽ�̿�Ĵ�С
    I2=imresize(I,1/n);    %����֡
    II2=imresize(II,1/n);  %�ο�֡
    map2=Calcumap(II2,I2,N,4,n,mapx1,mapy1);  
    [mapx2,mapy2]=Calcudismap(mapx1,mapy1,map2,n,N);
    %[Idis2,mask2]=dis_img(mapx2,mapy2,II);
    %Idis2=uint8(Idis2);
    %imwrite(Idis2,'2222.jpg');



    %����������3��ƽ�ơ�������
    n=2;%��ԭͼ���ŵı���
    N=16;%���ź��ͼƬ���ֵ�ƽ�̿�Ĵ�С
    I2=imresize(I,1/n);    %����֡
    II2=imresize(II,1/n);  %�ο�֡
    map3=Calcumap(II2,I2,N,4,n,mapx2,mapy2);  
    [mapx3,mapy3]=Calcudismap(mapx2,mapy2,map3,n,N);
    %[Idis3,mask3]=dis_img(mapx3,mapy3,II);
    %Idis3=uint8(Idis3);
    %imwrite(Idis3,'3333.jpg');


    %����������4��ƽ�ơ�������
    n=1;%��ԭͼ���ŵı���
    N=16;%���ź��ͼƬ���ֵ�ƽ�̿�Ĵ�С
    I2=imresize(I,1/n);    %����֡
    II2=imresize(II,1/n);  %�ο�֡
    map4=Calcumap(II2,I2,N,1,n,mapx3,mapy3);  
    [mapx4,mapy4]=Calcudismap(mapx3,mapy3,map4,n,N);
    
    %[Idis4,~]=dis_img(mapx4,mapy4,II);
    %Idis4=uint8(Idis4);
    %imwrite(Idis4,'4444.jpg');

end