function []= displaySalwt(segImg,weight)

salientImg = zeros(size(segImg));
%nnWt1 = (nWt1.^2)/sum(nWt1);

%nnWt1 = (weight-min(weight))/(max(weight)-min(weight));

for i=1:1:max(segImg(:))
    %salientImg(Data.segImg==i) = prinsquared(i,1);
   salientImg(segImg==i) = (weight(i));
end

%subplot(2,1,2)
%plot(weight) 
% subplot(2,2,2)
 imagesc(salientImg),colormap(gray),axis off