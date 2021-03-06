reductions = {'Reg', 'localReg', 'localRegopt', 'PLS', 'PLSopt', 'localPLS', 'localPLSopt'};
parameters = {'$A$','$B$','$g$','$k$'};

fileext = '.eps';
fileformat = '-depsc';
fileends = {'RMSE_all','RMSE_sum'};
fileenddim = {'RMSE_dim'};
fileenddim2 = {'RMSE_dim2'};
filebeg = ['C:\Users\sirenj5\work\Pr\dimReduc\figures\gk_'];
reso = '-r300';
positions = [2 2 18 12;2 2 9 8];
positionsdim = [2 2 18 15];
positionsdim2 = [2 2 18 24];
positionsrel = [2 2 18 12];
positionsrel2 = [2 2 18 8];


%%

pointer = 1;
sumRMSE = zeros(100,24,7);
gksetting = cell(1,24);
numsummaries = cell(1,4);
ndata = 2.5e4 * 2.^(0:5);
for j = 1:4;
    nsummaries = 25*2^(j-1);
    numsummaries{j} = ['$n_S=$' num2str(nsummaries)];
    for i = 1:6;
        [~,sumRMSE(:,pointer,:)] = drawResults({results_reg(i,j), results_l500reg(i,j),results_localreg(i,j),results_PLS(i,j),results_PLSopt(i,j),results_l500PLS(i,j),results_localPLS(i,j)},reductions,parameters,{'Parameters'},0);
        gksetting{pointer} = ['$N=$' num2str(ndata(i)) ' ' numsummaries{j}];
        pointer = pointer +1;
    end
end

h = plotRRMSE(sumRMSE,gksetting,reductions);
saveFigures(h,filebeg,fileenddim,fileext,positionsdim,fileformat,reso);

%%

pointer = 1;
gksetting2 = cell(1,24);
for i = 1:6;
    for j = 1:4;
        gksetting2{pointer} = ['$N=$' num2str(ndata(i)) ' ' numsummaries{j}];
        pointer = pointer +1;
    end
end

h = plotRRMSE(sumRMSE,gksetting2,reductions,6,4);
saveFigures(h,filebeg,fileenddim2,fileext,positionsdim2,fileformat,reso);

%%


relRMSE = cat(3,sumRMSE(:,:,2)./sumRMSE(:,:,1),sumRMSE(:,:,3)./sumRMSE(:,:,1),sumRMSE(:,:,3)./sumRMSE(:,:,2), ...
    sumRMSE(:,:,5)./sumRMSE(:,:,4),sumRMSE(:,:,6)./sumRMSE(:,:,5),sumRMSE(:,:,7)./sumRMSE(:,:,5),...
    sumRMSE(:,:,7)./sumRMSE(:,:,6));

alfa = 0.05;
qus = [alfa 0.5 1-alfa];
scales = [0.5 6.5 0.3 1.8];
lisa = 0.05;

varit = {'r','b','g','c'};
merkit = {'+','x','o','d'};

titles = {'Local vs global regression','Localopt vs global regression', ...
    'Localopt vs local regression', 'Optimzed vs heuristic PLS',...
    'Local vs global PLS','Localopt vs global PLS','Localopt vs local PLS'};

mainins = [1 2 5 6];
suppins = [3 4 7];


qrelRMSE = quantile(relRMSE,qus);

h = drawDimFig(qrelRMSE(:,:,mainins),varit,merkit,'Relative RMSE','$N$',ndata,lisa,numsummaries,titles(mainins),scales,1);
saveFigures(h,filebeg,{'RelRMSE'},fileext,positionsrel,fileformat,reso);

h = drawDimFig(qrelRMSE(:,:,suppins),varit,merkit,'Relative RMSE','$N$',ndata,lisa,numsummaries,titles(suppins),scales,1);
saveFigures(h,filebeg,{'RelRMSE_supp'},fileext,positionsrel2,fileformat,reso);

%%

alfa_dim = zeros(100,24,2);

ncomp_dim = zeros(100,24,5);

pointer = 0;
for i = 1:6
    for j = 1:4
        pointer = pointer +1;
        alfa_dim(:,pointer,1) = results_localreg(i,j).qopt;
        alfa_dim(:,pointer,2) = results_localPLS(i,j).qopt;
        
        ncomp_dim(:,pointer,1) = results_PLS(i,j).ncomps;        
        ncomp_dim(:,pointer,2) = results_PLSopt(i,j).ncomps;
        ncomp_dim(:,pointer,3) = results_l500PLS(i,j).ncompsl;
        ncomp_dim(:,pointer,4) = results_localPLS(i,j).ncompsi;        
        ncomp_dim(:,pointer,5) = results_localPLS(i,j).ncompsl;        
    end
