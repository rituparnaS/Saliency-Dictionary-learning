function [D,output] = dict_learnInitch(SalpixFeatures,params,salwt)

[~,ind] =  sort(salwt,'descend');
%ind(1:params.K)
Dinit = SalpixFeatures(:,ind(1:params.K));

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