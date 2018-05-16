function [A]=OMPerrSal(D,X,errorGoal,w)
%=============================================
% Sparse coding of a group of signals based on a given 
% dictionary and specified number of atoms to use., 
% while weighing the reconstruction error with saliency values  
% input arguments: D - the dictionary
%                  X - the signals to represent
%                  errorGoal - the maximal allowed representation error for
%                  each siganl.
%                  w - saliency weights
% output arguments: A - sparse coefficient matrix.
%=============================================
[n,P]=size(X);
[n,K]=size(D);
E2 = errorGoal^2*n;
maxNumCoef = n/2;
A = sparse(size(D,2),size(X,2));
for k=1:1:P,
    a=[];
     x=X(:,k);
%     residual=x;
    residual=X(:,k);
	indx = [];
	a = [];
	currResNorm2 = sum(residual.^2);
	j = 0;
  %  wD = w(k,k)*D;
  wD = D;
    while currResNorm2>E2 && j < maxNumCoef,
		j = j+1;
        proj=wD'*residual;
        pos=find(abs(proj)==max(abs(proj)));
        pos=pos(1);
        indx(j)=pos;
        a=pinv(wD(:,indx(1:j)))*x;
%         residual=x-wD(:,indx(1:j))*a;
        residual=w(k,k)*(X(:,k)-D(:,indx(1:j))*a);
		currResNorm2 = sum(residual.^2);
      
   end;
   if (length(indx)>0)
       A(indx,k)=a;
   end
end;
return;
