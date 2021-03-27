%       I1Ϊ����֡
%       I2Ϊ�ο�֡
%       I3Ϊ����֡
%       x1,y1ΪI2��I1�����λ��ͼ
%       x3,y3ΪI2��I3�����λ��ͼ
%       NΪ�ںϿ�Ĵ�С
%       IrgbΪ�ںϺ��ͼ


function   [Irgb]=merge1(I,x,y,N)%I����Ϊ�ο�֡
    
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
            mw_end= mw+N-1;
            mh_end= mh+N-1;
            
            clear mask1;
            mask1=double(I{1}(mh:mh_end,mw:mw_end,1:3));%�ο�֡��ͼ��
            mask1gray=rgb2gray(uint8(mask1));
           
            sumT=(1/8)*fft2(mask1);
            for ii=1:7
                %����7��ͼ�ϲ��ҵ��Ķ�Ӧͼ��Ͳο�ͼ���L1�в�
                clear mask;
                x1=x(:,:,ii);
                y1=y(:,:,ii);
                xmin=x1(i,j)+mh;%��I�е������ϵ��������
                ymin=y1(i,j)+mw;%��I�е������ϵ��������
                xmax=xmin+N-1;%��I�е������µ��������
                ymax=ymin+N-1;%��I�е������µ��������
                mask=double(I11{ii}(xmin+nn:xmax+nn,ymin+nn:ymax+nn,:));%�������п�
                
                maskgray=rgb2gray(uint8(mask));
                
                eee=maskgray.*maskgray;
                
                RMS=sqrt((sum(sum(double(maskgray).*double(maskgray))))/(N*N));%�������ϲ��ĵ�������õ�RMS
                
                oned=maskgray(:);%��maskgrayװ����1ά����
                RMS1=rms(oned);%��oned��rms
                
                cvariance =8*sum(sum((double(maskgray)-RMS1).^2))/(N*N);
                
                maskgrayfft2=fft2(maskgray);
                %maskgrayfft2=255*maskgrayfft2/max(max(maskgrayfft2));%������Ҷ�任��Ľ����Ϊ0��255
                
                mask1grayfft2=fft2(mask1gray);
                %mask1grayfft2=255*mask1grayfft2/max(max(mask1grayfft2));%������Ҷ�任��Ľ����Ϊ0��255
                
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
                
                T=(1/8)*(fft2(mask)+Azw*(fft2(mask1)-fft2(mask)));%����ά���˲�����8��ͼ����ں�
                
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