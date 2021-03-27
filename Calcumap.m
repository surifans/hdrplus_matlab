%    IΪ��Ҫ�ƶ���֡��Ϊ���ź��ͼ������������Ϊ32,8,2,1
%    I1Ϊ�ο�֡����I��I1�϶���
%    NΪ�ֿ�Ĵ�С����ƽ�̿�Ĵ�С
%    N1Ϊ��Χpad�Ĵ�С����ÿ��ƽ�̿��������Χ
%    map���ÿ��ƽ�̿���Ҫ�ƶ���λ��

function   new_map=Calcumap(I,I1,N,N1,n,mapx,mapy)%I����Ϊ�ο�֡
    %tic;
    [a,b,~]=size(I);  
    h=ceil(a/N);%����ȡ��    �鿴I�����ж��ٸ�ƽ�̿�
    w=ceil(b/N);%����ȡ��    �鿴I�����ж��ٸ�ƽ�̿�
    map0=cell(h,w);%�洢ÿ��ƽ�̿���ƶ���С�ͷ����ö�ά������ʾ
    
    for i=2:h-1  %��ΧһȦƽ�̿鲻���ƶ�
        for j=2:w-1  %��Ϊ����ɿն������ҶԲ���
            mh=(i-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ���غ�����
            mw=(j-1)*N+1;%�ڣ�i��j)��mask�ĳ�ʼ����������
            mw_end= mw+N-1;
            mh_end= mh+N-1;
            mask=I(mh:mh_end,mw:mw_end);
            %��������ר�á���
            %figure(11);
            %imshow(mask);
            %imwrite(mask,'111.jpg');

            [mwidth,mhight]=size(mask);%I�ϵ�ƽ�̿�Ĵ�С
            %��������������Χdst�����귶Χ������
            
            disx=floor(mapx(mh*n,mw*n)/n);
            disy=floor(mapy(mh*n,mw*n)/n);
            xmin=max(1,mh-N1+disx);%��I�е������ϵ��������
            ymin=max(1,mw-N1+disy);%��I�е������ϵ��������
            xmax=min(a,min(mh+N-1+disx,a)+N1);%��I�е������µ��������
            ymax=min(b,min(mw+N-1+disy,b)+N1);%��I�е������µ��������
            mask1=I1(xmin:xmax,ymin:ymax);%mask1��Ϊ������Χ


            dst=zeros(xmax-xmin+1-mwidth+1,ymax-ymin+1-mhight+1);  %Ϊÿ��ƽ�̿���ƶ���Χ��
            %dstΪһ�����ñ��¼ÿ���ƶ���Ӧ�Ĳв�ֵ������С�вΪ��ƽ�̿�Ӧ���ƶ���λ��
           [dstwidth,dsthight]=size(dst);%����Ҫ����Ĵ���Ϊ��dst�Ĵ�С
           xminend=xmin+dstwidth-1 ;
           yminend=ymin+dsthight-1 ;
           
            for i1=xmin:xminend
                for j1=ymin:yminend
                    temp=I1(i1:i1+mwidth-1,j1:j1+mhight-1);%��ȡ�ο�ģ��ͼ��  
                    temp_mask=double(temp)-double(mask);   %���в�
                    dst(i1-xmin+1,j1-ymin+1)=sum(sum(abs((temp_mask).*(temp_mask))));%��¼�в��С   
                end   
            end 
            %toc;
            flag=0;
            abs_min=min(min(dst)); %������С�в� 
            if isempty(dst)==false
                [x1,y1]=find(dst==abs_min);%��ȡ��С�в��λ��
                [wx,wy]=size(x1);%�鿴�м�����Сֵ
                flag=0;
                if wx>=2||wy>=2  %����ж����Сֵ����flag��¼����������öԸ�ƽ�̿��Ӧ��mapλ���ÿ�
                    x=0;
                    y=0;
                    flag=1;
                else            %�����һ����Сֵ��
                   x=x1-1;      %��Ϊdst����Сֵλ��Ϊ��1,1��ʱ����ʾƽ�̿�ľ���ƶ�
                   y=y1-1;      %�ʴ�ʱӦ�ö�x��y����1����λ��ʵ��Ϊ��0��0��
                end

                if i>1&&i<=h  %�����������Χ�����������䣬����ƽ������С�в��Ǵ����Ͻǿ�ʼ���㣬�������Ͻ���Ϊԭ��
                    x=x-N1;   %����Ҫ��λ�ƽ���ת��
                end
                if j>1&&j<=w
                    y=y-N1;
                end
            else
                flag=1;
            end

            %I4(i,j)=round(sqrt(x*x+y*y));%��ÿ��ƽ�̿�λ�ƵĴ�С
            if flag==0
                map0{i,j}=[x y]; %���flag=0˵��ֻ��һ����Сֵ
            else 
                map0{i,j}=[]; %���flag=1˵���ж����Сֵ����ʱ�ö�Ӧmap�ÿգ�����ͨ����Χλ�Ƽ���
            end
            %Idis((mh+x):(mh+x+mwidth-1),(mw+y):(mw+y+mhight-1))=mask;%������ͼ��Ķ���ͼ��

        end
    end
    %toc;

    
    %�����map���кܶ��ǿյ�cell����Ҫ��������Χ��cell����������
    new_map=filling_cell(map0);


    %������������ר�á�������
    % figure(4);
    % I4=I4/max(max(I4));
    % imshow(I4);
    % %imwrite(I4,'23333.jpg');

    %Idis=Idis(1:a,1:b);
    %DisplacementImg=I4;
    %toc;
end