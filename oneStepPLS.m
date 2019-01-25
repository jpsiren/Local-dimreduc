function [Stf,normargs,W,pct,Mnorm,Margs,mse] = oneStepPLS(S,M,ncomp,CVK);

[Snorm,normargs] = normalize(S);

[Mnorm,Margs] = normalize(M);

if nargin<4
    CVK = 'resubstitution';
end

try
    [~,~,~,~,~,pct,mse,stats] = plsregress(Snorm,Mnorm,ncomp,'CV',CVK);
catch
    keyboard
end

W = stats.W;
Stf = Snorm*W;
