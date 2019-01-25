function h = plotRRMSE(RMSE,mlabels,dlabels,nrow,ncol)

nm = size(RMSE,2);
nd = size(RMSE,3);

if nargin < 5
    
    nrow = floor(sqrt(nm));
    ncol = ceil(nm/nrow);
    
    if nargin < 3
        dlabels = cell(1,nd);
        for k = 1:nd
            dlabels{k} = num2str(k);
        end
        if nargin < 2
            mlabels = cell(1,nm);
            for k = 1:nm
                mlabels{k} = char('a' + k-1);
            end
        end
    end
end


h = figure;
colors = get(groot,'defaultAxesColorOrder');
if nd<=size(colors,1);
    colors = colors(1:nd,:);
else
    kerroin = ceil(nd/size(colors,1));
    colors = repmat(colors,kerroin,1);
    colors = colors(1:nd,:);
end
for i = 1:nm;
          
    if nm>1
        subplot(nrow,ncol,i);
    end
    hold on;
    RMSEi = squeeze(RMSE(:,i,:));
    plotSpread(RMSEi,'xNames',dlabels,'distributionColor',colors,'spreadWidth',0.8,'showMM',2);
    title(mlabels{i},'interpreter','latex');
    set(gca,'Fontsize',7)
    set(gca,'XTickLabelRotation',55);    
    if i==1 || rem(i,ncol)==1
        if nm>2
            ylabel('RMSE');
        else
            ylabel('SRMSE');
        end
    end
    
    
end