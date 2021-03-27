%       I1为交替帧
%       I2为参考帧
%       I3为交替帧
%       x1,y1为I2向I1对齐的位移图
%       x3,y3为I2向I3对齐的位移图
%       N为融合块的大小
%       Irgb为融合后的图


function   [Irgb]=merge1(I,x,y,N)%I是作为参考帧
    
    %tic;      
    %————对原图进行高斯模糊————
    %     G = fspecial('gaussian', [16 16], 2);
    %     I1gs = imfilter(I1,G,'conv');
    %     I2gs = imfilter(I2,G,'conv');
    
    
    [a,b,c]=size(I{1});  
    
    h=ceil(a/N);%向上取整    查看I中能有多少个平铺块
    w=ceil(b/N);%向上取整    查看I中能有多少个平铺块
    
    maxx1=max(max(max(abs(x))));
    maxy1=max(max(max(abs(y))));
    nn=max(maxx1,maxy1);
    
    %————初始化I11的大小
    Ik=zeros(a+2*nn,b+2*nn,3);
    I11{1}=Ik;
    I11{2}=Ik;
    I11{3}=Ik;
    I11{4}=Ik;
    I11{5}=Ik;
    I11{6}=Ik;
    I11{7}=Ik;
    
    I11{1}(nn+1:nn+a,nn+1:nn+b,:)=I{2};%除参考帧外，全部需要扩展
    I11{2}(nn+1:nn+a,nn+1:nn+b,:)=I{3};
    I11{3}(nn+1:nn+a,nn+1:nn+b,:)=I{4};
    I11{4}(nn+1:nn+a,nn+1:nn+b,:)=I{5};
    I11{5}(nn+1:nn+a,nn+1:nn+b,:)=I{6};
    I11{6}(nn+1:nn+a,nn+1:nn+b,:)=I{7};
    I11{7}(nn+1:nn+a,nn+1:nn+b,:)=I{8};
    %I11=uint8(I11);
    
    a1=zeros(h,w);
    a2=zeros(h,w);
    a3=zeros(h,w);
    a4=zeros(h,w);
    a5=zeros(h,w);
    a6=zeros(h,w);
    a7=zeros(h,w);
    %a8=zeros(h,w);
    
    
    Irgb=zeros(a,b,3);%结果图
    for i=1:h  %周围一圈平铺块不用移动
        for j=1:w  %因为易造成空洞，而且对不齐
            mh=(i-1)*N+1;%第（i，j)个mask的初始像素横坐标
            mw=(j-1)*N+1;%第（i，j)个mask的初始像素纵坐标
            mw_end= mw+N-1;
            mh_end= mh+N-1;
            
            clear mask1;
            mask1=double(I{1}(mh:mh_end,mw:mw_end,1:3));%参考帧的图块
            mask1gray=rgb2gray(uint8(mask1));
           
            sumT=(1/8)*fft2(mask1);
            for ii=1:7
                %计算7张图上查找到的对应图块和参考图块的L1残差
                clear mask;
                x1=x(:,:,ii);
                y1=y(:,:,ii);
                xmin=x1(i,j)+mh;%在I中的最左上点的行坐标
                ymin=y1(i,j)+mw;%在I中的最左上点的列坐标
                xmax=xmin+N-1;%在I中的最右下点的行坐标
                ymax=ymin+N-1;%在I中的最右下点的列坐标
                mask=double(I11{ii}(xmin+nn:xmax+nn,ymin+nn:ymax+nn,:));%遍历所有块
                
                maskgray=rgb2gray(uint8(mask));
                
                eee=maskgray.*maskgray;
                
                RMS=sqrt((sum(sum(double(maskgray).*double(maskgray))))/(N*N));%按照网上查阅的资料求得的RMS
                
                oned=maskgray(:);%将maskgray装换成1维矩阵
                RMS1=rms(oned);%求oned得rms
                
                cvariance =8*sum(sum((double(maskgray)-RMS1).^2))/(N*N);
                
                maskgrayfft2=fft2(maskgray);
                %maskgrayfft2=255*maskgrayfft2/max(max(maskgrayfft2));%将傅里叶变换后的结果归为0到255
                
                mask1grayfft2=fft2(mask1gray);
                %mask1grayfft2=255*mask1grayfft2/max(max(mask1grayfft2));%将傅里叶变换后的结果归为0到255
                
                %aaa=abs(maskgrayfft2-mask1grayfft2);
                Dzw=sum(sum((abs(maskgrayfft2-mask1grayfft2)).^2));
                %T1c=Dzw+32.0*sqrt(sum(sum(mask2.*mask2)))/(N);
                T1c=Dzw+cvariance ;
                Azw=Dzw/T1c;
                
                if ii==1
                    a1(i,j)=Azw;
                end
                if ii==2
                    a2(i,j)=Azw;
                end
                if ii==3
                    a3(i,j)=Azw;
                end
                if ii==4
                    a4(i,j)=Azw;
                end
                if ii==5
                    a5(i,j)=Azw;
                end
                if ii==6
                    a6(i,j)=Azw;
                end
                if ii==7
                    a7(i,j)=Azw;
                end
                
                T=(1/8)*(fft2(mask)+Azw*(fft2(mask1)-fft2(mask)));%基于维纳滤波器的8个图块的融合
                
                sumT=T+sumT;
            end
            
            T0w=ifft2(sumT);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Irgb(mh:mh_end,mw:mw_end,1:3)=T0w;
        end
    end
    Irgb=floor((Irgb/max(max(max(Irgb))))*255);
    Idis4=uint8(Irgb);
    Irgb=Idis4;
end