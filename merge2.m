%       I1为交替帧
%       I2为参考帧
%       I3为交替帧
%       x1,y1为I2向I1对齐的位移图
%       x3,y3为I2向I3对齐的位移图
%       N为融合块的大小
%       Irgb为融合后的图


function   [Irgb]=merge2(I,x,y,N)%I是作为参考帧
    
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
            mw_end= min(mw+N-1,b);
            mh_end= min(mh+N-1,a);
            
            clear maskref;
            maskref=double(I{1}(mh:mh_end,mw:mw_end,1:3));%参考帧的图块
            %mask1gray=rgb2gray(uint8(maskref));
            [mwidth,mhigth,~]=size(maskref);
            sumT=(1/8)*fft2(maskref);
            for ii=1:7
                %计算7张图上查找到的对应图块和参考图块的L1残差
                clear mask;
                x1=x(:,:,ii);
                y1=y(:,:,ii);
                xmin=x1(i,j)+mh;%在I中的最左上点的行坐标
                ymin=y1(i,j)+mw;%在I中的最左上点的列坐标
                xmax=xmin+mwidth-1;%在I中的最右下点的行坐标
                ymax=ymin+mhigth-1;%在I中的最右下点的列坐标
                mask=double(I11{ii}(xmin+nn:xmax+nn,ymin+nn:ymax+nn,:));%遍历所有块
                
                T1=(1/8)*(fft2(mask));%8张图对齐图块直接取傅里叶变换的1/8融合去噪
                
                sumT=T1+sumT;
            end
            
            Tiff2=ifft2(sumT);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Irgb(mh:mh_end,mw:mw_end,1:3)=Tiff2;
        end
    end
    Irgb=floor((Irgb/max(max(max(Irgb))))*255);
    Idis4=uint8(Irgb);
    Irgb=Idis4;
end