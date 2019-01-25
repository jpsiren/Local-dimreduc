function h = drawDimFig(quantilesDim,varit,merkit,ylab,xlab,xtlab,lisa,leg,titles,axlims,draw1)

h = figure;

nx = length(xtlab);
nv = length(merkit);

nq = size(quantilesDim,1);
nmeas = size(quantilesDim,3);

if nmeas==4
    nrow = 2;
    ncol = 2;
else
    nrow = ceil(nmeas/3);
    ncol = ceil(nmeas/nrow);
end

for i = 1:nmeas
    subplot(nrow,ncol,i);
    hold on;
    
    qDimi = reshape(quantilesDim(:,:,i),[nq nx nv]);
    if draw1
        plot(axlims(1:2),ones(1,2),'k:');
    end
    p = zeros(1,nv);
    for j = 1:nv
        p(j) = plot(qDimi(2,:,j),[varit{j} merkit{j} '-'],'MarkerSize',4);
        for k = 1:nx
            plot([k k] + (j-(nv+1)/2)*lisa,qDimi([1 3],k,j),[varit{j} ':.']);
        end
    end
    if i ==2
        legend(p,leg,'Location','Best','interpreter','latex')
    end
    axis(axlims);
    title(titles{i});
    if i == 1
        ylabel(ylab,'interpreter','latex')
    end
    xlabel(xlab,'interpreter','latex');
    set(gca,'XTick',1:nx)
    set(gca,'XTickLabel',xtlab);
    set(gca,'XTickLabelRotation',55);
    set(gca, 'Fontsize',7)
    
    
end