function y = simulateRickermap(theta,N0,datains)

r = exp(theta(:,1));
sig = theta(:,2);
fi = theta(:,3);

niter = size(theta,1);

nt = length(datains);
ny = sum(datains);

if size(N0,1)==1
    Ncurr = repmat(N0,niter,1);
else
    Ncurr = N0;
end
et = repmat(sig,1,nt).*randn(niter,nt);

N = zeros(niter,nt);

for i = 1:nt
    Ncurr = r.*Ncurr.*exp(-Ncurr + et(:,i));
    N(:,i) = Ncurr;
end

y = poissrnd(repmat(fi,1,ny).*N(:,datains));



