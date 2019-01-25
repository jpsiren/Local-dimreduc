function [nrows, ncols] = getNrowscols(subplots);

nplots = length(subplots);

cols = zeros(nplots,1);
rows = zeros(nplots,1);

for i = 1:nplots
    posi = subplots(i).Position;
    cols(i) = posi(1);
    rows(i) = posi(2);
end

nrows = size(unique(rows),1);
ncols = size(unique(cols),1);