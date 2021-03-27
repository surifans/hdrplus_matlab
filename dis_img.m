%       mapx��mapyΪÿ������Ӧ���ƶ���λ��ֵ��mapxΪ�����귽��mapyΪ�����귽��
%       ImgΪ���ƶ���ԭͼ
%       IdisΪ�ƶ����ͼ
%       

function  [Idis,mask]=dis_img(mapx,mapy,Img)
    [w,h]=size(Img);
    nn=160;
    Id=zeros(w+2*nn,h+2*nn);
    Id=Id-1;
    
    
    
    for i=1:w
        for j=1:h
            a=Img(i,j);
            Id(nn+i+mapx(i,j),nn+j+mapy(i,j))=a;
            
        end
    end
    Idis=Id(nn+1:nn+w,nn+1:nn+h);
    
    Imask0=zeros(w,h);
    Imask0(find(Idis(:,:)<0))=255;
    mask=uint8(Imask0);
end