end

qalfa_dim = quantile(alfa_dim,qus);
qalfa_dim(2,:,:) = mean(alfa_dim,1);
qncomp_dim = quantile(ncomp_dim,qus);
qncomp_dim(2,:,:) = mean(ncomp_dim,1);

h = zeros(2,1);
titles_alfa = {'Local regression','Local PLS'};
scales_alfa = [0.5 6.5 0 0.5];

h(1) = drawDimFig(qalfa_dim,varit,merkit,'$\alpha$','$N$',ndata,lisa,numsummaries,titles_alfa,scales_alfa,0);

titles_ncomp = {'PLS','PLSopt','Local PLS: local','Localopt PLS: initial', 'Localopt PLS: local'};
scales_ncomp = [0.5 6.5 0 reducpars.maxncomp+0.5];

    
h(2) = drawDimFig(qncomp_dim,varit,merkit,'Number of components','$N$',ndata,lisa,numsummaries,titles_ncomp,scales_ncomp,0);

saveFigures(h,filebeg,{'alfa','ncomp'},fileext,[positionsrel2;positionsrel],fileformat,reso);

        
%%

sin = 3;
Nin = 4;

hs = drawResults({results_reg(Nin,sin), results_l500reg(Nin,sin), ...
    results_localreg(Nin,sin),results_PLS(Nin,sin),results_PLSopt(Nin,sin),...
    results_l500PLS(Nin,sin), results_localPLS(Nin,sin)},...
    reductions,parameters,{'Parameters'});
saveFigures(hs,filebeg,fileends,fileext,positions,fileformat,reso);

%%

rt_reg = zeros(6,4);
rt_l500reg = zeros(6,4);
rt_localreg = zeros(6,4);
rt_PLS = zeros(6,4);
rt_PLSopt = zeros(6,4);
rt_l500PLS = zeros(6,4);
rt_localPLS = zeros(6,4);

nqs = [25 50 100 200];

merkit = {'--o','--+','--x','-o','-*','-+','-o'};


for i = 1:6
    for j = 1:4
        %Division by 7 to get runtime per single dataset (100 datasets, 16
        %cores)
        rt_reg(i,j) = results_reg(i,j).runtime./7;
        rt_l500reg(i,j) = results_l500reg(i,j).runtime./7;
        rt_localreg(i,j) = results_localreg(i,j).runtime./7;
        
        rt_PLS(i,j) = results_PLS(i,j).runtime./7;
        rt_PLSopt(i,j) = results_PLSopt(i,j).runtime./7;
        rt_l500PLS(i,j) = results_l500PLS(i,j).runtime./7;
        rt_localPLS(i,j) = results_localPLS(i,j).runtime./7;
    end
end

h = figure;

for i = 1:6
    subplot(2,3,i);
    
    loglog(nqs,rt_reg(i,:),merkit{1});
    hold on
    loglog(nqs,rt_l500reg(i,:),merkit{2});
    loglog(nqs,rt_localreg(i,:),merkit{3});
    loglog(nqs,rt_PLS(i,:),merkit{4});
    loglog(nqs,rt_PLSopt(i,:),merkit{5});
    loglog(nqs,rt_l500PLS(i,:),merkit{6});
    loglog(nqs,rt_localPLS(i,:),merkit{7});
    
    niteri = 12500*2^i;
    title(['N=' num2str(niteri,'%u')]); 
    
    axis([25 200 0.05 50000]);
    set(gca,'Fontsize',7)
    set(gca,'YTick',[0.1 1 10 100 1000 10000])    
    set(gca,'YTickLabel',[0.1 1 10 100 1000 10000])    
    set(gca,'XTick',nqs)    
    if i>3
        xlabel('Number of summaries')
    end
    if rem(i,3)==1
        ylabel('Seconds per dataset');
    end
    if i == 6
        legend(reductions,'Position',[0.76 0.12 0.14 0.14],'fontsize',6)
    end
end
 
saveFigures(h,filebeg,{'runtime'},fileext,positionsdim,fileformat,reso);

    



        