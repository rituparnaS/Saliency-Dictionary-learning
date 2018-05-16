function sal_suppiximpose = overlapSalmap(segImg,numsuppix,salmap,method)

data.suppixImg = segImg;
data.sal       = salmap;

sal_suppiximpose = zeros(size(data.sal));

for i=1:1:numsuppix
    
    mask      = zeros(size(data.sal));
    inter_img =  zeros(size(data.sal));
    reg       =  find(data.suppixImg==i);
    area(i)   = length(reg);
    % replace by mean intensity
    %mask(find(data.suppixImg==i))= 1;
    mask      = (segImg==i);
    (mask>0)   == 1;
    if method == 1
       
        salval(i,1)                  = sum(data.sal((mask==1)))/area(i);
    else if method ==2
           
            salval(i,1)              = max(data.sal((mask==1)));
        else if method ==3
                salval(i,1)          = median(data.sal((mask==1)));
            end
        end
    end
    inter_img((mask==1))     = salval(i,1);
    sal_suppiximpose             = sal_suppiximpose  + inter_img;
end
%figure()
%imagesc(sal_suppiximpose)