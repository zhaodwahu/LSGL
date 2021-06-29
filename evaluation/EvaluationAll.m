
function ResultAll = EvaluationAll(Pre_Labels,Outputs,test_target)
% evluation for MLC algorithms, there are five evaluation metrics
% 
% syntax
%   ResultAll = EvaluationAll(Pre_Labels,Outputs,test_target)
%
% input
%   test_targets        - L x num_test data matrix of groundtruth labels
%   Pre_Labels          - L x num_test data matrix of predicted labels
%   Outputs             - L x num_test data matrix of scores
%
% output
%     ResultAll
%     ResultAll(1,1)=HammingLoss;
%     ResultAll(2,1)=Average_Precision;
%     ResultAll(3,1)=OneError;
%     ResultAll(4,1)=RankingLoss;
%     ResultAll(5,1)=Coverage;
    
    ResultAll=zeros(5,1); 

    HammingLoss=Hamming_loss(Pre_Labels,test_target);
    RankingLoss=Ranking_loss(Outputs,test_target);
    OneError=One_error(Outputs,test_target);
    Coverage=coverage(Outputs,test_target);
    Average_Precision=Average_precision(Outputs,test_target);
    
    ResultAll(1,1)=HammingLoss;
    ResultAll(2,1)=Average_Precision;
    ResultAll(3,1)=OneError;
    ResultAll(4,1)=RankingLoss;
    ResultAll(5,1)=Coverage;     
end