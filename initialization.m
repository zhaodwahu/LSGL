

function [optmParameter,modelparameter] =  initialization

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Optimization Parameters
    optmParameter.lambda1    = 10^-3;    %  Label Propagation
    optmParameter.lambda2    = 10^-1;   %  Global label correlation                                                                                                                                                                                                                                                                                         ; % 2.^[-10:10] % sparsity
    optmParameter.lambda3    = 10^-1;   %  Local smooth structure
    optmParameter.lambda4    = 10^-1;   %  sparsity W
    optmParameter.lambda5    = 10^-1;   %  sparsity  S
    optmParameter.gamma      = 8;       %  Initialize W

    optmParameter.searchPara      = 0; % indicate whether tuning the parameters, {0:not,1:yes}
    optmParameter.tuneParaOneTime = 1; % indicate that tuning the parameter one time or tuning it in each fold. {0: each fold,1: only one time}

    optmParameter.lamda1_searchrange = 10.^[-3:3]; 
    optmParameter.lamda2_searchrange = 10.^[-1:-1];
    optmParameter.lamda3_searchrange = 10.^[-1:-1];
    optmParameter.lamda4_searchrange = 10.^[-3:-1];
    optmParameter.lamda5_searchrange = 10.^[-3:-1];
    optmParameter.gamma_searchrange  = [0.1,1,8];
    optmParameter.maxIter            = 100;
    optmParameter.minimumLossMargin  = 10^-5;
    optmParameter.bQuiet             = 1;

    %% Model Parameters
    modelparameter.crossvalidation    = 1; % {0,1}
    modelparameter.cv_num             = 10;
    modelparameter.L2Norm             = 1; % {0,1}

    modelparameter.tuneParaOneTime    = 1;
    modelparameter.repetitions        = 1;

end