function [Snorm,args] = normalize(S,args);
% [Snorm,args] = normalize(S,args);
% Normalization of the columns of S.
% Two steps: first one parameter Box-Cox transformation, and then centering
% and setting variance to one.
%
% The input args includes the parameters for normalization of each column:
% lam - row vector of lambda parameter for Box-Cox, where d is dim of S
% mju - row vector of means
% sd - row vector of standard deviations
%
% If the input args is not specified, lam is set to 0.5 for all columns
% without negative entries, and mju and sd are empirical estimates from S.
% If a column has negative entries, then the Box-Cox transformation is not
% performed and lam is seto to -1. Similarly, if input args.lam is set to
% -1 Box-Cox transformation is not performed on that column.

nsim = size(S,1);
nS = size(S,2);

if nargin < 2
    args.lam = 0.5*ones(1,nS);
    for i = 1:nS
        if any(S(:,i)<0)
            args.lam(i) = -1;
        end
    end
end
ins = find(args.lam>-0);

lamr = repmat(args.lam(ins),nsim,1);
Snorm = S;

for k = 1:length(ins)
    negative = Snorm(:,ins(k))<=0;
    Snorm(negative,ins(k)) = 1e-6;
end


Snorm(:,ins) = (Snorm(:,ins).^lamr-1)./lamr;



if nargin < 2
    args.mju = zeros(1,nS);
    args.sd = ones(1,nS);
    for i = 1:nS
        args.mju(i) = mean(Snorm(:,i));
        if length(unique(Snorm(:,i)))>1
            
            args.sd(i) = std(Snorm(:,i),1);
            
            % Check for NAN
            if isequaln(args.sd(i),NaN)
                args.sd(i) = 1;
                
            elseif args.sd(i) <1e-8 %Check for too small sd
                args.sd(i) = 1;
            end
        end
    end
end

for i = 1:nS
    Snorm(:,i) = (Snorm(:,i)-args.mju(i))./args.sd(i);
end

    
    