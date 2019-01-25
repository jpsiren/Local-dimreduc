function [bout,normargsout,closest,qopt,redund] = localSummariesReg(S,Sobs,Z,Nvalid,qs,inittr)

N = size(S,1);
nS = size(S,2);
nacc = 200;

redund = false(1,nS);

nq = length(qs);
maxq = max(qs);

if nargin<6
    if rank(S)<nS
        [S,Sobs,redund] = removeRedundantColumns(S,Sobs);
    end
    [Sreg,normargs,b,Znorm] = oneStepReg(S,Z);
    Sregobs = normalize(Sobs,normargs);
    Sregobs = Sregobs*b;
    
else 
    
    Sreg = inittr.Sreg;
    normargs = inittr.normargs;
    b = inittr.b;
    Znorm = inittr.Znorm;
    Sregobs = normalize(Sobs,normargs);
    Sregobs = Sregobs*b;
    if rank(S)<nS
        [S,~,redund] = removeRedundantColumns(S,Sobs);
    end
    Sreg(:,redund) = [];
    Sregobs(:,redund) = [];
end

Ivalid = closestQuantile(Sreg,Sregobs,Nvalid);
closestall = zeros(ceil((N-1)*maxq),Nvalid);

for j = 1:Nvalid
    %First remove testdata
    ins = [1:(Ivalid(j)-1) (Ivalid(j)+1):N];
    Sregj = Sreg(ins,:);
    
    Sregvalj = Sreg(Ivalid(j),:);
  
    closestall(:,j) = closestQuantile(Sregj,Sregvalj,maxq);
end

RMSE = zeros(Nvalid,nq);


for i = 1:nq
    qi = qs(i);
    Ni = ceil((N-1)*qi);
    
    for j = 1:Nvalid
        
        %First remove testdata
        ins = [1:(Ivalid(j)-1) (Ivalid(j)+1):N];
        Sj = S(ins,:);
        Znormj = Znorm(ins,:);
        Zj = Z(ins,:);
        
        Svalj = S(Ivalid(j),:);
        Zvalj = Znorm(Ivalid(j),:);
        
        closestj = closestall(1:Ni,j);
        
        [~,normargsj,bj] = oneStepReg(Sj(closestj,:),Znormj(closestj,:),0);
        
        Sregj = normalize(Sj,normargsj);
        Sregj = Sregj*bj;
        Sregvalj = normalize(Svalj,normargsj);
        Sregvalj = Sregvalj*bj;
        
        try
            closestv =  closestQuantile(Sregj,Sregvalj,nacc);
        catch
            keyboard
        end
        
        Zest = Znormj(closestv,:);
        RMSE(j,i) =sum((computeRMSE(Zest,Zvalj)));
        
    end
end


[~,minIn] = min(mean(RMSE,1));

qopt = qs(minIn);
closest = closestQuantile(Sreg,Sregobs,qopt);
[~,normargsout,bout] = oneStepReg(S(closest,:),Znorm(closest,:),0);
