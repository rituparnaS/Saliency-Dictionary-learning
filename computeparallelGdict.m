function var = computeparallelGdict(datafile, imgnum,dpathSal,paramsalnonthresh,numzero)

% ================================================================ %
% Computes the dictionary learning for each image separately

% ================================================================ %

load(datafile{imgnum})
imgnum
fea            = [(fea_mLab(:,[1:6]))'; G_feaL];
spnum          = max(segImg(:));
fea(find(isnan(fea)==1)) = 0;

paramsalnonthresh.wtupdate = 0;
% SDL
[D_salF]       = salFLearn(salval,fea,paramsalnonthresh);

% normal dictionary learning
%[D_Full]       = salFLearn(ones(1,size(fea,2)),fea,paramsalnonthresh);
disp('dsalF DONE \n');


% Uncomment the following to use saliency update with dictionary (SDLs)

%paramsalnonthresh.wtupdate   = 1;
%paramsalnonthresh.segImg     = segImg;
%paramsalnonthresh.aff        =  optAff;
%[D_salW]       = salFLearn(salval,fea,paramsalnonthresh); %saliency with weight update
%disp('dsalW DONE \n');

savefnameFea   = strcat(dpathSal,'/','GDictW',...
    num2str(imgnum,numzero),'.mat');

save(savefnameFea,'D_salF','D_salW','D_Full');
disp('saved \n');
var = savefnameFea;%datafile{imgnum};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [DSalF]  = salFLearn(Salval,fea,paramsalnonthresh)

% Function saves variables in a structure %

variable_fea       = fea;
[DSalF.D,E]               = dict_learnInitch(variable_fea,paramsalnonthresh,Salval);
DSalF.X                   = E.CoefMatrix;
DSalF.Y                   = variable_fea;
DSalF.salval              = Salval; 
DSalF.ind                 = ones(size(Salval));
DSalF.weightf             = E.weightF; % final weight same as saliency values in SDL, updated weight in SDLs
% Mainly for understanding %
%DSalF.Dict                = E.Dict;     % dictionary at each iteration
%DSalF.upW                 = E.W;       % weights at each iteration
%DSalF.errW                = E.errW;    %error weight at each iteration
%DSalF.err                 = E.err;     % error at each iteration
%DSalF.Dinit               = E.Dinit;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [D,output] = dict_learnInitch(SalpixFeatures,params,salwt)

% This calls the main dictionary learning function

[~,ind] =  sort(salwt,'descend');
Dinit   = SalpixFeatures(:,ind(1:params.K));
params.InitializationMethod = 'GivenMatrix';
params.initialDictionary     = Dinit;
Data          = SalpixFeatures;
params.weight = diag(salwt);

if params.wtupdate==0
    [D,output]  = salKSVD(Data,params); % use ksvd_sal package
elseif params.wtupdate==1
    %disp('wt update...')
    [D,output]  =   salWtUpKSVD_graph(Data,params);
end