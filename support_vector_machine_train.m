function [model] = svmTrain(X, Y, C, kernelFunction, ...
                            tol, max_passes)
%SVMTRAIN Trains an SVM classifier using a simplified version of the SMO 
%algorithm. 
%   [model] = SVMTRAIN(X, Y, C, kernelFunction, tol, max_passes) trains an
%   SVM classifier and returns trained model. X is the matrix of training 
%   examples.  Each row is a training example, and the jth column holds the 
%   jth feature.  Y is a column matrix containing 1 for positive examples 
%   and 0 for negative examples.  C is the standard SVM regularization 
%   parameter.  tol is a tolerance value used for determining equality of 
%   floating point numbers. max_passes controls the number of iterations
%   over the dataset (without changes to alpha) before the algorithm quits.
%tol = 1e-3;
eps=1e-5;
%max_passes = 10;
m=size(X,1);
n=size(X,2);
alpha=zeros(m,1);
b=0;
E=zeros(m,1);
passes=0;
L=0;
H=0;
W=zeros(1,m);
number_of_changed_alphas=0;
%in this first svm training algo we will select he alpas randonmly
while(passes<max_passes)
for i=1:m
    wx=0;
    for h=1:m
        k=kernal(X(i),X(h),kernelFunction);%kernal function is defined below
        wx=wx+ alpha(h)*Y(h)*k;
    end
   
    E(i)=b+wx-Y(i);
    if ((Y(i)*E(i) < -tol && alphas(i) < C) || (Y(i)*E(i) > tol && alphas(i) > 0))
        while(1)
            j=randi(m,1);
            if(j~=i)
                break
            end
        end
        wx=0;
       for h=1:m
        k=kernal(X(j),X(h),kernelFunction);%kernal function is defined below
        wx=wx+ alpha(h)*Y(h)*k
       end
       E(j)=b+wx-Y(j);
       %saving the old alphas
       alpha1=aplha(i);
       alpha2=alpha(j)
       
       %finding the upper and lower bounds for alphas
       if(Y(i)==Y(j))
           L=max(0,alpha1+alpha2-C);
           H=min(C,alpha1+alpha2);
       else
           L=max(0,alpha2-alpha1);
           H=min(C,C+alpha2-alpha1);
       end
       if(L==H)
        continue;
       end
       s=Y(i)*Y(j);
       k1=kernal(X(i),X(i),kernelFunction);
       k2=kernal(X(j),X(j),kernelFunction);
       k3=kernal(X(i),X(j),kernelFunction);
       
       eta=k1+k2-2*k3;
       if(eta>0)
            alpha(j)=alpha(j)+ Y(j)*((E(i)-E(j))/eta);
         if(alpha(j)>=H)
               alpha(j)=H;
         elseif(alpha(j)<=L)
               alpha(j)=L;
         else
             alpha(j)=alpha(j);
            end
       
       else(eta<=0)
           f1=Y(i)*(E(i)+b)-alpha(i)*k1-s*alpha(j)*k3;
           f2=Y(j)*(E(j)+b)-s*alpha(i)*k3-alpha(j)*k2;
           L1=alpha(i)+s*(alpha(j)-L);
           H1=alpha(i)+s*(alpha(j)-H);
           obj_L=L1*f1+L*f2+(0.5*L1*L1*k1)+(0.5*L*L*k2)+s*L*L1*k3;
           obj_H=H1*f1+H*f2+(0.5*H1*L1*k1)+(0.5*H*H*k2)+s*H*H1*k3;
            
           if(obj_L<obj_H-eps)
               alpha(j)=L;
           elseif(obj_L>obj_H+eps)
               alpha(j)=H;
           else
               alpha(j)=alpha(j);
           end
       end
       if(abs(alpha(j)-alpha2)<eps)
           alpha(j)=alpha2;
           continue;%because there is no point going further and calculating alpha1
       end
       alpha(i)=alpha1+s*(alpha2-alpha(j));
       %now we update the b paramaters
       b1=E(i)+Y(i)*(alpha(i)-alpha1)*k1+Y(j)*(alpha(j)-alpha2)*k3+b;
       b2=E(j)+Y(i)*(alpha(i)-alpha1)*k3+Y(j)*(alpha(j)-alpha2)*k2+b;
       
       if(0<alpha(i)<C && 0<alpha(j)<C)
           b=(b1+b2)/2;
       elseif(0<alpha(i)<C)
           b=b1;
       elseif(0<alpha(j)<C)
           b=b2;
       end
       
      
       %now we update the weight parameters taking only into account linear
       %SVM's
       W=W+Y(i)*(alpha(i)-alpha1)*X(i)+Y(j)*(alpha(j)-alpha2)*X(j)
 
       number_of_changed_alphas=number_of_changed_alphas+1;
    end
end
if(number_of_changed_alphas==0)
    passes=passes+1;
else
    passes=0;
end
end
model.W=W;
model.alpha=alpha;
model.b=b;
end
function [kernal_value]=kernal(x1,x2,kernelFunction)
ktmp=0
if(strcmp('linearKernel',kernelFunction)==1)
    ktmp=x1'*x2;
elseif(strcmp('gaussianKernel',kernelFunction)==1)
    sigma=10;
    [m n]=size(x1);
    for i=1:n
        u=(x1(m,i)-x2(m,i))*(x1(m,i)-x2(m,i));
        ktmp=ktmp+exp((-1*u*0.5)/(sigma*sigma));
    end
else%default kernal function is linear kernal
    ktmp=x1'*x2;
end
    kernal_value=ktmp;
end



       
       
       
             
               
      
      
               
                   
                   
           


       

    

