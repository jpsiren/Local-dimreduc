reductions = {'Reg', 'localReg', 'localRegopt', 'PLS', 'PLSopt', 'localPLS', 'localPLSopt'};
parameters = {'$\log(q)$','$\zeta_d$','$\zeta_s$','$\nu_f$', ...
    '$\log(-\nu_a)$','$\log(\alpha)$','$\mathrm{logit}(p^J)$', ...
    '$\nu_j$','$ \log(\mu)$','$\eta_1$','$\log(\eta_2)$','$\log(-\eta_3)$','$\log(\eta_4)$'};

fileext = '.eps';
fileformat = '-depsc';
filebeg = ['C:\Users\sirenj5\work\Pr\dimReduc\figures\WR_'];
reso = '-r300';

pos1 = [2 2 18 15];
pos2 = [2 2 9 8];
pos3 = [2 2 18 8];

%%
[hs,MRMSE] = drawResults({results_reg, results_l500reg, results_localreg,results_PLS,results_PLSopt,results_l500PLS, results_localPLS},reductions,parameters,{'Parameters'});

fileends = {'RMSE_all','RMSE_sum'};
positions = [pos1;pos2];

saveFigures(hs,filebeg,fileends,fileext,positions,fileformat,reso);

%%

[hs,MRMSE_n0] = drawResults({results_n0_reg, results_n0_l500reg,results_n0_localreg,results_n0_PLS,results_n0_PLSopt,results_n0_l500PLS, results_n0_localPLS},reductions,parameters,{'Parameters'});

fileends = {'no0_RMSE_all','no0_RMSE_sum'};
positions = [pos1;pos2];

saveFigures(hs,filebeg,fileends,fileext,positions,fileformat,reso);

%%

h = plotRRMSE([MRMSE MRMSE_n0],{'All simulations','Positive simulations'},reductions);
apu = allchild(h);
ymin = min([apu(end-1).YLim apu(end).YLim]);
ymax = max([apu(end-1).YLim apu(end).YLim]);

apu(end-1).YLim = [ymin ymax];
apu(end).YLim = [ymin ymax];

fileends = {'all_vs_no0_RMSE_sum'};
positions = pos3;
saveFigures(h,filebeg,fileends,fileext,positions,fileformat,reso);

%%

[hs,MRMSEb] = drawResults({results_reg, results_l500reg_plain, results_localreg_plain,results_PLS,results_PLSopt,results_l500PLS, results_localPLS},reductions,parameters,{'Parameters'});

fileends = {'RMSE_allb','RMSE_sumb'};
positions = [pos1;pos2];

saveFigures(hs,filebeg,fileends,fileext,positions,fileformat,reso);

%%

[hs,MRMSE_n0b] = drawResults({results_n0_reg, results_n0_l500reg_plain,results_n0_localreg_plain,results_n0_PLS,results_n0_PLSopt,results_n0_l500PLS, results_n0_localPLS},reductions,parameters,{'Parameters'});

fileends = {'no0_RMSE_allb','no0_RMSE_sumb'};
positions = [pos1;pos2];

saveFigures(hs,filebeg,fileends,fileext,positions,fileformat,reso);

%%

h = plotRRMSE([MRMSEb MRMSE_n0b],{'All simulations','Positive simulations'},reductions);
apu = allchild(h);
ymin = min([apu(end-1).YLim apu(end).YLim]);
ymax = max([apu(end-1).YLim apu(end).YLim]);

apu(end-1).YLim = [ymin ymax];
apu(end).YLim = [ymin ymax];

fileends = {'all_vs_no0_RMSE_sumb'};
positions = pos3;
saveFigures(h,filebeg,fileends,fileext,positions,fileformat,reso);


%%

ncq = [0.05;0.95];

ncompsall = [results_PLS.ncomps results_PLSopt.ncomps ...
    results_l500PLS.ncompsi results_l500PLS.ncompsl ...
    results_localPLS.ncompsi results_localPLS.ncompsl];

mncomps = mean(ncompsall)
qncomps = quantile(ncompsall,ncq)

alfaall = [results_localreg.qopt results_localPLS.qopt];

malfa = mean(alfaall)
qalfa = quantile(alfaall,ncq)

ncompsall_n0 = [results_n0_PLS.ncomps results_n0_PLSopt.ncomps ...
    results_n0_l500PLS.ncompsi results_n0_l500PLS.ncompsl ...
    results_n0_localPLS.ncompsi results_n0_localPLS.ncompsl];

mncomps_n0 = mean(ncompsall_n0)
qncomps_n0 = quantile(ncompsall_n0,ncq)

alfaall_n0 = [results_n0_localreg.qopt results_n0_localPLS.qopt];

malfa_n0 = mean(alfaall_n0)
qalfa_n0 = quantile(alfaall_n0,ncq)