% mixing 2 sources
[xs1,fs1]=wavread('s1.wav');
[xs2,fs2]=wavread('s2.wav');
%a=mixing matrix
a=[5 14;42 33];
xm1=a(1,1).*xs1+a(1,2).*xs2;
xm2=a(2,1).*xs1+a(2,2).*xs2;
x=[xm1;xm2];
xx=x;
%centering by subtracting the mean
ex=mean(x);
size(ex);
[m1,n1]=size(x);
x=x-ex*ones(m1,n1);
mean_x=mean(x);
disp('the mean now is =\n');
mean_x
%set the corellation to zero
corx=corr(x);
corx=sqrtm(corx);
corx=inv(corx);
x=corx*x;
disp('size of xfinal is =');
xfinal=xx;
size(xfinal)
%now the preprocesing is complete,
%initialize the W matrix, i.e. the inverse of the mixing matrix
w=[1 0;0 1];
%inializing the learing rate L
l=0.01;
[m,n]=size(xfinal);%n=1
%assuming the cdf for the mixed sound to be a sigmoid function
%1/(1+exp(-s))
for i=1:2:m 
            %sizew=size(w(j,:));
            xp=[x(i);x(i+1)];
            e1=1-(2/(1+exp(-1*(w(1,:)*xp))));
            e2=1-(2/(1+exp(-1*(w(2,:)*xp))));
            k=[e1;e2]; 
    %[sizevm,sizevn]=size(k);
   % [sizexm,sizexn]=size(x);
   %update the unmixing matrix
        w = w + l*(k*xp' + ((w')^-1));
   
end 
%now  the inverse matrix w has been computed
%computing back the sources
s1=w(1,1)*xm1+w(1,2)*xm2;
s2=w(2,1)*xm1+w(2,2)*xm2;
disp('sucessfully completed');
