%       输入的map为一个cell，其中可能含有为[]的元素，
%       该算法根据周围cell元素值，计算出该空元素的值，


function    new_cell=filling_cell(map)
    [w,h]=size(map);
    %map1=cell(w-2,h-2);
    map1=map(2:w-1,2:h-1);
    num_null=1;
    [w,h]=size(map1);%获取map1的大小
    %——————记录map1中为空的cell——————
    record_null=[];
    for i=1:w
       for j=1:h 
            if isempty(map1{i,j})==true
                record_null(num_null,1)=i;
                record_null(num_null,2)=j;
                num_null=num_null+1;
            end
       end
    end
    
    [resize,~]=size(record_null);
    while resize>0
        [resize,~]=size(record_null);
        i=ceil(resize/2);
        num1=0;
        sum1=[0 0];
        x=record_null(i,1);%此处map1{x,y}一定为空。只是判断其上下左右是否为空
        y=record_null(i,2);


        if isempty(map1{x,max(1,y-1)})==false
            sum1=sum1+map1{x,max(1,y-1)};
            num1=num1+1;
        end
        if isempty(map1{x,min(h,y+1)})==false
           sum1=sum1+map1{x,min(h,y+1)};
            num1=num1+1;
        end
        if isempty(map1{max(1,x-1),y})==false
            sum1=sum1+map1{max(1,x-1),y};
            num1=num1+1;
        end
        if isempty(map1{min(w,x+1),y})==false
            sum1=sum1+map1{min(w,x+1),y};
            num1=num1+1;
        end
        if num1~=0
           map1{x,y}=sum1/num1;
           %map1{x,y}=ceil(sum1/num1);
           a=record_null(1:i-1,:);
           a(i:resize-1,:)=record_null(i+1:resize,:);
           record_null=a;
        else  %如果
            i_1=i-1;
            flag1=0;
            while i_1>0
                x1=record_null(i_1,1);
                y1=record_null(i_1,2);
                TorF=nullornot(map1,x1,y1);
                if TorF==0   %其周围不为空
                    mid1=record_null(i_1,:);
                    record_null(i_1,:)=record_null(i,:);
                    record_null(i,:)=mid1;
                    flag1=1;
                    break;
                else
                    i_1=i_1-1;
                end
            end
            if flag1==0
                i_2=i+1;
                while i_2<=resize
                        x1=record_null(i_2,1);
                        y1=record_null(i_2,2);
                        TorF=nullornot(map1,x1,y1);
                        if TorF==0 
                            mid1=record_null(i_2,:);
                            record_null(i_2,:)=record_null(i,:);
                            record_null(i,:)=mid1;
                            break;
                        else
                            i_2=i_2+1;
                        end
                end
            end


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         if i-1~=0
    %             mid1=record_null(i-1,:);
    %             record_null(i-1,:)=record_null(i,:);
    %             record_null(i,:)=mid1;
    %         end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        [resize,~]=size(record_null);

    end

    %—————————填充map的周围一圈，注意此处默认map的大小大于2*2
    [w,h]=size(map);%重新获取map的大小，因为上面用w，h表示了map1的大小
    [w1,h1]=size(map1);%重新获取map的大小，因为上面用w，h表示了map1的大小
    for i=1:w1
        for j=1:h1
            map{1+i,1+j}=map1{i,j};  
        end
    end
    %%%%%%%%%%%%%%%%该算法采取周边一圈归0的运算%%%%%%%%%%%%%%%%%%
    for i=1:w
        map{i,1}=[0 0];
        map{i,h}=[0 0];
    end
    for i=1:h
        map{1,i}=[0 0];
        map{w,i}=[0 0];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%该种算法采取周边一圈根据周边第二圈移动
    % %——————4个角单独算
    % map{1,1}=map1{1,1};
    % map{w,h}=map1{w1,h1};
    % map{1,h}=map1{1,h1};
    % map{w,1}=map1{w1,1};
    % 
    % for i=1:w1;%行
    %     map{1+i,1}=map1{i,1};
    %     map{1+i,h}=map1{i,h1};
    % end
    % 
    % for i=1:h1;%行
    %     map{1,1+i}=map1{1,i};
    %     map{w,1+i}=map1{w1,i};
    % end
    % 

    new_cell=map;
end