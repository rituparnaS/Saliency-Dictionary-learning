function [mcoherence, innerprod]= mutualCoherence(D1,D2)


%n1 = size(D1,2);
%n2 = size(D2,2);

d1d1_innerprod  = (D1'*D2);
innerprod = d1d1_innerprod ;
mcoherence(1,1) = max(d1d1_innerprod(:));
mcoherence(1,2) = mean2(d1d1_innerprod);
mcoherence(1,3) = min(d1d1_innerprod(:));




     