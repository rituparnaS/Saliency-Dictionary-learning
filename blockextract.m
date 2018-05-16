function blockImg = blockextract(I1,blocksz)

[nr,nc,n] = size(rgb2gray(I1));

blockimg = zeros(nr,nc);

k=1;
for i=1:blocksz:nr-blocksz+1
    for j=1:blocksz:nc-blocksz+1
        blockimg(i:i+blocksz-1, j:j+blocksz-1) = k;
        k=k+1;
     end   
     if (j+blocksz-1<nc)
          blockimg(i:i+blocksz-1, j+blocksz:end) = k;   
         k=k+1;
    end

end
 if (i+blocksz-1<nr)
     for j=1:blocksz:nc-blocksz+1
          blockimg(i+blocksz:end, j:j+blocksz-1) = k;   
         k=k+1;
     end
     if ( j+blocksz-1<nc)
          blockimg(i+blocksz:end, j+blocksz:end) = k;   
         k=k+1;
     end
 end
blockImg = blockimg;
% imagesc(blockimg)





