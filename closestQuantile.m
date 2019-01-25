function [closest] = closestQuantile(S,Sobs,alfa,dims)

nsim = size(S,1);
nS = size(S,2);
if nargin<4
    dims = nS;
end
ndims = length(dims);

%If alfa smaller than 1 then treated as a quantile. With alfa>1 alfa used
%as a number of samples

if alfa<=1
    nclosest = ceil(nsim*alfa);
else
    nclosest = alfa;
end

if 1
    
    maxdim = max(dims);
    Sm = S(:,1:maxdim);
    Sobsm = Sobs(:,1:maxdim);
    
    obsdiff = (Sm-repmat(Sobsm,nsim,1)).^2;
    cumobsdiff = cumsum(obsdiff,2);
    
    [~,difforder] = sort(cumobsdiff(:,dims),1);
    
    
    closest = difforder(1:nclosest,:);
   

else
    closest = zeros(nclosest,ndims);
    maxdim = max(dims);
    Sm = S(:,1:maxdim);
    Sobsm = Sobs(:,1:maxdim);
    
    obsdiff = (Sm-repmat(Sobsm,nsim,1)).^2;
    cumobsdiff = cumsum(obsdiff,2);
    
    [~,difforder] = sort(cumobsdiff(:,dims(1)),1);
    closest(:,1) = difforder(1:nclosest);
    
    for i = 2:ndims
        dimi = dims(i);
        
        [~,diffordern] = sort(cumobsdiff(difforder,dimi),1);
        closest(:,i) = difforder(diffordern(1:nclosest));
        difforder = difforder(diffordern);
    end
        
    
end