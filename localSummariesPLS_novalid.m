function [Wout,normargsout,closest,ncomp,initcomp] = localSummariesPLS_novalid(S,Sobs,Z,q,maxncomp,inittr)

N = size(S,1);
nS = size(S,2);


Ii = (1:N);
nZ = size(Z,2);
nS = size(S,2);

 
if nargin<6
    [Stf,normargs,W,~,Znorm,~,mse] = oneStepPLS(S,Z,maxncomp,10);
else 
    Stf = inittr.Stf;
    normargs = inittr.normargs;
    W = inittr.W;
    Znorm = inittr.Znorm;
    mse = inittr.mse;
end
initcomp = chooseNcomps(Znorm,mse);

Stfobs = normalize(Sobs,normargs);
Stfobs = Stfobs*W;


closest = closestQuantile(Stf,Stfobs,q,initcomp);
[~,normargsout,Wout,~,Znorm,~,mse] = oneStepPLS(S(closest,:),Znorm(closest,:),maxncomp);
ncomp = chooseNcomps(Znorm,mse);
Wout = Wout(:,1:ncomp);