%%%%%%%%%%%%%%%%%%% File for creating directories, superpixel-gabor features, image
%%%%%%%%%%%%%%%%%%% saliency and storing them in a file at a given location

clc
clear all
add_utilities;
run(strcat(cd,'/Utilities/VLFEATROOT/toolbox/vl_setup.m'));
datapath        = cd;
datafolder      = '/Bisque' ;% path where images are saved
resultFolder    = '/results';
subfldrsup      = '/suppixmap'; % superpixels, saliency, features
%subfldrblck     = '/blocksmap'; % superpixels, saliency, features
subfldrdictSal  = '/dictSal'; % dictionary SIFT with saliency, saliency update
subfldrdictFull = '/dictFull'; % dictionary full no saliency and saliency thresh
%subfldrdictBlk  = '/dictSiftBlk'; % dictionary with blocks full and saliency wt
% %subfldrdictG   = '/dictionaryGb'; % superpixels, saliency, features
imtype          = 'jpg';
numsuppixels    = 500;
%
% 
mkdir(strcat(datapath,resultFolder,datafolder))
mkdir(strcat(datapath,resultFolder,datafolder,subfldrsup,num2str(numsuppixels)))
%mkdir(strcat(datapath,resultFolder,datafolder,subfldrblck,num2str(numsuppixels)))
mkdir(strcat(datapath,resultFolder,datafolder,subfldrdictSal,num2str(numsuppixels)))
mkdir(strcat(datapath,resultFolder,datafolder,subfldrdictFull,num2str(numsuppixels)))
%mkdir(strcat(datapath,resultFolder,datafolder,subfldrdictBlk,num2str(numsuppixels)))



%% uncomment if you need to read images from a folder
%[fileNames,subfolders,filenum] = readimgfilenames(datapath,datafolder,imtype);
%numimg = 10; % numofimages for training 
%[trainfnameByclass,trainFnames,trainFilesgray,trainfilecolor] = readimgfiles(numimg,subfolders,fileNames);
%save(strcat(cd,resultFolder,datafolder,'/','filenames.mat'),'fileNames','filenum');

%% define paths
dpath      = strcat(cd,resultFolder,datafolder);
Supfeapath = strcat(dpath,subfldrsup,num2str(numsuppixels));
%Blckfeapath= strcat(dpath,subfldrblck,num2str(numsuppixels));
dpathSal   = strcat(dpath,subfldrdictSal,num2str(numsuppixels));
dpathFull  = strcat(dpath,subfldrdictFull,num2str(numsuppixels));
%dpathBlck  = strcat(dpath,subfldrdictBlk,num2str(numsuppixels));

load('allimgfilesBisque.mat')

disp('load done \\n');

%%
numOfzero     = 5;
numzero       = strcat('%0',num2str(numOfzero),'d');
numsup        = numsuppixels;
block_size    = 8;
param.poscont = 0;
param.disp    = 0;

params_gabor   = struct('stage',4, 'orientation',8,...
    'Ul',0.05, 'Uh',0.4, 'flag',0);


%% %%%%%%%%%%%%%%% Can run this in parallel for each image for feature %%%%%%%%%%%%%%%
for imgnum=1:1:length(trainfilecolor)    
    r{imgnum} = parallelGabor(trainfilecolor,imgnum,block_size,Supfeapath,numzero,param,params_gabor);   
end

%% %%%%%%%%%%%%%%%% Running for learning dictionary %%%%%%%%%%%%%%%%%%%%%%%%
% Dictionary learning paramters
err1 = 0.0001;
paramsalnonthresh = struct('K',round(0.2*numsup),'L',round(0.04*numsup),'numIteration',50,...
    'errorFlag',1,'errorGoal',err1,'preserveDCAtom',0,'displayProgress',0,'sigma',1*regionSize);

suppixfile = dir(strcat(Supfeapath)); % path to read the superpixels and saliency
k=1;
for i=1:1:length(suppixfile)
    if (suppixfile(i).bytes~=0)
        datafile{k} = strcat(Supfeapath,'/',suppixfile(i).name);
        k=k+1;
    end
end
disp('read file done \n')

 %%%% the dictionary for each image can be computed parallelly %%%%%%
parfor imgnum=1:1:length(datafile)
    varpar{imgnum} = computeparallelGdict(datafile,imgnum,dpathSal,paramsalnonthresh,numzero);     
end


