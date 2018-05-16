% dictinary learnign with saliency wted and wt update


%clc
%clear all
%%%%%%%%%%%%%%%%%%%% dictionary learning with sift features

disp('job start \n')
imtype          = 'jpg'
numsuppixels    = 500
datapath        = cd;
datafolder      = '/Bisque';%'/army190' ;%army_vehicles   ;'\camouflauge';
resultFolder    = '/results';
%subfldrsup      = '/suppixmap'; % superpixels, saliency, features
subfldrsim     = strcat('/scratch/rs9vj',datafolder,'/dictsim'); % superpixels, saliency, features
subfldrdictSal  = '/dictSiftSal'; % dictionary SIFT with saliency, saliency update
%subfldrdictFull = '/dictSiftFull'; % dictionary full no saliency and saliency thresh
%subfldrdictBlk  = '/dictSiftBlk'; % dictionary with blocks full and saliency wt
% %subfldrdictG   = '/dictionaryGb'; % superpixels, saliency, features

mkdir(subfldrsim)
%
%
add_utilities;
%run(strcat(cd,'/Utilities/VLFEATROOT/toolbox/vl_setup.m'));

%[fileNames,subfolders,filenum] = readimgfilenames(datapath,datafolder,imtype);
%numimg = 10; % if numofimages not decided
%[trainfnameByclass,trainFnames,trainFilesgray,trainfilecolor] = readimgfiles(numimg,subfolders,fileNames);
%save(strcat(cd,resultFolder,datafolder,'/','filenames.mat'),'fileNames','filenum');

dpath      = strcat(cd,resultFolder,datafolder);
%Supfeapath = strcat(dpath,subfldrsup,num2str(numsuppixels));
%Blckfeapath= strcat(dpath,subfldrblck,num2str(numsuppixels));
dpathSal   = strcat(dpath,subfldrdictSal,num2str(numsuppixels));
%dpathFull  = strcat(dpath,subfldrdictFull,num2str(numsuppixels));
% 
dpathsim  = subfldrsim ;

%load('allimgfiles.mat')
disp('first part done \n')

%%
numOfzero    = 5
regionSize   = 10
numzero    = strcat('%0',num2str(numOfzero),'d');
numsup     = numsuppixels;
err1 = 0.0001;
paramsalnonthresh = struct('K',round(0.2*numsup),'L',round(0.04*numsup),'numIteration',50,...
    'errorFlag',1,'errorGoal',err1,'preserveDCAtom',0,'displayProgress',0,'sigma',1*regionSize);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dictfile = dir(strcat(dpathSal));
k=1;
for i=1:1:length(dictfile)
    if (dictfile(i).bytes~=0)
        datafile{k} = strcat(dpathSal,'/',dictfile(i).name);
        k=k+1;
    end
end
load('allimgfilesMiCi_testtrain.mat');

disp('load done \n')
% savefname = strcat(subfldrsim,'/','exampl','.mat')
% save(savefname,'test_data')
%%

parfor datanum=30:1:length(test_data)
 
    dataid(datanum) = test_data(datanum);
    dataid(datanum)
    type = 2; % type = 1--> datasaliency; type = 2--> updatedsaliency; type = 3 
    res{datanum} = computeParForSimi(datafile,dataid(datanum),dpathsim,paramsalnonthresh,numzero,type,train_data); 
  
end


  %disp('parfor_end \n');
