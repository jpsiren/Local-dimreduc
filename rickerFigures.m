reductions = {'Reg', 'localReg', 'localRegopt', 'PLS', 'PLSopt', 'localPLS', 'localPLSopt'};
parameters = {'log($r$)','$\sigma_e$','$\phi$'};

hs = drawResults({results_reg,results_l500reg ,results_localreg,results_PLS,results_PLSopt,results_l500PLS,results_localPLS},reductions,parameters,{''});

fileext = '.eps';
fileends = {'RMSE_all','RMSE_av'};
filebeg = ['C:\Users\sirenj5\work\Pr\dimReduc\figures\ricker_'];
reso = '-r300';
fileformat = '-depsc';

positions = [2 2 18 8;2 2 9 8];

% Scale the y-axis of the average RMSE figure to better show the
% differences. This will removen from the plot some very bad results with 
% localReg

hh = get(hs(2),'Children');
hh.YLim = [0 20];


saveFigures(hs,filebeg,fileends,fileext,positions,fileformat,reso);


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