function S = generateSimulationsGK(theta,nsamples,quantiles,powers);

c = 0.8;
niter = size(theta,1);

nq = length(quantiles);
np = length(powers);

S = zeros(niter,nq*np);

for i = 1:niter;
    A = theta(i,1);
    B = theta(i,2);
    g = theta(i,3);
    k = theta(i,4);
    
    y = simulateGK(A,B,c,g,k,nsamples);
    S(i,:) = gkSummaries(y,quantiles,powers);
    
end
    