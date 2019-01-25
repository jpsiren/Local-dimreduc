%% Simulating data

N0 = 1;
datains = [false(1,50) true(1,50)];


% Observed data

ntestdata = 1e2;
thetaobs = [repmat(3.8,ntestdata,1) exp(linspace(log(0.1),0,ntestdata))' repmat(10,ntestdata,1)];
yobs = simulateRickermap(thetaobs,N0,datains);
Sobs = rickerSummaries(yobs);

% Simulations

niter = 1e6;
thmin = [0 log(0.1) 0];
thrange = [10 -log(0.1) 100];
theta = repmat(thmin,niter,1) + repmat(thrange,niter,1).*rand(niter,3);
theta(:,2) = exp(theta(:,2));

tic
y = simulateRickermap(theta,N0,datains);
S = rickerSummaries(y);
toc

clear yobs; clear y;

save('results/rickerSimulations.mat', '-v7.3');

%% Dimension reductions


reducpars = struct;
reducpars.Nvalid = 20;
reducpars.maxncomp = 15;
reducpars.nsamples = 100;

clear results_reg;
clear results_l500reg;
clear results_localreg;
clear results_PLS;
clear results_PLSopt;
clear results_l500PLS;
clear results_localPLS;


nqp = 10;
qs = logspace(-1.5,0,nqp+1);
reducpars.qs =  qs(1:(end-1));


results_reg = testAnalyses(S,Sobs,theta,thetaobs,'reg',reducpars);

results_PLS = testAnalyses(S,Sobs,theta,thetaobs,'PLS',reducpars);
results_PLSopt = testAnalyses(S,Sobs,theta,thetaobs,'PLSopt',reducpars);

results_l500reg = testAnalyses(S,Sobs,theta,thetaobs,'l500reg',reducpars);
results_localreg = testAnalyses(S,Sobs,theta,thetaobs,'localreg',reducpars);

results_l500PLS = testAnalyses(S,Sobs,theta,thetaobs,'l500PLS',reducpars);
results_localPLS = testAnalyses(S,Sobs,theta,thetaobs,'localPLS',reducpars);


clear S; clear Sobs;   clear theta; clear thetaobs;

save('results/rickerResults.mat', '-v7.3');    







