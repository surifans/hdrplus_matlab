%       ����cell�е�һ����Ԫ��a���ж�a��Χ���������Ƿ�Ϊ�գ�TorFΪtrue��Ϊ�գ�����Ϊ��
%       b����a����������Ԫ�ص�ƽ��ֵ
%       ע��˴�x,y���Ѿ���map1�ж�ȡ��Ϊ�յ����꣬�ʲ����ж�x��y�Ƿ����Խ��
%       �˴��Ѿ�Ĭ����map{x,y}Ϊ��
%       map1Ϊһ��cell��Ԫ�أ�����Ϊ�գ�x��yΪ���Ӧ������

function  TorF=nullornot(map1,x,y)
    num1=0;
    %sum=[0 0];
    [w,h]=size(map1);%��ȡmap1�Ĵ�С
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
    if num1~=0   %�ǿ�
       %b=sum/num1;
       TorF=0;
    else 
       TorF=1;%Ϊ��
    end
end