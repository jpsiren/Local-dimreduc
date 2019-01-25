%% Preliminaries

ngk = 1e4; %Number of samples in each dataset
nth = 4;

% Parameters for the summaries:
nq = 200;
quantiles = (1/(2*nq)):(1/nq):1;
powers = 1;

%% Simulating data

% Observed data

ntestdata = 1e2;
thetaobs = repmat([3 1 2 0.5],ntestdata,1);
Sobs_all = generateSimulationsGK(thetaobs,ngk,quantiles,powers);

% Simulations

niter = 8e5;
theta_all = 10*rand(niter,nth);
disp('!');
tic
S_all = generateSimulationsGK(theta_all,ngk,quantiles,powers);
toc

%% Subsets of simulations

nqs = 4; %Number of different numbers of quantiles used
nits = 6; %Number of different numbers of iterations used

Sobs = cell(1,nqs);

S = cell(nits,nqs);

theta = cell(nits,1);

for i = 1:nqs
    qin1 = max(2^(i-2),1);
    qint = 2^(i-1);
    qins = qin1:qint:nq;
    
    Sobs{1,nqs+1-i} = Sobs_all(:,qins);
    
    for j = 1:nits;
        niterj = niter/2^(nits-j);
        S{j,nqs+1-i} = S_all(1:niterj,qins);
        if i == 1
            theta{j,1} = theta_all(1:niterj,:);
        end
    end
end

save('gkSimulations.mat', '-v7.3');

%% Dimension reductions

reducpars = struct;
reducpars.Nvalid = 10;
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

for i = 1:nqs
    Sobsi = Sobs{i};
    for j = 1:nits
        tic
        Sij = S{j,i};
        thetaj = theta{j,1};
        
        results_reg(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'reg',reducpars);
        
        results_PLS(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'PLS',reducpars);
        results_PLSopt(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'PLSopt',reducpars);

        results_l500reg(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'l500reg',reducpars);
        results_localreg(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'localreg',reducpars);
        
        results_l500PLS(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'l500PLS',reducpars);
        results_localPLS(j,i) = testAnalyses(Sij,Sobsi,thetaj,thetaobs,'localPLS',reducpars);
        toc
        disp([i j]);
    end
end

clear c;
clear S; clear S_all; clear Sobs; clear Sobs_all; clear theta_all; clear theta; clear thetaobs;

save('results/gkResults.mat', '-v7.3');    









