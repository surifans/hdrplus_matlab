%       map是全图每个像素移动的位移
%       map1为当前级图块移动的位移
%       n为缩放倍数
%       N为划分的图块大小



function   [new_mapx,new_mapy]=Calcudismap(mapx,mapy,map1,n,N)%I是作为参考帧
    [w,h]=size(map1);
    mapax=zeros(w*n*N,h*n*N);
    mapay=zeros(w*n*N,h*n*N);
    for i=1:w
        for j=1:h
            a=zeros(n*N,n*N);
            b=zeros(n*N,n*N);
            a=a+map1{i,j}(1,1);
            b=b+map1{i,j}(1,2);
            mapax((i-1)*n*N+1:i*n*N,(j-1)*n*N+1:j*n*N)=a;
            mapay((i-1)*n*N+1:i*n*N,(j-1)*n*N+1:j*n*N)=b;
        end
    end
    %tic;
    [w,h]=size(mapx);
    mapx1=mapx+floor(n*mapax(1:w,1:h));
    mapy1=mapy+floor(n*mapay(1:w,1:h));
    
    new_mapx=mapx1;
    new_mapy=mapy1;

end