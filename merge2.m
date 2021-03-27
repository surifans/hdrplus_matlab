%       I1Ϊ����֡
%       I2Ϊ�ο�֡
%       I3Ϊ����֡
%       x1,y1ΪI2��I1�����λ��ͼ
%       x3,y3ΪI2��I3�����λ��ͼ
%       NΪ�ںϿ�Ĵ�С
%       IrgbΪ�ںϺ��ͼ


function   [Irgb]=merge2(I,x,y,N)%I����Ϊ�ο�֡
    
    %tic;      
    %����������ԭͼ���и�˹ģ����������
    %     G = fspecial('gaussian', [16 16], 2);
    %     I1gs = imfilter(I1,G,'conv');
    %     I2gs = imfilter(I2,G,'conv');
    
    
    [a,b,c]=size(I{1});  
    
    h=ceil(a/N);%����ȡ��    �鿴I�����ж��ٸ�ƽ�̿�
    w=ceil(b/N);%����ȡ��    �鿴I�����ж��ٸ�ƽ�̿�
    
    maxx1=max(max(max(abs(x))));
    maxy1=max(max(max(abs(y))));
    nn=max(maxx1,maxy1);
    
    %����������ʼ��I11�Ĵ�С
    Ik=zeros(a+2*nn,b+2*nn,3);
    I11{1}=Ik;
    I11{2}=Ik;
    I11{3}=Ik;
    I11{4}=Ik;
    I11{5}=Ik;
    I11{6}=Ik;
    I11{7}=Ik;
    
    I11{1}(nn+1:nn+a,nn+1:nn+b,:)=I{2};%���ο�֡�⣬ȫ����Ҫ��չ
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
    
    
    Irgb=zeros(a,b,3);%���ͼ
    for i=1:h  %��ΧһȦƽ�̿鲻���ƶ�
        for j=1:w  %��Ϊ����ɿն������ҶԲ���
            mh=(i-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ���غ�����
            mw=(j-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ����������
            mw_end= min(mw+N-1,b);
            mh_end= min(mh+N-1,a);
            
            clear maskref;
            maskref=double(I{1}(mh:mh_end,mw:mw_end,1:3));%�ο�֡��ͼ��
            %mask1gray=rgb2gray(uint8(maskref));
            [mwidth,mhigth,~]=size(maskref);
            sumT=(1/8)*fft2(maskref);
            for ii=1:7
                %����7��ͼ�ϲ��ҵ��Ķ�Ӧͼ��Ͳο�ͼ���L1�в�
                clear mask;
                x1=x(:,:,ii);
                y1=y(:,:,ii);
                xmin=x1(i,j)+mh;%��I�е������ϵ��������
                ymin=y1(i,j)+mw;%��I�е������ϵ��������
                xmax=xmin+mwidth-1;%��I�е������µ��������
                ymax=ymin+mhigth-1;%��I�е������µ��������
                mask=double(I11{ii}(xmin+nn:xmax+nn,ymin+nn:ymax+nn,:));%�������п�
                
                T1=(1/8)*(fft2(mask));%8��ͼ����ͼ��ֱ��ȡ����Ҷ�任��1/8�ں�ȥ��
                
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