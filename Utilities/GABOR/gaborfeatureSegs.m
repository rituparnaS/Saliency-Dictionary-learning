function [gabor_fea,gabor_fullimg]  = gaborfeatureSegs(I,segImg,params)

% ================================================================ %
% Compute gabor features for superpixels. 

% Paper: Texture Features for Browsing and Retrieval of Image Data
% ================================================================ %

[L,C,ch]=size(I); % L num of lines ; C num of columns
if ch==3
    Im = rgb2gray(I);
else
    Im = I;
end
numofseg    = max(segImg(:));

[F,D] = GaborFeatures_new(Im, params.stage, params.orientation, params.Ul, ...
     params.Uh, params.flag);
 
 gabor_fullimg = F;

% for each superpixel
 lenD = length(D);
 for i=1:1:numofseg
    
    mask       = (segImg==i);
   (mask>0)    == 1;
    msk        = mask(:);
    D_masked   = zeros(length(D{1}(msk>0)),lenD);
   
    for j=1:1:lenD
        D_masked(:,j) = D{j}(msk>0);
    end
       
    meanofD(:,i) = max(D_masked) ; 
    varofD(:,i)  = var(D_masked,1);
    
 end
 
 gabor_fea.mean = meanofD;
 gabor_fea.var  = varofD;
 
 
 
 
 
 
 
    