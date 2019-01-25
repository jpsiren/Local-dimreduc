function S = rickerSummaries(y);

niter = size(y,1);

S = zeros(niter,124);

for i = 1:niter
    yi = y(i,:);
    acovi = xcov(yi,5);
    
    S(i,1:6) = acovi(6:end);
    if acovi(6)>0
        S(i,7:11) = acovi(7:end)/acovi(6); %Autocorrelation
    end
    S(i,12) = mean(yi);
    for k = 0:4
        S(i,13+k) = sum(yi==k);
    end
    for k = 2:6
        if sum(yi)>0
            S(i,16+k) = log(sum(yi.^k));
        end
    end
    
    if sum(yi>0)
        S(i,23) = log(mean(yi));
        S(i,24) = log(var(yi));
    end
    
    S(i,25:74) = yi;
    S(i,75:124) = sort(yi);
    
    
end
    
        
    