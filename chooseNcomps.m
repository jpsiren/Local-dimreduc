function ncomps = chooseNcomps(theta,mse);

thscale = sum(var(theta));

msediff = diff(mse(2,:));
ncomps = find(msediff>(-thscale/100),1);
if isempty(ncomps)
    ncomps = size(mse,2)-1;
end