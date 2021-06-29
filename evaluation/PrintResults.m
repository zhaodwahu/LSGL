
function PrintResults(Result)
    [~,n] = size(Result);
    if n == 2
        fprintf('------------------------------------\n');
        fprintf('Evalucation Metric    Mean    Std\n');
        fprintf('------------------------------------\n');
        fprintf('HammingLoss           %.4f  %.4f\r',Result(1,1),Result(1,2));
        fprintf('Average_Precision     %.4f  %.4f\r',Result(2,1),Result(2,2));
        fprintf('OneError              %.4f  %.4f\r',Result(3,1),Result(3,2));
        fprintf('RankingLoss           %.4f  %.4f\r',Result(4,1),Result(4,2));
        fprintf('Coverage              %.4f  %.4f\r',Result(5,1),Result(5,2));
        fprintf('------------------------------------\n');
    else
        fprintf('\n----------------------------\n');
        fprintf('Evalucation Metric    Mean\n');
        fprintf('----------------------------\n');
        fprintf('HammingLoss           %.4f\r',Result(1,1));
        fprintf('Average_Precision     %.4f\r',Result(2,1));
        fprintf('OneError              %.4f\r',Result(3,1));
        fprintf('RankingLoss           %.4f\r',Result(4,1));
        fprintf('Coverage              %.4f\r',Result(5,1));
        fprintf('----------------------------\n');
    end
end