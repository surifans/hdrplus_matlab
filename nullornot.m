%       输入cell中的一个空元素a，判断a周围上下左右是否为空，TorF为true则为空，否则不为空
%       b返回a的上下左右元素的平均值
%       注意此处x,y是已经从map1中读取的为空的坐标，故不用判断x，y是否存在越界
%       此处已经默认了map{x,y}为空
%       map1为一个cell中元素，可能为空，x，y为其对应的坐标

function  TorF=nullornot(map1,x,y)
    num1=0;
    %sum=[0 0];
    [w,h]=size(map1);%获取map1的大小
    if isempty(map1{x,max(1,y-1)})==false
        %sum=sum+map1{x,max(1,y-1)};
        num1=num1+1;
    end
    if isempty(map1{x,min(h,y+1)})==false
       %sum=sum+map1{x,min(h,y+1)};
        num1=num1+1;
    end
    if isempty(map1{max(1,x-1),y})==false
        %sum=sum+map1{max(1,x-1),y};
        num1=num1+1;
    end
    if isempty(map1{min(w,x+1),y})==false
        %sum=sum+map1{min(w,x+1),y};
        num1=num1+1;
    end
    if num1~=0   %非空
       %b=sum/num1;
       TorF=0;
    else 
       TorF=1;%为空
    end
end