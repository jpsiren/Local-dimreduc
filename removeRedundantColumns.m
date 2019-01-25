function [X,X2,redund] = removeRedundantColumns(X,X2);

N = size(X,1);
nX = size(X,2);

if rank(X)<nX
    redund = false(1,nX);
    for i = 1:nX
        redund(i) = length(unique(X(:,i)))<2;
        if ~redund(i)
            cols = ~(redund(1:i));
            if rank(X(:,cols))<sum(cols)
                redund(i) = true;
            end
        end
    end
    
    X(:,redund) = [];
    X2 = X2(:,~redund);
    
end

