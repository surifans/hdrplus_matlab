%%%%%%%%����8��ͼ����Ŀ�Ĳв���Ϊ������ȥ�뷽ʽ
%       I1Ϊ����֡
%       I2Ϊ�ο�֡
%       I3Ϊ����֡
%       x1,y1ΪI2��I1�����λ��ͼ
%       x3,y3ΪI2��I3�����λ��ͼ
%       NΪ�ںϿ�Ĵ�С
%       IrgbΪ�ںϺ��ͼ


function   [Irgb]=merge8(I,x,y,N)%I����Ϊ�ο�֡
    
    
    
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
    
    a1=zeros(h,w);%���ڴ洢��֡��Ӧͼ����ռ�ı���
    a2=zeros(h,w);
    a3=zeros(h,w);
    a4=zeros(h,w);
    a5=zeros(h,w);
    a6=zeros(h,w);
    a7=zeros(h,w);
    a8=zeros(h,w);
    
    
    Irgb=zeros(a,b,3);%���ͼ
    for i=1:h  
        for j=1:w 
            mh=(i-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ���غ�����
            mw=(j-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ����������
            mw_end= min(mw+N-1,b);%ĩβ����Խ�磬���min�жϷ�ֹԽ��
            mh_end= min(mh+N-1,a);%��ֹԽ��
            
            clear maskref;
            maskref=I{1}(mh:mh_end,mw:mw_end,1:3);%�ο�֡��ͼ��
            [mwidth,mhigth,~]=size(maskref);
            A=zeros(7,1);%���ڴ洢�ÿ�ͼ�����7��ͼ��Ĳв�ĵ���
            B=cell(7,1);%���ڴ洢7����ɫͼ��
            for ii=1:7
                %����7��ͼ�ϲ��ҵ��Ķ�Ӧͼ��Ͳο�ͼ���L1�в�
                clear mask;
                x1=x(:,:,ii);
                y1=y(:,:,ii);
                xmin=x1(i,j)+mh;%��I�е������ϵ��������
                ymin=y1(i,j)+mw;%��I�е������ϵ��������
                xmax=xmin+mwidth-1;%��I�е������µ��������
                ymax=ymin+mhigth-1;%��I�е������µ��������
                mask=uint8(I11{ii}(xmin+nn:xmax+nn,ymin+nn:ymax+nn,:));%����֡�Ķ�Ӧͼ��
                absa=double(rgb2gray(mask));%�ҶȻ�
                absb=double(rgb2gray(maskref));
                r=sum(sum(abs(absa-absb)))/(N*N)+0.0001;%��ƽ�����زв�ֵ
                
                A(ii,1) = 1/r;
                B{ii,1}=double(mask(:,:,1:3));
            end
            
            %�����������ձ����ںϡ�������
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