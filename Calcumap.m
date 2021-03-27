%    I为需要移动的帧，为缩放后的图像，缩放率依次为32,8,2,1
%    I1为参考帧，即I向I1上对齐
%    N为分块的大小，即平铺块的大小
%    N1为周围pad的大小，即每个平铺块的搜索范围
%    map输出每个平铺块需要移动的位移

function   new_map=Calcumap(I,I1,N,N1,n,mapx,mapy)%I是作为参考帧
    %tic;
    [a,b,~]=size(I);  
    h=ceil(a/N);%向上取整    查看I中能有多少个平铺块
    w=ceil(b/N);%向上取整    查看I中能有多少个平铺块
    map0=cell(h,w);%存储每个平铺块的移动大小和方向，用二维向量表示
    
    for i=2:h-1  %周围一圈平铺块不用移动
        for j=2:w-1  %因为易造成空洞，而且对不齐
            mh=(i-1)*N+1;%第（i，j)个mask的初始像素横坐标
            mw=(j-1)*N+1;%第（i，j)个mask的初始像素纵坐标
            mw_end= mw+N-1;
            mh_end= mh+N-1;
            mask=I(mh:mh_end,mw:mw_end);
            %——测试专用——
            %figure(11);
            %imshow(mask);
            %imwrite(mask,'111.jpg');

            [mwidth,mhight]=size(mask);%I上的平铺块的大小
            %———求搜索范围dst的坐标范围———
            
            disx=floor(mapx(mh*n,mw*n)/n);
            disy=floor(mapy(mh*n,mw*n)/n);
            xmin=max(1,mh-N1+disx);%在I中的最左上点的行坐标
            ymin=max(1,mw-N1+disy);%在I中的最左上点的列坐标
            xmax=min(a,min(mh+N-1+disx,a)+N1);%在I中的最右下点的行坐标
            ymax=min(b,min(mw+N-1+disy,b)+N1);%在I中的最右下点的列坐标
            mask1=I1(xmin:xmax,ymin:ymax);%mask1即为搜索范围


            dst=zeros(xmax-xmin+1-mwidth+1,ymax-ymin+1-mhight+1);  %为每个平铺块的移动范围，
            %dst为一个表，该表记录每个移动对应的残差值，找最小残差即为该平铺块应该移动的位置
           [dstwidth,dsthight]=size(dst);%故需要计算的次数为表dst的大小
           xminend=xmin+dstwidth-1 ;
           yminend=ymin+dsthight-1 ;
           
            for i1=xmin:xminend
                for j1=ymin:yminend
                    temp=I1(i1:i1+mwidth-1,j1:j1+mhight-1);%获取参考模板图像  
                    temp_mask=double(temp)-double(mask);   %作残差
                    dst(i1-xmin+1,j1-ymin+1)=sum(sum(abs((temp_mask).*(temp_mask))));%记录残差大小   
                end   
            end 
            %toc;
            flag=0;
            abs_min=min(min(dst)); %查找最小残差 
            if isempty(dst)==false
                [x1,y1]=find(dst==abs_min);%获取最小残差的位置
                [wx,wy]=size(x1);%查看有几个最小值
                flag=0;
                if wx>=2||wy>=2  %如果有多个最小值，让flag记录下来，后面好对该平铺块对应的map位置置空
                    x=0;
                    y=0;
                    flag=1;
                else            %如果有一个最小值，
                   x=x1-1;      %因为dst中最小值位置为（1,1）时，表示平铺块木有移动
                   y=y1-1;      %故此时应该对x，y都减1，即位移实际为（0，0）
                end

                if i>1&&i<=h  %扩充的搜索范围是向四周扩充，但是平移求最小残差是从左上角开始计算，并且左上角作为原点
                    x=x-N1;   %故需要对位移进行转换
                end
                if j>1&&j<=w
                    y=y-N1;
                end
            else
                flag=1;
            end

            %I4(i,j)=round(sqrt(x*x+y*y));%求每个平铺块位移的大小
            if flag==0
                map0{i,j}=[x y]; %如果flag=0说明只有一个最小值
            else 
                map0{i,j}=[]; %如果flag=1说明有多个最小值，此时让对应map置空，后续通过周围位移计算
            end
            %Idis((mh+x):(mh+x+mwidth-1),(mw+y):(mw+y+mhight-1))=mask;%求缩放图像的对齐图像

        end
    end
    %toc;

    
    %到这里，map中有很多是空的cell，需要根据其周围的cell对齐进行填充
    new_map=filling_cell(map0);


    %————测试专用————
    % figure(4);
    % I4=I4/max(max(I4));
    % imshow(I4);
    % %imwrite(I4,'23333.jpg');

    %Idis=Idis(1:a,1:b);
    %DisplacementImg=I4;
    %toc;
end