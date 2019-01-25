function [Sreg,normargs,b,Mnorm,Margs] = oneStepReg(S,M,normalizeM);

if nargin<3
    normalizeM = true;
end

nS = size(S,2);
nM = size(M,2);
nsim = size(S,1);

redund = false(1,nS);

if rank(S)<nS
    [S,~,redund] = removeRedundantColumns(S,ones(1,nS));
end


b = zeros(nS,nM);

[Snorm,normargsraw] = normalize(S);
if normalizeM
    [Mnorm,Margs] = normalize(M);
else
    Mnorm = M;
    Margs = struct;
    Margs.lam = -1*ones(1,nM);
    Margs.mju = zeros(1,nM);
    Margs.sd = ones(1,nM);
end




X = [Snorm];

braw = [(inv(X'*X)*X'*Mnorm)];

Sreg = X*braw;

normargs.lam = -1*ones(1,nS);
normargs.lam(~redund) = normargsraw.lam;

normargs.mju = zeros(1,nS);
normargs.mju(~redund) = normargsraw.mju;

normargs.sd = 1*ones(1,nS);
normargs.sd(~redund) = normargsraw.sd;


b(~redund,:) = braw;