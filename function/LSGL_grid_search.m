
function [ BestParameter, BestResult ] = LSGL_grid_search( train_data, train_target, oldOptmParameter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
%   - train_data            : n by d data matrix
%   - trian_target          : n by l lable matrix
%   - oldOptmParameter      : initilization parameter
%
% Output
%   - BestParameter         : a structral variable with searched paramters,
%   - BestResult            : best result on the training data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    num_train             = size(train_data,1);
    randorder             = randperm(num_train);
    
    optmParameter         = oldOptmParameter;
    
    lamda1_searchrange     = oldOptmParameter.lamda1_searchrange;
    lamda2_searchrange     = oldOptmParameter.lamda2_searchrange;
    lamda3_searchrange     = oldOptmParameter.lamda3_searchrange;
    lamda4_searchrange     = oldOptmParameter.lamda4_searchrange;
    lamda5_searchrange     = oldOptmParameter.lamda5_searchrange;
    gamma_searchrange     = oldOptmParameter.gamma_searchrange;
    BestResult = zeros(16,1);
    num_cv = 5;
    index = 1;
    total = length(lamda1_searchrange)*length(lamda2_searchrange)*length(lamda3_searchrange)*length(lamda4_searchrange)*length(lamda5_searchrange)*length(gamma_searchrange);
for i=1:length(lamda1_searchrange) % 
    for j=1:length(lamda2_searchrange) % 
        for k = 1:length(lamda3_searchrange) % 
            for m = 1:length(lamda4_searchrange) %
                for n = 1:length(lamda5_searchrange) % 
                    for p = 1:length(gamma_searchrange) % 
                        fprintf('\n-%d-th/%d: search parameter lamda1 to gamma for LSGL, lamda1 = %f, lamda2 = %f, lambda3 =  %f, lambda4 =  %f, lambda5 =  %f, and gamma =  %f',...
                            index, total, lamda1_searchrange(i), lamda2_searchrange(j), lamda3_searchrange(k), lamda4_searchrange(m), lamda5_searchrange(n), gamma_searchrange(p));
                        index = index + 1;
                        optmParameter.lamda1   = lamda1_searchrange(i); %
                        optmParameter.lamda2   = lamda2_searchrange(j);  % 
                        optmParameter.lamda3   = lamda3_searchrange(k); % 
                        optmParameter.lamda4   = lamda4_searchrange(m); % 
                        optmParameter.lamda5   = lamda5_searchrange(n); % 
                        optmParameter.gamma    = gamma_searchrange(p); % 

                        optmParameter.maxIter           = 30;
                        optmParameter.minimumLossMargin = 0.01;
                        optmParameter.outputtempresult  = 0;


                        Result = zeros(5,1);
                        for cv = 1:num_cv
                            [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet( train_data,train_target',randorder,cv,num_cv);
                            [model]  = LSGL( cv_train_data, cv_train_target,optmParameter);
                            Outputs     = (cv_test_data*model.W)';
                            Pre_Labels  = round(Outputs);Pre_Labels  = (Pre_Labels >= 1); Pre_Labels  = double(Pre_Labels);

                            Result      = Result + EvaluationAll(Pre_Labels,Outputs,cv_test_target');
                        end
                        Result = Result./num_cv;
                        if optmParameter.bQuiet == 0
                            PrintResults(Result)
                        end
                        r = IsBetterThanBefore(BestResult,Result);
                        if r == 1
                            BestResult = Result;
                            PrintResults(Result);
                            BestParameter = optmParameter;
                        end
                    end
                end
            end
        end
    end
end
end


function r = IsBetterThanBefore(Result,CurrentResult)
% 1 HammingLoss
% 2 Average_Precision
% 3 OneError
% 4 RankingLoss
% 5 Coverage
%     a = 1-CurrentResult(1,1) + CurrentResult(2,1)  +  1-CurrentResult(3,1) + 1-CurrentResult(4,1) + 1-CurrentResult(5,1);
%     b = 1-Result(1,1) + Result(2,1) + 1-Result(3,1) + 1-Result(4,1) + 1-Result(5,1);
    a = 1-CurrentResult(1,1) + CurrentResult(2,1);
    b = 1-Result(1,1) + Result(2,1);
    if a > b
        r =1;
    else
        r = 0;
    end
end
