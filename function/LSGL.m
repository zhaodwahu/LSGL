
function [model_LSGL] = LSGL( X, Y, optmParameter)
   %% optimization parameters
    lambda1           = optmParameter.lambda1;
    lambda2           = optmParameter.lambda2;
    lambda3           = optmParameter.lambda3;
    lambda4           = optmParameter.lambda4;
    lambda5           = optmParameter.lambda5;
    gamma            = optmParameter.gamma;
    
    maxIter          = optmParameter.maxIter;
    miniLossMargin   = optmParameter.minimumLossMargin;
   %% initializtion
    num_dim = size(X,2);
    num_labels=size(Y,2);
    XTX = X'*X;
    XTY = X'*Y;

    W   = (XTX + gamma*eye(num_dim)) \ (XTY);
    W_1 = W;
    
    S = ones(num_labels);
    S_1 = S;

    options = [];
    options.Metric = 'Euclidean';
    options.NeighborMode = 'KNN';
    options.k = 10;  % nearest neighbor
    options.WeightMode = 'HeatKernel';
    options.t = 1;
    C = constructW(X,options);
    L = diag(sum(C,2))-C;
    iter    = 1;
    oldloss = 0;
    
    bk   = 1;
    bk_1 = 1; 

    Lip1 = 2*norm(XTX)^2 + 2*norm(lambda1*(Y'*Y))^2  + 2*norm(lambda3*(Y'*(L'+L)*Y))^2;
   %% proximal gradient
    while iter <= maxIter
       S    = (S+S')/2;
       Lip2 = norm(lambda2*S)+norm(0.5*lambda2*(W'*W));
       Lip  = sqrt( Lip1 + 2*Lip2^2);
     %% update W
       W_k    = W + (bk_1 - 1)/bk * (W - W_1);
       Gw_s_k = W_k - 1/Lip * ((XTX*W_k  - X'*Y) + lambda2*W_k*S);
       W_1    = W;
       W      = softthres(Gw_s_k,lambda4/Lip);      
     %% update S
       S_k  = S + (bk_1 - 1)/bk * (S - S_1);
       Gs_k = S_k - 1/Lip * (lambda1*(Y'*Y*S_k-Y'*Y) + 0.5*lambda2*(W'*W) + lambda3*(Y'*L*Y*S_k));
       S_1  = S;
       S    = softthres(Gs_k,lambda5/Lip); 
       S    = max(S,0);
       S    = (S+S')/2;
       
       bk_1   = bk;
       bk     = (1 + sqrt(4*bk^2 + 1))/2;
       
       M=X*W-Y;
       predictionLoss   = 0.5*trace(M'*M);
       N=(Y*S-Y);
       LabelPropagation = 0.5*trace(N'*N);
       GlobalLC         = 0.5*trace(S*(W'*W));
       YS=Y*S;
       LocalLC          = 0.5*trace(YS'*L*YS);
       sparsityW        = sum(sum(W~=0));
       sparsityS        = sum(sum(S~=0));
       
       totalloss        = predictionLoss + lambda1*LabelPropagation + lambda2*GlobalLC + lambda3*LocalLC + lambda4*sparsityW + lambda5*sparsityS;
       loss(iter,1)     = totalloss;
       if abs((oldloss - totalloss)/oldloss) <= miniLossMargin
           break;
       elseif totalloss <=0
           break;
       else
           oldloss = totalloss;
       end
       iter=iter+1;
    end
    model_LSGL.W = W;
    model_LSGL.S = S;
    model_LSGL.loss=loss;
end

%% soft thresholding operator
function W = softthres(W_t,lambda)
    W = max(W_t-lambda,0) - max(-W_t-lambda,0); 
end
