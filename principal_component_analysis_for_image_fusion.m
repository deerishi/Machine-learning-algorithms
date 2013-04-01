i1=geotiffread('tm-pan.tif');
i2=geotiffread('tmband.tif');
[m n]=size(i1);
i2=imresize(i2,[m n]);
figure,imshow(i1);
figure,imshow(i2);
b1=i2;
mi1=mean(i1);
mb1=mean(b1);

size(mi1);
meani1=ones(m,1)*mi1;
size(meani1)
transformed_i1=double(i1)- meani1;
meanb1=ones(m,1)*mb1;
transformed_b1=double(b1)-meanb1;

%transformed_i1=int(transformed_i1);
cov1=cov(double(transformed_i1),double(transformed_b1));
[v1,d1]=eig(cov1);
if d1(1,1)<d1(2,2)
    temp=v1(:,1);
    v1(:,1)=v1(:,2);
    v1(:,2)=temp;
end
prnciple_component11=v1(1,1)./(v1(1,1)+v1(2,1));
prnciple_component12=v1(2,1)./(v1(1,1)+v1(2,1));
fused(:,:,1)=(prnciple_component11*transformed_i1) + (prnciple_component12*transformed_b1);


figure,imshow(fused);
title('final fused image');
