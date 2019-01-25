function [hs,MRMSEall] = drawResults(resultsall, reductions, parameters,nameall,plotfigures)


hs = [];
if nargin < 5
    plotfigures = true;
end

nreduc = length(resultsall);
if nreduc == 0
    disp('No results provided');
    return
end

if length(reductions)~=nreduc
    disp('Sizes of resultsall and reductions do not match');
    return
end

RMSEall = resultsall{1}.RMSE;

for j = 2:nreduc
    RMSEall = cat(3,RMSEall,resultsall{j}.RMSE);
end

if length(parameters)~=size(RMSEall,2)
    hs = [];
    disp('Sizes of resultsall and parameters do not match');
    return
end
MRMSEall = sum(RMSEall,2);


if plotfigures
    hs(1) = plotRRMSE(RMSEall,parameters,reductions);
    
    hs(2) = plotRRMSE(MRMSEall,nameall,reductions);
end



