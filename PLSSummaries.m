function [normargsout,Wout,ncompopt] = PLSSummaries(S,Sobs,Z,Nvalid,maxncomp,inittr,initncomp,nacc)

N = size(S,1);
nS = size(S,2);
if nargin <8 
    nacc = 200;
end


Ii = (1:N);
nZ = size(Z,2);
nS = size(S,2);

if nargin<7
    initncomp = maxncomp;
end

 
if nargin<6
    [Stf,normargs,W,~,Znorm] = oneStepPLS(S,Z,maxncomp);
else 
    Stf = inittr.Stf;
    normargs = inittr.normargs;
    W = inittr.W;
    Znorm = inittr.Znorm;
end
Stfobs = normalize(Sobs,normargs);
Stfobs = Stfobs*W;

Ivalid = closestQuantile(Stf,Stfobs,Nvalid,initncomp);


RMSE = zeros(Nvalid,maxncomp);


for j = 1:Nvalid
    %tic
    %First remove testdata
    ins = [1:(Ivalid(j)-1) (Ivalid(j)+1):N];
    Stfj = Stf(ins,:);
    Znormj = Znorm(ins,:);
    
    Stfvalj = Stf(Ivalid(j),:);
    Zvalj = Znorm(Ivalid(j),:);
    
    closestall = closestQuantile(Stfj,Stfvalj,nacc,1:maxncomp);
    
    allj = unique(closestall(:));
    SEall = zeros(size(Stfj,1),nZ);
    SEall(allj,:) = computeSE(Znormj(allj,:),Zvalj);
    
    for k = 1:maxncomp
        RMSE(j,k) = sum(sqrt(mean(SEall(closestall(:,k),:),1)),2);
    end
       
    
end

mRMSE = squeeze(mean(RMSE,1));

[~,ncompopt] = min(mRMSE);

normargsout = normargs;

Wout = W(:,1:ncompopt);