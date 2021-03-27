%       I1为交替帧
%       I2为参考帧
%       I3为交替帧
%       x1,y1为I2向I1对齐的位移图
%       x3,y3为I2向I3对齐的位移图
%       N为融合块的大小
%       Irgb为融合后的图


function   [Irgb]=merge(I1,I2,I3,x1,y1,x3,y3,N)%I是作为参考帧
    %tic;      
    %————对原图进行高斯模糊————
    G = fspecial('gaussian', [16 16], 2);
    I1gs = imfilter(I1,G,'conv');
    I2gs = imfilter(I2,G,'conv');
    
    
    [a,b,~]=size(I1);  
    
    h=ceil(a/N);%向上取整    查看I中能有多少个平铺块
    w=ceil(b/N);%向上取整    查看I中能有多少个平铺块
    
    maxx1=max(max(abs(x1)));
    maxy1=max(max(abs(y1)));
    nn=max(maxx1,maxy1);
    maxx1=max(max(abs(x3)));
    maxy1=max(max(abs(y3)));
    mm=max(maxx1,maxy1);
    nn=max(nn,mm);
    
    I11=zeros(a+2*nn,b+2*nn);
    I33=zeros(a+2*nn,b+2*nn);
    %————灰度图
    I11(nn+1:nn+a,nn+1:nn+b)=rgb2gray(I1);%因为要在I1中取块，故需要将I1扩充
    I33(nn+1:nn+a,nn+1:nn+b)=rgb2gray(I3);%因为要在I3中取块，故需要将I1扩充
    %————彩图
    I11rgb=zeros(a+2*nn,b+2*nn,3);
    I11rgb(nn+1:nn+a,nn+1:nn+b,1:3)=I1;
    I33rgb=zeros(a+2*nn,b+2*nn,3);
    I33rgb(nn+1:nn+a,nn+1:nn+b,1:3)=I3;
    
    aaa=zeros(a,b);
    Irgb=zeros(a,b,3);
    for i=1:h  %周围一圈平铺块不用移动
        for j=1:w  %因为易造成空洞，而且对不齐
            mh=(i-1)*N+1;%第（i，j)个mask的初始像素横坐标
            mw=(j-1)*N+1;%第（i，j)个mask的初始像素纵坐标
            mw_end= mw+N-1;
            mh_end= mh+N-1;
            mask2=double(rgb2gray(I2(mh:mh_end,mw:mw_end,1:3)));%选取I2灰度图的一块
            mask2rgb=double(I2(mh:mh_end,mw:mw_end,1:3));
            mask2gs=double(I2gs(mh:mh_end,mw:mw_end,1:3));
            
            xmin=x1(i,j)+mh;%在I中的最左上点的行坐标
            ymin=y1(i,j)+mw;%在I中的最左上点的列坐标
            xmax=xmin+N-1;%在I中的最右下点的行坐标
            ymax=ymin+N-1;%在I中的最右下点的列坐标
            %————灰度图
            mask1=I11(xmin+nn:xmax+nn,ymin+nn:ymax+nn);%  I1灰度图上找到的一块
            %————彩图————
            mask1rgb=I11rgb(xmin+nn:xmax+nn,ymin+nn:ymax+nn,1:3);%mask1即为搜索范围
            
            
            xmin=x3(i,j)+mh;%在I中的最左上点的行坐标
            ymin=y3(i,j)+mw;%在I中的最左上点的列坐标
            xmax=xmin+N-1;%在I中的最右下点的行坐标
            ymax=ymin+N-1;%在I中的最右下点的列坐标
            %————灰度图
            mask3=I33(xmin+nn:xmax+nn,ymin+nn:ymax+nn);%  I3灰度图上找到的一块
            %————彩图————
            mask3rgb=I33rgb(xmin+nn:xmax+nn,ymin+nn:ymax+nn,1:3);%mask1即为搜索范围
            
            %%%%%%%%%%%%%%%%%%%%时域求比例%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %————用灰度图算两个比例——
%             %————计算第1个比例A1————
%             T1a=8.0*(sum(sum(mask1.*mask1)))/(N*N);
%             T1b=sum(sum((abs(fft2(mask1)-fft2(mask2))).^2));
%             %T1c=T1b+32.0*sqrt(sum(sum(mask2.*mask2)))/(N);
%             T1c=T1b+T1a;
%             A1=T1b/T1c;
%             aaa(i,j)=A1;
%             
%             %————计算第2个比例A2————
%             T3a=8.0*(sum(sum(mask3.*mask3)))/(N*N);
%             T3b=sum(sum((abs(fft2(mask3)-fft2(mask2))).^2));
%             %T3c=T3b+32.0*sqrt(sum(sum(mask2.*mask2)))/(N);
%             T3c=T3b+T3a;
%             A2=T3b/T3c;
%             %————彩图融合————
%             T2=(1/3)* fft2(mask2rgb);
%             T1=(1/3)* (fft2(mask1rgb)+A1*(fft2(mask2rgb)-fft2(mask1rgb)));
%             T3=(1/3)* (fft2(mask3rgb)+A2*(fft2(mask2rgb)-fft2(mask3rgb)));
%             Targb=T1+T2+T3;
%             Targb=ifft2(Targb);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%空间域求比例%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %————用灰度图算两个比例——
            %————计算第1个比例A1————
            %T1a=8.0*(sum(sum(mask1.*mask1)))/(N*N);
            T1a=sum(sum((abs(mask1-mask2))))/(N*N);
            T1b=sum(sum((abs(mask3-mask2))))/(N*N);
            
            
            A1=T1b/(T1a+T1b+T1a*T1b);
            A2=T1a*T1b/(T1a+T1b+T1a*T1b);
            A3=T1a/(T1a+T1b+T1a*T1b);
            Targb=A1*mask1rgb+A2*mask2rgb+A3*mask3rgb;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Irgb(mh:mh_end,mw:mw_end,1:3)=Targb;
        end
    end
    Irgb=floor((Irgb/max(max(max(Irgb))))*255);
    Idis4=uint8(Irgb);
    Irgb=Idis4;
end