%%%%%%%%采用8张图对齐的块的残差作为比例的去噪方式
%       I1为交替帧
%       I2为参考帧
%       I3为交替帧
%       x1,y1为I2向I1对齐的位移图
%       x3,y3为I2向I3对齐的位移图
%       N为融合块的大小
%       Irgb为融合后的图


function   [Irgb]=merge8(I,x,y,N)%I是作为参考帧
    
    
    
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
    
    a1=zeros(h,w);%用于存储各帧对应图块所占的比例
    a2=zeros(h,w);
    a3=zeros(h,w);
    a4=zeros(h,w);
    a5=zeros(h,w);
    a6=zeros(h,w);
    a7=zeros(h,w);
    a8=zeros(h,w);
    
    
    Irgb=zeros(a,b,3);%结果图
    for i=1:h  
        for j=1:w 
            mh=(i-1)*N+1;%第（i，j)个mask的初始像素横坐标
            mw=(j-1)*N+1;%第（i，j)个mask的初始像素纵坐标
            mw_end= min(mw+N-1,b);%末尾可能越界，添加min判断防止越界
            mh_end= min(mh+N-1,a);%防止越界
            
            clear maskref;
            maskref=I{1}(mh:mh_end,mw:mw_end,1:3);%参考帧的图块
            [mwidth,mhigth,~]=size(maskref);
            A=zeros(7,1);%用于存储该块图对齐的7个图块的残差的导数
            B=cell(7,1);%用于存储7个彩色图块
            for ii=1:7
                %计算7张图上查找到的对应图块和参考图块的L1残差
                clear mask;
                x1=x(:,:,ii);
                y1=y(:,:,ii);
                xmin=x1(i,j)+mh;%在I中的最左上点的行坐标
                ymin=y1(i,j)+mw;%在I中的最左上点的列坐标
                xmax=xmin+mwidth-1;%在I中的最右下点的行坐标
                ymax=ymin+mhigth-1;%在I中的最右下点的列坐标
                mask=uint8(I11{ii}(xmin+nn:xmax+nn,ymin+nn:ymax+nn,:));%交替帧的对应图块
                absa=double(rgb2gray(mask));%灰度化
                absb=double(rgb2gray(maskref));
                r=sum(sum(abs(absa-absb)))/(N*N)+0.0001;%求平均像素残差值
                
                A(ii,1) = 1/r;
                B{ii,1}=double(mask(:,:,1:3));
            end
            
            %————按照比例融合————
            Asum=1+sum(A);
            A1=1/Asum;
            A2=A(1,1)/Asum;
            A3=A(2,1)/Asum;
            A4=A(3,1)/Asum;
            A5=A(4,1)/Asum;
            A6=A(5,1)/Asum;
            A7=A(6,1)/Asum;
            A8=A(7,1)/Asum;
            
            
            a1(i,j)=A1;
            a2(i,j)=A2;
            a3(i,j)=A3;
            a4(i,j)=A4;
            a5(i,j)=A5;
            a6(i,j)=A6;
            a7(i,j)=A7;
            a8(i,j)=A8;
            
            Targb=A1*double(maskref)+A2*B{1,1}+A3*B{2,1}+A4*B{3,1}+A5*B{4,1}+A6*B{5,1}+A7*B{6,1}+A8*B{7,1};
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            Irgb(mh:mh_end,mw:mw_end,1:3)=Targb;
        end
    end
    Irgb=floor((Irgb/max(max(max(Irgb))))*255);
    Idis4=uint8(Irgb);
    Irgb=Idis4;
end