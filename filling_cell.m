%       �����mapΪһ��cell�����п��ܺ���Ϊ[]��Ԫ�أ�
%       ���㷨������ΧcellԪ��ֵ��������ÿ�Ԫ�ص�ֵ��


function    new_cell=filling_cell(map)
    [w,h]=size(map);
    %map1=cell(w-2,h-2);
    map1=map(2:w-1,2:h-1);
    num_null=1;
    [w,h]=size(map1);%��ȡmap1�Ĵ�С
    %��������������¼map1��Ϊ�յ�cell������������
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
        x=record_null(i,1);%�˴�map1{x,y}һ��Ϊ�ա�ֻ���ж������������Ƿ�Ϊ��
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
        else  %���
            i_1=i-1;
            flag1=0;
            while i_1>0
                x1=record_null(i_1,1);
                y1=record_null(i_1,2);
                TorF=nullornot(map1,x1,y1);
                if TorF==0   %����Χ��Ϊ��
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

    %���������������������map����ΧһȦ��ע��˴�Ĭ��map�Ĵ�С����2*2
    [w,h]=size(map);%���»�ȡmap�Ĵ�С����Ϊ������w��h��ʾ��map1�Ĵ�С
    [w1,h1]=size(map1);%���»�ȡmap�Ĵ�С����Ϊ������w��h��ʾ��map1�Ĵ�С
    for i=1:w1
        for j=1:h1
            map{1+i,1+j}=map1{i,j};  
        end
    end
    %%%%%%%%%%%%%%%%���㷨��ȡ�ܱ�һȦ��0������%%%%%%%%%%%%%%%%%%
    for i=1:w
        map{i,1}=[0 0];
        map{i,h}=[0 0];
    end
    for i=1:h
        map{1,i}=[0 0];
        map{w,i}=[0 0];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����㷨��ȡ�ܱ�һȦ�����ܱߵڶ�Ȧ�ƶ�
    % %������������4���ǵ�����
    % map{1,1}=map1{1,1};
    % map{w,h}=map1{w1,h1};
    % map{1,h}=map1{1,h1};
    % map{w,1}=map1{w1,1};
    % 
    % for i=1:w1;%��
    %     map{1+i,1}=map1{i,1};
    %     map{1+i,h}=map1{i,h1};
    % end
    % 
    % for i=1:h1;%��
    %     map{1,1+i}=map1{1,i};
    %     map{w,1+i}=map1{w1,i};
    % end
    % 

    new_cell=map;
end