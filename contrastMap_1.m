function [salI,colorContrastMap,fea_mLab,salval,wt_pij,col_contW] = contrastMap_1(param)

% ===================================================================== %
% the function calculates saliency based on local contrast of superpixels
% and LAB color features
% Input:  param (structure) for the color image, superpixels, superpixel parameters, 
% Output:
% salI             = Saliency image
% colorContrastMap = Image for color distance between superpixels
% fea_mLab         = Color feature of a superpixel LAB and RGB concatenated
% salval           = Vectorized saliency for each superpixel
% wt_pij           = Euclidean dictance between superpixel (non-normalized)
% col_contW        = color distance only between superpixels vector
% ===================================================================== %

I1         =  param.Img;  % Image 
reg_stats  = param.stats; % region property
segImg1    = param.segI;  % image segmentation 
disp_img   = param.dispI; % image reading
spnum1     = max(segImg1(:));
I1         = im2double(I1);
[m,n,z]    = size(I1);
if z==3
    I2  = rgb2gray(I1);
    colorTransform = makecform('srgb2lab');
    labImg = applycform(I1, colorTransform);
else
    I2 = I1;
end
%%%% region statistics for superpixels
reg_area = reshape([reg_stats.Area],size(reg_stats));
if (reg_area == 0)
replc = find(reg_area == 0);
reg_stats(replc).Centroid=0;
end
%% --------------------------region centres -----------------------------
sigma = param.sigma;%0.25*min(m,n)

% Euclidean dictance between  superpixel
for i=1:1:spnum1
    for j=1:1:spnum1
        centre_dist(i,j,:) = sum((reg_stats(i).Centroid - reg_stats(j).Centroid).^2);
    end
end
wt_pij = exp((-centre_dist)/(2*sigma^2));
%wt_pij(find(isnan(wt_pij)))=0;
wt_pijnorm = wt_pij./repmat((sum(wt_pij,1)),spnum1,1);
%% ---------------------------color features-------------------------------
% compute LAB and RGB color features for each superpixel
labI  = reshape(labImg, m*n,z);
rgbI = reshape(I1, m*n,z);
grayI = reshape(I2, m*n,1);

for i=1:1:spnum1
    inds{i}        = find(segImg1==i);
    rgb_vals(i,1,:)= mean(rgbI(inds{i},:),1);    
end
lab_vals = colorspace('Lab<-', rgb_vals); 
clab_1=reshape(lab_vals,spnum1,3);
crgb_1=reshape(rgb_vals,spnum1,3);
fea_mLab = [clab_1 crgb_1]; % RGB if required else can be deleted

% Euclidean distance between mean colors of superpixels 
c_1 = clab_1;
for i=1:1:spnum1
    for j=1:1:spnum1
        colr_dist(i,j) = sum((c_1(i,:) - c_1(j,:)).^2); %c_i previous
    end
end
sigma_2 = 5;
wt_cij = exp((-sqrt(colr_dist)));
wt_cijnorm = wt_cij./repmat(sum(wt_cij,1),spnum1,1);

% color contrast
for i=1:1:spnum1
    col_dst(:,i)  = colr_dist(:,i);
    w_pi(:,i)         = wt_pij(:,i);
    col_contppix = (col_dst(:,i).*w_pi(:,i));
    col_contW(:,i) = col_dst(:,i);
    col_contrast(1,i) = sum(col_contppix(:,1));
end
Sal_i            = col_contrast;

%% ------------------------color weighted position; position contrast---------------
if param.poscont %(if position function is included) 
    for j=1:1:spnum1
        pos_j               = reg_stats(j).Centroid;
        cdist_j             = wt_cijnorm(:,j);
        wtd_position(:,j,1) = (pos_j(1)*cdist_j);
    end
    mu_pwtd(1,:) = sum(wtd_position(:,:,1),1);
    for i=1:1:spnum1
        for j=1:1:spnum1
            pos_diff(i,j) =  sum((reg_stats(j).Centroid'-mu_pwtd(:,i)).^2);
        end
    end
    
    for i=1:1:spnum1
        pos_cont(:,i) = pos_diff(:,i).*wt_cijnorm(:,i);%centre_dist(:,i).*wt_cijnorm(:,i);
        pos_contrast(1,i) = (sum(pos_cont(:,i)));
    end
    pos_contr = exp(-0.005*pos_contrast);
    Sal_i = pos_contr.*col_contrast;
end
%% If position and color saliency are combined
alpha = 1/10;
beta = 1/10; 
w_ij = alpha*centre_dist+beta*colr_dist;
% weight function for color and position
wt_ij = exp(-w_ij)./repmat(sum(w_ij,1),spnum1,1);
%% sal local
for i=1:1:spnum1
    [val(:,i) ind(:,i)] = sort(centre_dist(:,i),'ascend');
    wt_ijtemp(:,i)  = (wt_ij(ind(:,i),i));
    % weight the color saliency using color and position wt_ij can be made
    % constant
    sal_tmp(:,i)    = (Sal_i(1,ind(:,i)))'.*wt_ijtemp(:,i);
    sal_img(1,i)    = sum(sal_tmp(:,i));
end

% normalize saliency
sal_final = (sal_img-min(sal_img))/(max(sal_img)-min(sal_img));
salval = sal_final;

%% display and map to image
% Initialize saliency image
I_dispcolcontr  = zeros(size(segImg1)); % just LAB/RGB color contrast
I_dispposcontr = zeros(size(segImg1));  % position contrast : not used in the paper
I_dispsalcontr = zeros(size(segImg1));  % saliency position weighted color
I_dispinitsal  = zeros(size(segImg1));
% map the saliency to image
for i=1:1:spnum1
    I_dispcolcontr(segImg1==i)     = col_contrast(1,i);
    if param.poscont==1
        I_dispposcontr(segImg1==i) = pos_contr(1,i);
    end
    I_dispsalcontr(segImg1==i)     = sal_final(1,i);
    I_dispinitsal(segImg1==i)      = Sal_i(1,i);
end
salI             = I_dispsalcontr;
colorContrastMap = I_dispcolcontr;

if param.disp==1 % (display the saliency image when computing)
    subplot(1,5,1)
    imshow(disp_img),
    subplot(1,5,2),
    imagesc(I_dispcolcontr), colormap('gray'); title('color contrast');
    subplot(1,5,4)
    imagesc(I_dispsalcontr), colormap('gray'); title('saliency');
    subplot(1,5,5)
    imagesc(I_dispinitsal), colormap('gray'); title('Init saliency');
end
