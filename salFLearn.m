function [DSalF]  = salFLearn(Salval,fea,paramsalnonthresh)



variable_fea       = fea;


[DSalF.D,E]               = dict_learnInitch(variable_fea,paramsalnonthresh,Salval);
DSalF.X                   = E.CoefMatrix;
DSalF.Y                   = variable_fea;
DSalF.salval              = Salval; 
DSalF.ind                 = ones(size(Salval));
DSalF.upW                 = E.W;       % weights at each iteration
DSalF.errW                = E.errW;    %error weight at each iteration
DSalF.err                 = E.err;     % error at each iteration
DSalF.weightf             = E.weightF; % final weight
%DSalF.contW              = E.contW;
DSalF.Dict                = E.Dict;
DSalF.Dinit               = E.Dinit;
%DSalF.CfNew              = E.CfNew;

