function r = parallelGabor(trainfilecolor,imgnum,block_size,Supfeapath,numzero,param,params_gabor)

% =============================================================================%
%This function computes the gabor features of an image, superpixel
%segmentation, saliency calculation for each superpixel, 
% Input: 
            % trainfilecolor = cell containing all the images read from a directory 
            % imgnum         = the image number to be read from a trainfilecolor
            % block_size     = approximate size of superpixel (8 or 10...)
            % Supfeapath     = path where the variables will be stored
            % numzero        = num of digits for the file name
            % param          = other parameters related to calculation
            % params_gabor   = gabor filter parameters

% Output: saves the following variables in the spefied directoty
            % 'segImg     = the superpixel segmented image
            % 'G_feaL'    = Gabor fea mean for the full image 
            % 'gabor_fea' = Gabor fea for each superpixel
            % 'salI'      = Saliency image
            % 'fea_mLab'  = LAB color feature for each superpixel
            % 'salval'    = saliency values in vector
            % 'I_rszC'    = resized (based on superpixel size) color image
            % 'W'         = Adjacency matrix for graph
            % 'optAff'    = optimal affinity matrix of the graph
            % 'weights'   = edge weights of a graph
            % 'edges'     = graph edges
% Some of the graph functions are borrowed from http://faculty.ucmerced.edu/mhyang/project/cvpr13_saliency/cvprsaliency.htm
% related to the paper "Saliency Detection via Graph-based Manifold
% Ranking". these functiosn are required only for SDLs (dictionary learning
% by saliency weight update).
% =============================================================================%

I1 = trainfilecolor{imgnum};
[h, w, ch] = size(I1);
% image resizing and obtaining size of superpixel
if (h>300 || w>300)
    if h>w
        I = imresize(I1, [256, 256*w/h]);
    elseif w>h
        I = imresize(I1, [256*h/w, 256]);
    end
else
    I = I1;
end
[h1, w1, d1] = size(I);
len          = block_size*floor(w1/block_size);
ht           = block_size*floor(h1/block_size);
I_rszC       = imresize(I,[ht,len]);
if ch==3
    I_rsz    = rgb2gray(I_rszC);
end
regionSize = block_size;

if ((size(I_rsz,1))*(size(I_rsz,2))/(regionSize*regionSize)<100)
    regionSize = ceil(sqrt((size(I_rsz,1))*(size(I_rsz,2))/156));
end

%%%%%%%%%%%%% slic segmentation, need VL_feat for this %%%%%%%%%%%%%%%%%%%
regularizer = 0.1 ;
im = im2single(I_rsz);
segments = vl_slic(im, regionSize, regularizer) ;
segImg   =  double(segments+1);
numsuppix     = max(segImg(:));
reg_stats     = regionprops(segImg,'all');
spnum         = max(segImg(:));

%disp('superpixel Done')

%%%%%%%%%%%%%%%%%%%%%%% Saliency map calculation  %%%%%%%%%%%%%%%%%%%%%%%%
param.Img     = I_rszC;
param.stats   = reg_stats;
param.segI    = segImg;
param.dispI   = I_rszC;
param.sigma   = 3*regionSize;

[salI,colorContrastMap,fea_mLab,salval]  = contrastMap_1(param);

%%%%%%%%%%%%%%%%%%%%%%% feature extraction  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[gabor_fea, gabor_img]   = gaborfeatureSegs(I,segImg,params_gabor);
G_feaL                   = [gabor_fea.mean];%;gabor_fea.var];

%%%%%%%%%%%%%%%%%%%%%%% graph adjacecy computation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

adjloop=AdjcProcloop(segImg,spnum);
edges=[];
for i=1:spnum
    indext=[];
    ind=find(adjloop(i,:)==1);
    for j=1:length(ind)
        indj=find(adjloop(ind(j),:)==1);
        indext=[indext,indj];
    end
    indext=[indext,ind];
    indext=indext((indext>i));
    indext=unique(indext);
    if(~isempty(indext))
        ed=ones(length(indext),2);
        ed(:,2)=i*ed(:,2);
        ed(:,1)=indext;
        edges=[edges;ed];
    end
end
theta=10;
alpha = 0.9;
weights = makeweights(edges,fea_mLab(:,[1:3]),theta);
W = adjacency(edges,weights,spnum);

%%%%%%%%%%%%%%%%% optimal affinity matrix
dd = sum(W); D = sparse(1:spnum,1:spnum,dd); clear dd;
optAff =(D-alpha*W)\eye(spnum); 
mz=diag(ones(spnum,1));
mz=~mz;
optAff=optAff.*mz;

%%%%%%%%%%%%%%%%% save variables %%%%%%%%%%%%%%%
savefnameFea   = strcat(Supfeapath,'/','supfea',...
    num2str(imgnum,numzero),'.mat');

save(savefnameFea,'segImg','G_feaL','gabor_fea','salI','fea_mLab','salval','I_rszC','W','optAff','weights','edges');

r =  savefnameFea;
clear ('segImg','salI','fea_mLab','salval','I_rszC','reg_stats','I');