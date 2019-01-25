function RMSE = computeRMSE(estim,trueval);

nest = size(estim,1);
ntrueval = size(trueval,2);

if size(estim,2)~=ntrueval
    estim = repmat(estim,1,ntrueval);
end

valdiff = estim-repmat(trueval,nest,1);
RMSE = sqrt(mean(valdiff.^2));