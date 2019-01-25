function [Wout,normargsout,closest,qopt,ncompopt,initcompopt] = localSummariesPLS(S,Sobs,Z,Nvalid,qs,maxncomp,inittr,initncomp,nacc,rcrit)

N = size(S,1);
nS = size(S,2);
if nargin <9 
    nacc = 200;
end


Ii = (1:N);
nZ = size(Z,2);
nS = size(S,2);

nq = length(qs);
maxq = max(qs);

if nargin < 10 
    rcrit = 'm';
end

if nargin<8
    initncomp = (maxncomp);
end

 
if nargin<7
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
closestall = zeros(ceil((N-1)*maxq),maxncomp,Nvalid);

for j = 1:Nvalid
    %First remove testdata
    ins = [1:(Ivalid(j)-1) (Ivalid(j)+1):N];
    Stfj = Stf(ins,:);
    
    Stfvalj = Stf(Ivalid(j),:);
  
    closestall(:,:,j) = closestQuantile(Stfj,Stfvalj,maxq,1:maxncomp);
end

RMSE = zeros(Nvalid,nq,maxncomp,maxncomp);


for i = 1:nq
    qi = qs(i);
    Ni = ceil((N-1)*qi);
    
    for j = 1:Nvalid
        %tic
        %First remove testdata
        ins = [1:(Ivalid(j)-1) (Ivalid(j)+1):N];
        Sj = S(ins,:);
        Znormj = Znorm(ins,:);
        %Zj = Z(ins,:);
        
        Svalj = S(Ivalid(j),:);
        Zvalj = Znorm(Ivalid(j),:);
        
        for l = 1:maxncomp
            
            closestj = closestall(1:Ni,l,j);
            
            [Stfj,normargsj,Wj] = oneStepPLS(Sj(closestj,:),Znormj(closestj,:),maxncomp);
            
            Stfvalj = normalize(Svalj,normargsj);
            Stfvalj = Stfvalj*Wj;
            
            closestvall =  closestj(closestQuantile(Stfj,Stfvalj,nacc,1:maxncomp));
            
            allj = unique(closestvall(:));
            SEall = zeros(size(Stfj,1),nZ);
            SEall(allj,:) = computeSE(Znormj(allj,:),Zvalj);
            
            for k = 1:maxncomp
                RMSE(j,i,l,k) = sum(sqrt(mean(SEall(closestvall(:,k),:),1)),2);
            end
        end
        
    end
    %toc
    %disp([i]);
    
end

switch rcrit
    case 'm'
        mRMSE = squeeze(mean(RMSE,1));
    case 'q'
        mRMSE = squeeze(quantile(RMSE,0.9,1));
end

[~,minIn] = min(mRMSE(:));
[qin,initcompopt,ncompopt] = ind2sub(size(mRMSE),minIn);
qopt = qs(qin);


closest = closestQuantile(Stf,Stfobs,qopt,initcompopt);
[~,normargsout,Wout] = oneStepPLS(S(closest,:),Znorm(closest,:),ncompopt);
