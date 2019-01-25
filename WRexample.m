load results\WRSimulations.mat

reducpars = struct;
reducpars.Nvalid = 20;
reducpars.maxncomp = 15;
reducpars.nsamples = 100;

nqp = 10;
qs = logspace(-1.5,0,nqp+1);
reducpars.qs =  qs(1:(end-1));


clear results_reg;
clear results_l500reg;
clear results_localreg;
clear results_PLS;
clear results_PLSopt;
clear results_l500PLS;
clear results_localPLS;

clear results_n0_reg;
clear results_n0_l500reg;
clear results_n0_localreg;
clear results_n0_PLS;
clear results_n0_PLSopt;
clear results_n0_l500PLS;
clear results_n0_localPLS;

results_reg = testAnalyses(S4,Sobs4,theta,thetaobs,'reg',reducpars);
results_PLS = testAnalyses(S4,Sobs4,theta,thetaobs,'PLS',reducpars);
results_PLSopt = testAnalyses(S4,Sobs4,theta,thetaobs,'PLSopt',reducpars);
results_l500reg = testAnalyses(S4,Sobs4,theta,thetaobs,'l500reg',reducpars);
results_localreg = testAnalyses(S4,Sobs4,theta,thetaobs,'localreg',reducpars);
results_l500PLS = testAnalyses(S4,Sobs4,theta,thetaobs,'l500PLS',reducpars);
results_localPLS = testAnalyses(S4,Sobs4,theta,thetaobs,'localPLS',reducpars);

no0 = (any(S4,2)>0); %only simulations for which there is data

results_n0_reg = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'reg',reducpars);
results_n0_PLS = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'PLS',reducpars);
results_n0_PLSopt = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'PLSopt',reducpars);
results_n0_l500reg = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'l500reg',reducpars);
results_n0_localreg = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'localreg',reducpars);
results_n0_l500PLS = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'l500PLS',reducpars);
results_n0_localPLS = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'localPLS',reducpars);

save results/WRResults.mat

results_l500reg_plain = testAnalyses(S4,Sobs4,theta,thetaobs,'l500reg_plain',reducpars);
results_localreg_plain = testAnalyses(S4,Sobs4,theta,thetaobs,'localreg_plain',reducpars);
results_n0_l500reg_plain = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'l500reg_plain',reducpars);
results_n0_localreg_plain = testAnalyses(S4(no0,:),Sobs4,theta(no0,:),thetaobs,'localreg_plain',reducpars);
