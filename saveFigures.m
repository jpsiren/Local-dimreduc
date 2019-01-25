function saveFigures(h,filebeg,fileends,fileext,positions,figformat,reso)

nh = length(h);
lisa = 0.07;


if size(positions,1)==1
    positions = repmat(positions,nh,1);
end

for i = 1:nh
       
    set(h(i), 'Units','centimeters', 'Position',positions(i,:))
    
    subplots = get(h(i),'Children');
    nsp = length(subplots);
    notaxes = false(nsp,1);
    for k = 1:nsp
        if ~isequal(subplots(k).Type,'axes')
            notaxes(k) = true;
        end
    end
    subplots(notaxes) = [];
    nsp = length(subplots);
   
    
    if nsp>1
        [nr,nc] = getNrowscols(subplots);
        lisax = lisa + lisa*log(nc);
        lisay = lisa + lisa*log(nr);
        
        for j = 1:nsp
            in = nsp -j +1;
            ylim = subplots(in).YLim;
            xlim = subplots(in).XLim;
            text(subplots(in),xlim(1) - lisax*(diff(xlim)), ylim(2) + lisay*(diff(ylim)),[char(96+j) ')']);
        end
        
    end
    
    filename = [filebeg fileends{i} fileext];
    print(h(i),filename,figformat,reso);
    close(h(i));
end