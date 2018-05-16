% dictinary learnign with saliency wted and wt update


%clc
%clear all
%%%%%%%%%%%%%%%%%%%% dictionary learning with sift features

disp('job start \n')

datapath        = cd;
datafolder      = '/Bisque';%'/army190' ;%army_vehicles   ;'\camouflauge';
resultFolder    = '/results';
subfldrsup      = '/suppixmap'; % superpixels, saliency, features
%subfldrblck     = '/blocksmap'; % superpixels, saliency, features
subfldrdictSal  = '/dictSiftSal'; % dictionary SIFT with saliency, saliency update
%subfldrdictFull = '/dictSiftFull'; % dictionary full no saliency and saliency thresh
%subfldrdictBlk  = '/dictSiftBlk'; % dictionary with blocks full and saliency wt
% %subfldrdictG   = '/dictionaryGb'; % superpixels, saliency, features
imtype          = 'jpg';
numsuppixels    = 500;
%
%
add_utilities;
run(strcat(cd,'/Utilities/VLFEATROOT/toolbox/vl_setup.m'));

%[fileNames,subfolders,filenum] = readimgfilenames(datapath,datafolder,imtype);
%numimg = 10; % if numofimages not decided
%[trainfnameByclass,trainFnames,trainFilesgray,trainfilecolor] = readimgfiles(numimg,subfolders,fileNames);
%save(strcat(cd,resultFolder,datafolder,'/','filenames.mat'),'fileNames','filenum');

dpath      = strcat(cd,resultFolder,datafolder);
Supfeapath = strcat(dpath,subfldrsup,num2str(numsuppixels));
%Blckfeapath= strcat(dpath,subfldrblck,num2str(numsuppixels));
dpathSal   = strcat(dpath,subfldrdictSal,num2str(numsuppixels));
%dpathFull  = strcat(dpath,subfldrdictFull,num2str(numsuppixels));
%dpathBlck  = strcat(dpath,subfldrdictBlk,num2str(numsuppixels));
%load('allimgfiles.mat')
disp('first part done \n')
%%
regionSize   = 10
numOfzero    = 5
numzero    = strcat('%0',num2str(numOfzero),'d');
numsup     = numsuppixels;%floor((size(I_rsz,1)*size(I_rsz,2))/81);

%%
err1 = 0.0001;
paramsalnonthresh = struct('K',round(0.2*numsup),'L',round(0.04*numsup),'numIteration',50,...
    'errorFlag',1,'errorGoal',err1,'preserveDCAtom',0,'displayProgress',0,'sigma',1*regionSize);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

suppixfile = dir(strcat(Supfeapath));
k=1;
for i=1:1:length(suppixfile)
    if (suppixfile(i).bytes~=0)
        datafile{k} = strcat(Supfeapath,'/',suppixfile(i).name);
        k=k+1;
    end
end
disp('read file done \n')

parfor imgnum=1:1:length(datafile)
    %imgnum
    varpar{imgnum} = computeparallelGdict(datafile, imgnum,dpathSal,paramsalnonthresh,numzero);     
    %clear('fea')

end

% 
% imshow(salI)
% figure(); 
% displaySalwt(segImg,D_salW.weightF)
% figure()
% imagesc(colorContrastMap); colormap('gray')
%
%
%
%     clear ('segImg','sift_sup','salI','fea_mLab','salval','I_blcky','featuresBlck','sift_blck','salIB','fea_mLabB','salvalB',...
%         'I_rszC','sfeat','sdesc','sift_blck','sift_sup','reg_stats','reg_stats_blck','I')
%
%%

% for i=1:1:100
% displaySalwt(segImg,(siftD_salW.upW(:,i)))
% pause
% end

