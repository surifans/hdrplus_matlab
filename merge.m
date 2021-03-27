%       I1Ϊ����֡
%       I2Ϊ�ο�֡
%       I3Ϊ����֡
%       x1,y1ΪI2��I1�����λ��ͼ
%       x3,y3ΪI2��I3�����λ��ͼ
%       NΪ�ںϿ�Ĵ�С
%       IrgbΪ�ںϺ��ͼ


function   [Irgb]=merge(I1,I2,I3,x1,y1,x3,y3,N)%I����Ϊ�ο�֡
    %tic;      
    %����������ԭͼ���и�˹ģ����������
    G = fspecial('gaussian', [16 16], 2);
    I1gs = imfilter(I1,G,'conv');
    I2gs = imfilter(I2,G,'conv');
    
    
    [a,b,~]=size(I1);  
    
    h=ceil(a/N);%����ȡ��    �鿴I�����ж��ٸ�ƽ�̿�
    w=ceil(b/N);%����ȡ��    �鿴I�����ж��ٸ�ƽ�̿�
    
    maxx1=max(max(abs(x1)));
    maxy1=max(max(abs(y1)));
    nn=max(maxx1,maxy1);
    maxx1=max(max(abs(x3)));
    maxy1=max(max(abs(y3)));
    mm=max(maxx1,maxy1);
    nn=max(nn,mm);
    
    I11=zeros(a+2*nn,b+2*nn);
    I33=zeros(a+2*nn,b+2*nn);
    %���������Ҷ�ͼ
    I11(nn+1:nn+a,nn+1:nn+b)=rgb2gray(I1);%��ΪҪ��I1��ȡ�飬����Ҫ��I1����
    I33(nn+1:nn+a,nn+1:nn+b)=rgb2gray(I3);%��ΪҪ��I3��ȡ�飬����Ҫ��I1����
    %����������ͼ
    I11rgb=zeros(a+2*nn,b+2*nn,3);
    I11rgb(nn+1:nn+a,nn+1:nn+b,1:3)=I1;
    I33rgb=zeros(a+2*nn,b+2*nn,3);
    I33rgb(nn+1:nn+a,nn+1:nn+b,1:3)=I3;
    
    aaa=zeros(a,b);
    Irgb=zeros(a,b,3);
    for i=1:h  %��ΧһȦƽ�̿鲻���ƶ�
        for j=1:w  %��Ϊ����ɿն������ҶԲ���
            mh=(i-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ���غ�����
            mw=(j-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ����������
            mw_end= mw+N-1;
            mh_end= mh+N-1;
            mask2=double(rgb2gray(I2(mh:mh_end,mw:mw_end,1:3)));%ѡȡI2�Ҷ�ͼ��һ��
            mask2rgb=double(I2(mh:mh_end,mw:mw_end,1:3));
            mask2gs=double(I2gs(mh:mh_end,mw:mw_end,1:3));
            
            xmin=x1(i,j)+mh;%��I�е������ϵ��������
            ymin=y1(i,j)+mw;%��I�е������ϵ��������
            xmax=xmin+N-1;%��I�е������µ��������
            ymax=ymin+N-1;%��I�е������µ��������
            %���������Ҷ�ͼ
            mask1=I11(xmin+nn:xmax+nn,ymin+nn:ymax+nn);%  I1�Ҷ�ͼ���ҵ���һ��
            %����������ͼ��������
            mask1rgb=I11rgb(xmin+nn:xmax+nn,ymin+nn:ymax+nn,1:3);%mask1��Ϊ������Χ
            
            
            xmin=x3(i,j)+mh;%��I�е������ϵ��������
            ymin=y3(i,j)+mw;%��I�е������ϵ��������
            xmax=xmin+N-1;%��I�е������µ��������
            ymax=ymin+N-1;%��I�е������µ��������
            %���������Ҷ�ͼ
            mask3=I33(xmin+nn:xmax+nn,ymin+nn:ymax+nn);%  I3�Ҷ�ͼ���ҵ���һ��
            %����������ͼ��������
            mask3rgb=I33rgb(xmin+nn:xmax+nn,ymin+nn:ymax+nn,1:3);%mask1��Ϊ������Χ
            
            %%%%%%%%%%%%%%%%%%%%ʱ�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %���������ûҶ�ͼ��������������
%             %�������������1������A1��������
%             T1a=8.0*(sum(sum(mask1.*mask1)))/(N*N);
%             T1b=sum(sum((abs(fft2(mask1)-fft2(mask2))).^2));
%             %T1c=T1b+32.0*sqrt(sum(sum(mask2.*mask2)))/(N);
%             T1c=T1b+T1a;
%             A1=T1b/T1c;
%             aaa(i,j)=A1;
%             
%             %�������������2������A2��������
%             T3a=8.0*(sum(sum(mask3.*mask3)))/(N*N);
%             T3b=sum(sum((abs(fft2(mask3)-fft2(mask2))).^2));
%             %T3c=T3b+32.0*sqrt(sum(sum(mask2.*mask2)))/(N);
%             T3c=T3b+T3a;
%             A2=T3b/T3c;
%             %����������ͼ�ںϡ�������
%             T2=(1/3)* fft2(mask2rgb);
%             T1=(1/3)* (fft2(mask1rgb)+A1*(fft2(mask2rgb)-fft2(mask1rgb)));
%             T3=(1/3)* (fft2(mask3rgb)+A2*(fft2(mask2rgb)-fft2(mask3rgb)));
%             Targb=T1+T2+T3;
%             Targb=ifft2(Targb);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%�ռ��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %���������ûҶ�ͼ��������������
            %�������������1������A1��������
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