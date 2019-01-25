function S = gkSummaries(y,quantiles,powers)

nq = length(quantiles);
np = length(powers);

yq = quantile(y,quantiles);

Sr = repmat(yq',1,np).^repmat(powers,nq,1);
S = Sr(:)';

